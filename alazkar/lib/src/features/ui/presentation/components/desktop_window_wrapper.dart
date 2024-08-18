// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/features/settings/data/repository/settings_storage.dart';
import 'package:alazkar/src/features/ui/presentation/components/windows_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DesktopWindowWrapper extends StatefulWidget {
  final Widget? child;
  const DesktopWindowWrapper({
    super.key,
    this.child,
  });

  @override
  State<DesktopWindowWrapper> createState() => _DesktopWindowWrapperState();
}

class _DesktopWindowWrapperState extends State<DesktopWindowWrapper>
    with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() {
    super.onWindowResize();
    SettingsStorage.changeDesktopWindowSize(MediaQuery.of(context).size);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Column(
          children: [
            const UIAppBar(),
            Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: widget.child ?? const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
