import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';//impendensi

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _cameraState();
}

class _cameraState extends State<Camera> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Color.fromARGB(255, 247, 233, 194) ,
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 247, 233, 194),),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [                    
             SizedBox(
              height: 20,
            ),
            MaterialButton(
              color: Colors.blue,
              child: const Text(
                "Pick Image from Gallery",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              onPressed: () {
                _pickImageFromGallery();
              },
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.red,
              child: const Text(
                "Pick Image from Camera",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              onPressed: () {
                _pickImageFromCamera();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Align(alignment: Alignment.bottomCenter),
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : const Text('Please selected an image')
          ],
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }
}
