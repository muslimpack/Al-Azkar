import 'package:alazkar/src/core/extension/extension_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorSwatchBuilder extends StatelessWidget {
  final List<Color> colorSwatchList;
  final Color colorToTrack;
  final void Function(Color color) apply;

  const ColorSwatchBuilder({
    super.key,
    required this.colorSwatchList,
    required this.colorToTrack,
    required this.apply,
  });

  @override
  Widget build(BuildContext context) {
    Color tempColor = colorToTrack;
    void changeColor(Color color) {
      tempColor = color;
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: SizedBox(
                    width: 300,
                    child: SingleChildScrollView(
                      child: Card(
                        margin: const EdgeInsets.all(20),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          children: [
                            ColorPicker(
                              portraitOnly: true,
                              displayThumbColor: true,
                              paletteType: PaletteType.hsvWithSaturation,
                              colorHistory: colorSwatchList,
                              labelTypes: const [],
                              enableAlpha: false,
                              pickerColor: colorToTrack,
                              onColorChanged: changeColor,
                              onHistoryChanged: (value) {},
                            ),
                            ListTile(
                              onTap: () {
                                apply(tempColor);
                                Navigator.pop(context);
                              },
                              title: const Text(
                                "Select color",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Card(
            color: colorToTrack,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                color: colorToTrack.getContrastColor,
                Icons.brush,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
