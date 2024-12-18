import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:alazkar/src/core/extension/extension_platform.dart';
import 'package:alazkar/src/core/extension/extension_string.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/settings/data/repository/settings_storage.dart';
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
  final SettingsStorage settingsStorage;
  final PageController pageController = PageController();

  late final List<GlobalKey> imageKeys;

  ShareImageCubit(this.settingsStorage) : super(ShareImageLoadingState());

  Future onPageChanged(int index) async {
    final state = this.state;
    if (state is! ShareImageLoadedState) return;

    emit(state.copyWith(activeIndex: index));
  }

  int charPer1080(int standardLength, String text) {
    if (text.length < standardLength) {
      return standardLength;
    }

    final chunkCount = (text.split(" ").length / standardLength).ceil();

    final charLength = text.split(" ").length ~/ chunkCount;
    final overflowChars = text.split(" ").length % chunkCount;
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
      wordsCountPerSize: 120,
    );

    final String proccessedText;

    if (settingsStorage.showTextInBrackets()) {
      proccessedText = zikr.body;
    } else {
      proccessedText = zikr.body.removeTextInBrackets;
    }

    appPrint(proccessedText.split(" ").length);

    final charsPerChunk =
        charPer1080(settings.wordsCountPerSize, proccessedText);

    final List<TextRange> splittedMatnRanges = splitStringIntoChunksRange(
      proccessedText,
      charsPerChunk,
    );

    imageKeys =
        List.generate(splittedMatnRanges.length, (index) => GlobalKey());

    emit(
      ShareImageLoadedState(
        zikr: zikr.copyWith(body: proccessedText),
        zikrTitle: zikrTitle,
        showLoadingIndicator: false,
        settings: settings.copyWith(wordsCountPerSize: charsPerChunk),
        splittedMatn: splittedMatnRanges,
        activeIndex: 0,
      ),
    );
  }

  ///MARK: Split

  List<TextRange> splitStringIntoChunksRange(String text, int wordsPerChunk) {
    // Handle edge cases
    if (text.isEmpty || wordsPerChunk <= 0) {
      return [];
    }

    final List<String> words = text.split(' ');
    final List<TextRange> chunkIndices = [];

    int chunkStart = 0;
    int wordCount = 0;
    int currentPos = 0;

    for (int i = 0; i < words.length; i++) {
      // Get the word's start and end indices in the text
      final String word = words[i];
      final int wordStart = text.indexOf(word, currentPos);
      final int wordEnd = wordStart + word.length;

      if (wordCount < wordsPerChunk) {
        // Add the word to the current chunk
        wordCount++;
        currentPos = wordEnd;
      }

      // If the chunk reaches the word limit, finalize it
      if (wordCount == wordsPerChunk || i == words.length - 1) {
        chunkIndices.add(TextRange(start: chunkStart, end: wordEnd));

        // Start a new chunk
        chunkStart = wordEnd + 1; // Skip the space
        wordCount = 0;
      }
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
            state.zikr,
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
          state.zikr,
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
