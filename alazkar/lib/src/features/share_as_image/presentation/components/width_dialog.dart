import 'package:alazkar/src/core/inputs/user_number_field.dart';
import 'package:flutter/material.dart';

class ImageWidthDialog extends StatelessWidget {
  final Function(String) onSubmit;
  final String initialValue;

  const ImageWidthDialog({
    super.key,
    required this.onSubmit,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController widthController =
        TextEditingController(text: initialValue);
    return AlertDialog(
      title: const Text(
        "تغيير عرض الصورة",
        style: TextStyle(
          fontSize: 25,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserNumberField(
            controller: widthController,
            hintText: "قم بادخال العرض هنا",
          ),
          const Text(
            "أقل عرض للصورة: 600",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text(
            "تم",
            textAlign: TextAlign.center,
            // style: TextStyle(fontSize: 20, color: QuranTheme.baseColor),
          ),
          onPressed: () {
            onSubmit(widthController.text);
            Navigator.pop<bool>(context, true);
          },
        ),
      ],
    );
  }
}
