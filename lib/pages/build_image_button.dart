import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BuildImageButton extends StatefulWidget {
  List<File> list;
  final VoidCallback onImageChange;
  BuildImageButton(this.list, this.onImageChange, {super.key});

  @override
  State<BuildImageButton> createState() => _BuildImageButtonState();
}

class _BuildImageButtonState extends State<BuildImageButton> {
  final picker = ImagePicker();
  File? image;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        // if (image!=null)
        if (!widget.list.contains(image)) widget.list.add(image!);
        // System.out.println(list);
        // print(widget.list);
        widget.onImageChange();
        print(widget.list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: image != null
                      ? DecorationImage(
                          image: FileImage(image!), fit: BoxFit.cover)
                      : null,
                  border:
                      Border.all(color: Colors.grey, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: image == null
                    ? Icon(Icons.add, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.list.remove(image);
                        image = null;
                        widget.onImageChange();
                        print(widget.list);
                      });
                    },
                    child: Icon(Icons.close)))
          ]),
        ],
      ),
    );
  }
}
