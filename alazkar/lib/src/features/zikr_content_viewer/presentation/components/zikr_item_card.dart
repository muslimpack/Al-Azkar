import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZikrItemCard extends StatelessWidget {
  final Zikr zikr;
  const ZikrItemCard({
    super.key,
    required this.zikr,
  });

  @override
  Widget build(BuildContext context) {
    final isAyah = zikr.body.contains("﴿");
    return InkWell(
      onTap: () {
        context
            .read<ZikrContentViewerBloc>()
            .add(ZikrContentViewerDecreaseEvent(zikr));
      },
      onLongPress: () {
        final SnackBar snackBar = SnackBar(
          content: Text(zikr.source),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar,
        );
      },
      child: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: .5,
              child: Text(
                zikr.count == 0 ? "تم" : zikr.count.toString(),
                style: TextStyle(
                  fontSize: 200,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ),
          ),
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                zikr.body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: isAyah ? "Uthmanic2" : "Kitab",
                  fontSize: 30,
                  height: 2,
                ),
              ),
              if (zikr.fadl.isNotEmpty) ...[
                const SizedBox(height: 50),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
