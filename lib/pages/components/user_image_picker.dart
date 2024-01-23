import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File image) onImagePick;

  const UserImagePicker({super.key, required this.onImagePick});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  _pickImage() async {
    final picker = ImagePicker();

    var pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      // maxWidth: 150,
    );

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      setState(() {
        _image = imageFile;
      });

      widget.onImagePick(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _image != null ? FileImage(_image!) : null,
          child: _image != null
              ? null
              : TextButton(
                  onPressed: _pickImage,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image),
                      SizedBox(height: 10, width: 10),
                      FittedBox(
                        child: Text(
                          'Adicionar Imagem',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        if (_image != null)
          TextButton(
            onPressed: _pickImage,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image),
                SizedBox(width: 10),
                Text('Alterar Imagem'),
              ],
            ),
          ),
      ],
    );
  }
}
