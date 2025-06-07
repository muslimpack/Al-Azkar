import 'package:alazkar/src/features/search/presentation/components/squiggly_line_painter.dart';
import 'package:flutter/material.dart';

class NoMoreItemsIndicatorBuilder extends StatelessWidget {
  const NoMoreItemsIndicatorBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color lineColor = Theme.of(context).dividerColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 10),
              painter: SquigglyLinePainter(color: lineColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "لا مزيد من النتائج",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 10),
              painter: SquigglyLinePainter(color: lineColor),
            ),
          ),
        ],
      ),
    );
  }
}
