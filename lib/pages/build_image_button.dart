import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BuildImageButton extends StatelessWidget {
  final List<File> list;
  final VoidCallback tap;
  final int index;

  BuildImageButton(this.list, this.tap, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: list[index] != null
                  ? DecorationImage(
                      image: FileImage(list[index]), fit: BoxFit.cover)
                  : null,
              border: Border.all(color: Colors.grey, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                list.removeAt(index);
                tap(); // Notify the UI to refresh
              },
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
