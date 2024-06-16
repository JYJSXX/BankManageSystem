import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class ImageLoad extends StatefulWidget {
  @override
  _ImageLoadState createState() => _ImageLoadState();
}

class _ImageLoadState extends State<ImageLoad> {
  html.File? _image;
  String? _imageUrl;

  void _pickImage() {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/jpeg, image/png';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        setState(() {
          _image = files[0];
        });
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final url = Uri(host: "127.0.0.1", port: 8080, path: "/test");
    
    final reader = html.FileReader();
    reader.readAsDataUrl(_image!);
    reader.onLoadEnd.listen((event) async {
      final fileBytes = reader.result as String;
      final base64Image = fileBytes.split(',').last;
      final response = await user.uploadAvatar(base64Image);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        setState(() {
          Navigator.pop(context);
        });
      } else {
        setState(() {
          _imageUrl = 'Failed to upload image: ${response.statusCode}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Web Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageUrl != null
                ? Text(_imageUrl!)
                : Text('No image selected.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}