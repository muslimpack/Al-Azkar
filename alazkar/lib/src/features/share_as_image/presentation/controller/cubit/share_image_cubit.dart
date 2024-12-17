import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:alazkar/src/core/extension/extension_platform.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/share_as_image/data/models/shareable_image_card_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:capture_widget/core/widget_capture_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'share_image_state.dart';

class ShareImageCubit extends Cubit<ShareImageState> {
  final PageController pageController = PageController();

  late final List<GlobalKey> imageKeys;

  ShareImageCubit() : super(ShareImageLoadingState());

  Future onPageChanged(int index) async {
    final state = this.state;
    if (state is! ShareImageLoadedState) return;

    emit(state.copyWith(activeIndex: index));
  }

  int charPer1080(int standardLength, String text) {
    if (text.length < standardLength) {
      return standardLength;
    }

    final chunkCount = (text.length / standardLength).ceil();

    final charLength = text.length ~/ chunkCount;
    final overflowChars = text.length % chunkCount;
    final result = charLength + overflowChars;

    appPrint(overflowChars);

    return result + 2;
  }

  FutureOr start({
    required Zikr zikr,
    required ZikrTitle zikrTitle,
  }) async {
    final settings =
        const ShareableImageCardSettings.defaultSettings().copyWith(
      charLengthPerSize: 560,
    );

    final charsPerChunk = charPer1080(settings.charLengthPerSize, zikr.body);

    final List<TextRange> splittedMatnRanges = splitStringIntoChunksRange(
      zikr.body,
      charsPerChunk,
    );

    imageKeys =
        List.generate(splittedMatnRanges.length, (index) => GlobalKey());

    emit(
      ShareImageLoadedState(
        zika: zikr,
        zikrTitle: zikrTitle,
        showLoadingIndicator: false,
        settings: settings.copyWith(charLengthPerSize: charsPerChunk),
        splittedMatn: splittedMatnRanges,
        activeIndex: 0,
      ),
    );
  }

  ///MARK: Split

  List<TextRange> splitStringIntoChunksRange(String text, int charsPerChunk) {
    // Split the text into individual words
    final List<String> words = text.split(' ');
    final List<TextRange> chunkIndices = [];

    int chunkStart = 0;
    int chunkCharCount = 0;
    int start = 0;
    String currentChunk = '';

    for (final String word in words) {
      // Get the word's position in the original text
      final int wordStart = text.indexOf(word, start);
      final int wordEnd = wordStart + word.length;

      // Check if adding the word will exceed charsPerChunk
      if (chunkCharCount + word.length + 1 <= charsPerChunk) {
        // Add the word to the current chunk
        currentChunk += (currentChunk.isEmpty ? word : ' $word');
        chunkCharCount = currentChunk.length;
        start = wordEnd;
      } else {
        // If current chunk size is valid, add it to the list of ranges
        if (chunkCharCount >= charsPerChunk / 3) {
          chunkIndices.add(TextRange(start: chunkStart, end: wordStart));

          // Start a new chunk with the current word
          currentChunk = word;
          chunkCharCount = word.length;
          chunkStart = wordStart;
        } else {
          // Merge small chunk into the previous one
          if (chunkIndices.isNotEmpty) {
            chunkIndices.last =
                TextRange(start: chunkIndices.last.start, end: wordEnd);
          } else {
            chunkIndices.add(TextRange(start: chunkStart, end: wordEnd));
          }
          currentChunk = word;
          chunkStart = wordStart;
        }

        start = wordEnd;
      }
    }

    // Add the last chunk if it's non-empty
    if (currentChunk.isNotEmpty) {
      chunkIndices.add(TextRange(start: chunkStart, end: text.length));
    }

    return chunkIndices;
  }

  /// MARK: share Image

  Future<void> shareImage(bool shareAll) async {
    final state = this.state;
    if (state is! ShareImageLoadedState) return;

    emit(state.copyWith(showLoadingIndicator: true));

    try {
      const double pixelRatio = 2;

      final List<ByteData> filesData = [];
      final List<String> filesName = [];

      if (shareAll) {
        for (var i = 0; i < state.splittedMatn.length; i++) {
          final captureWidgetController =
              CaptureWidgetController(imageKey: imageKeys[i]);
          final image = await captureWidgetController.getImage(pixelRatio);
          final byteData = await image?.toByteData(format: ImageByteFormat.png);

          if (byteData == null) continue;

          final fileName = _getHadithOutputFileName(
            state.zika,
            i,
            state.splittedMatn.length,
          );
          filesData.add(byteData);
          filesName.add(fileName);
        }
      } else {
        final captureWidgetController =
            CaptureWidgetController(imageKey: imageKeys[state.activeIndex]);
        final image = await captureWidgetController.getImage(pixelRatio);

        final byteData = await image?.toByteData(format: ImageByteFormat.png);

        if (byteData == null) return;

        final fileName = _getHadithOutputFileName(
          state.zika,
          state.activeIndex,
          state.splittedMatn.length,
        );

        filesData.add(byteData);
        filesName.add(fileName);
      }

      appPrint(filesData.length);
      appPrint(filesName);

      if (PlatformExtension.isDesktop) {
        await _saveDesktop(filesData, fileName: filesName);
      } else {
        await _savePhone(filesData);
      }
    } catch (e) {
      appPrint(e.toString());
    }

    emit(state.copyWith(showLoadingIndicator: false));
  }

  ///MARK: save Image

  String _getHadithOutputFileName(Zikr zikr, int index, int length) {
    return _getOutputFileName(
      "Alkamel-${zikr.id}_${index + 1}_of_$length",
    );
  }

  String _getOutputFileName(String outputFileName) {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final fileName = "$outputFileName-$timestamp.png";
    return fileName;
  }

  Future _saveDesktop(
    List<ByteData> filesData, {
    required List<String> fileName,
  }) async {
    final String? dir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Please select an output file:',
    );

    if (dir == null) return;

    appPrint(dir);

    for (var i = 0; i < filesData.length; i++) {
      final Uint8List uint8List = filesData[i].buffer.asUint8List();
      final File file = File(path.join(dir, fileName[i]));
      await file.writeAsBytes(uint8List);
    }
  }

  Future _savePhone(List<ByteData> filesData) async {
    final tempDir = await getTemporaryDirectory();

    final List<XFile> xFiles = [];
    for (int i = 0; i < filesData.length; i++) {
      final File file =
          await File('${tempDir.path}/SharedImage$i.png').create();
      await file.writeAsBytes(filesData[i].buffer.asUint8List());
      xFiles.add(XFile(file.path));
    }

    await Share.shareXFiles(xFiles);

    for (final file in xFiles) {
      await File(file.path).delete();
    }
  }

  /// **************************

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
