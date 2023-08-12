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
    return InkWell(
      onTap: () {
        context
            .read<ZikrContentViewerBloc>()
            .add(ZikrContentViewerDecreaseEvent(zikr));
      },
      child: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: .5,
              child: Text(
                zikr.count == 0 ? "تم" : zikr.count.toString(),
                style: const TextStyle(
                  fontSize: 200,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
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
                style: const TextStyle(
                  fontFamily: "Kitab",
                  fontSize: 30,
                  height: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
