import 'dart:async';

import 'package:alazkar/app.dart';
import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/manager/volume_button_manager.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_extension.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/core/utils/show_toast.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:alazkar/src/features/settings/data/repository/settings_storage.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/components/zikr_share_dialog.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_list_extension.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/repository/zikr_filter_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'zikr_content_viewer_event.dart';
part 'zikr_content_viewer_state.dart';

class ZikrContentViewerBloc
    extends Bloc<ZikrContentViewerEvent, ZikrContentViewerState> {
  final HomeBloc homeBloc;
  final SettingsStorage settingsStorage;
  final ZikrFilterStorage zikrFilterStorage;
  final AzkarDBHelper azkarDBHelper;

  final PageController pageController = PageController(
    viewportFraction: 1.004,
  );
  static final MethodChannel _volumeBtnChannel = VolumeButtonManager.channel;

  ZikrContentViewerBloc(
    this.homeBloc,
    this.settingsStorage,
    this.zikrFilterStorage,
    this.azkarDBHelper,
  ) : super(ZikrContentViewerLoadingState()) {
    VolumeButtonManager.setActivationStatus(
      activate: settingsStorage.praiseWithVolumeKeys,
    );
    _volumeBtnChannel.setMethodCallHandler(_activateVolumeHandler);

    on<ZikrContentViewerStartEvent>(_start);
    on<ZikrContentViewerDecreaseEvent>(_decrease);
    on<ZikrContentViewerPageChangeEvent>(_pageChanged);
    on<ZikrContentViewerCopyEvent>(_copy);
    on<ZikrContentViewerShareEvent>(_share);
    on<ZikrContentViewerNextTitleEvent>(_nextTitle);
    on<ZikrContentViewerPerviousTitleEvent>(_perviousTitle);

    pageController.addListener(() {
      final state = this.state;
      if (state is ZikrContentViewerLoadedState) {
        final int index = pageController.page!.round();

        add(ZikrContentViewerPageChangeEvent(index));
      }
    });
  }

  Future<void> _start(
    ZikrContentViewerStartEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    emit(ZikrContentViewerLoadingState());

    final showTextInBrackets = settingsStorage.showTextInBrackets();
    final RegExp regExp = RegExp(r'\(.*?\)');

    /// get all zikr
    final List<Zikr> azkarToSet;
    final azkarFromDB =
        (await azkarDBHelper.getContentByTitleId(event.zikrTitleId))
            .map(
              (e) => showTextInBrackets || e.body.contains("QuranText")
                  ? e
                  : e.copyWith(body: e.body.replaceAll(regExp, "")),
            )
            .toList();
    final zikrTitle = await azkarDBHelper.getTitlesById(event.zikrTitleId);

    /// filter out zikr
    final List<Filter> filters = zikrFilterStorage.getAllFilters();
    azkarToSet = filters.getFilteredZikr(azkarFromDB);

    emit(
      ZikrContentViewerLoadedState(
        zikrTitle: zikrTitle,
        azkar: azkarToSet,
        activeZikrIndex: 0,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 250));
    if (pageController.hasClients && event.zikrOrder != null) {
      final index = azkarToSet.indexWhere((e) => e.order == event.zikrOrder);
      if (index > 0) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Future<void> _decrease(
    ZikrContentViewerDecreaseEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    if (event.zikr.count == 0) return;

    final countToSet = event.zikr.count - 1;

    if (countToSet == 0) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    final azkarToSet = state.azkar.map((e) {
      if (e.id != event.zikr.id) return e;
      return e.copyWith(count: countToSet);
    }).toList();

    emit(
      state.copyWith(
        azkar: azkarToSet,
      ),
    );
  }

  Future<void> _pageChanged(
    ZikrContentViewerPageChangeEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    emit(
      state.copyWith(
        activeZikrIndex: event.index,
      ),
    );
  }

  Future<String> sharedZikrText() async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return "";

    if (state.activeZikr == null) return "";
    final Zikr zikrFromDB =
        await azkarDBHelper.getContentById(state.activeZikr!.id);

    final activeZikr = zikrFromDB;
    final fadlTxt = activeZikr.fadl.isEmpty
        ? ""
        : "\n\n-------\nالفضل:\n${activeZikr.fadl}";
    final plainText =
        "${await activeZikr.toPlainText()}\n\n-------\nعدد مرات الذكر:  ${activeZikr.count}$fadlTxt\n\n-------\nالحكم: ${activeZikr.hokm}\n\n==============\nالمصدر:\n${activeZikr.source}";
    return plainText;
  }

  Future<void> _copy(
    ZikrContentViewerCopyEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final plainText = await sharedZikrText();
    if (plainText.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: plainText));

    showToast("تم نسخ الذكر");
  }

  Future<void> _share(
    ZikrContentViewerShareEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    if (state.activeZikr == null || state.azkar.isEmpty) return;

    showDialog(
      context: MyApp.navigatorKey.currentState!.context,
      builder: (context) {
        return ZikrShareDialog(
          zikrId: state.activeZikr!.id,
        );
      },
    );
  }

  Future _activateVolumeHandler(MethodCall call) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    await VolumeButtonManager.handler(
      call: call,
      onVolumeUpPressed: () {
        add(ZikrContentViewerDecreaseEvent(state.azkar[state.activeZikrIndex]));
      },
      onVolumeDownPressed: () {
        add(ZikrContentViewerDecreaseEvent(state.azkar[state.activeZikrIndex]));
      },
    );
  }

  @override
  Future<void> close() {
    VolumeButtonManager.setActivationStatus(
      activate: false,
    );
    return super.close();
  }

  Future<void> _nextTitle(
    ZikrContentViewerNextTitleEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    final homeState = homeBloc.state;
    if (homeState is! HomeLoadedState) return;

    try {
      final titles = homeState.titlesToShow;
      final int currentTitleIndex =
          titles.indexWhere((e) => e.id == state.zikrTitle.id);
      appPrint(currentTitleIndex);
      if (currentTitleIndex == -1 || currentTitleIndex == titles.length - 1) {
        return;
      }
      add(ZikrContentViewerStartEvent(titles[currentTitleIndex + 1].id));
    } catch (e) {
      appPrint(e);
    }
  }

  Future<void> _perviousTitle(
    ZikrContentViewerPerviousTitleEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    final homeState = homeBloc.state;
    if (homeState is! HomeLoadedState) return;

    try {
      final titles = homeState.titlesToShow;
      final int currentTitleIndex =
          titles.indexWhere((e) => e.id == state.zikrTitle.id);
      if (currentTitleIndex == -1 || currentTitleIndex == 0) return;
      add(ZikrContentViewerStartEvent(titles[currentTitleIndex - 1].id));
    } catch (e) {
      appPrint(e);
    }
  }
}
