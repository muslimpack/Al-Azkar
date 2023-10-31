import 'dart:async';

import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/manager/volume_button_manager.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/core/utils/show_toast.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

part 'zikr_content_viewer_event.dart';
part 'zikr_content_viewer_state.dart';

class ZikrContentViewerBloc
    extends Bloc<ZikrContentViewerEvent, ZikrContentViewerState> {
  final HomeBloc homeBloc;
  final ZikrTitle zikrTitle;
  final PageController pageController = PageController(
    viewportFraction: 1.004,
  );
  static final MethodChannel _volumeBtnChannel = VolumeButtonManager.channel;

  ZikrContentViewerBloc(this.zikrTitle, {required this.homeBloc})
      : super(ZikrContentViewerLoadingState()) {
    VolumeButtonManager.setActivationStatus(
      activate: true,
    );
    _volumeBtnChannel.setMethodCallHandler(_activateVolumeHandler);

    on<ZikrContentViewerStartEvent>(_start);
    on<ZikrContentViewerDecreaseEvent>(_decrease);
    on<ZikrContentViewerPageChangeEvent>(_pageChanged);
    on<ZikrContentViewerCopyEvent>(_copy);
    on<ZikrContentViewerShareEvent>(_share);
    on<ZikrContentViewerNextTitleEvent>(_nextTitle);
    on<ZikrContentViewerPerviousTitleEvent>(_perviousTitle);

    add(ZikrContentViewerStartEvent(zikrTitle));

    pageController.addListener(() {
      final state = this.state;
      if (state is ZikrContentViewerLoadedState) {
        final int index = pageController.page!.round();

        add(ZikrContentViewerPageChangeEvent(index));
      }
    });
  }

  FutureOr<void> _start(
    ZikrContentViewerStartEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    emit(ZikrContentViewerLoadingState());

    final azkarToSet =
        await azkarDBHelper.getContentByTitleId(event.zikrTitle.id);

    emit(
      ZikrContentViewerLoadedState(
        zikrTitle: event.zikrTitle,
        azkar: azkarToSet,
        activeZikrIndex: 0,
      ),
    );
  }

  FutureOr<void> _decrease(
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

  FutureOr<void> _pageChanged(
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

  FutureOr<void> _copy(
    ZikrContentViewerCopyEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    await Clipboard.setData(ClipboardData(text: state.activeZikr.body));

    showToast("تم نسخ الذكر");
  }

  FutureOr<void> _share(
    ZikrContentViewerShareEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    Share.share(state.activeZikr.body);
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

  FutureOr<void> _nextTitle(
    ZikrContentViewerNextTitleEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    final homeState = homeBloc.state;
    if (homeState is! HomeLoadedState) return;

    try {
      final int currentTitleIndex =
          homeState.titles.indexWhere((e) => e.id == state.zikrTitle.id);
      appPrint(currentTitleIndex);
      if (currentTitleIndex == -1 ||
          currentTitleIndex == homeState.titles.length - 1) return;
      add(ZikrContentViewerStartEvent(homeState.titles[currentTitleIndex + 1]));
    } catch (e) {
      appPrint(e);
    }
  }

  FutureOr<void> _perviousTitle(
    ZikrContentViewerPerviousTitleEvent event,
    Emitter<ZikrContentViewerState> emit,
  ) async {
    final state = this.state;
    if (state is! ZikrContentViewerLoadedState) return;

    final homeState = homeBloc.state;
    if (homeState is! HomeLoadedState) return;

    try {
      final int currentTitleIndex =
          homeState.titles.indexWhere((e) => e.id == state.zikrTitle.id);
      if (currentTitleIndex == -1 || currentTitleIndex == 0) return;
      add(ZikrContentViewerStartEvent(homeState.titles[currentTitleIndex - 1]));
    } catch (e) {
      appPrint(e);
    }
  }
}
