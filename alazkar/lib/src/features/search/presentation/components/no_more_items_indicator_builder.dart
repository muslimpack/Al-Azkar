import 'package:flutter/material.dart';

class NoMoreItemsIndicatorBuilder extends StatelessWidget {
  const NoMoreItemsIndicatorBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Text(
          "لا مزيد من النتائج",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
