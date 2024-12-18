import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/features/theme/presentation/controller/cubit/theme_cubit.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/components/zikr_content_builder.dart';
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
      onLongPress: () {
        final SnackBar snackBar = SnackBar(
          content: Text("الحكم: ${zikr.hokm}\n\nالمصدر:\n${zikr.source}"),
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
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .1),
                ),
              ),
            ),
          ),
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              ZikrContentBuilder(
                zikr: zikr,
                enableDiacritics: true,
                fontSize: context.read<ThemeCubit>().state.fontSize,
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
