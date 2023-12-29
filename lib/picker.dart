import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:js' as js;

class ImageSelectorWidget extends StatefulWidget {
  @override
  _ImageSelectorWidgetState createState() => _ImageSelectorWidgetState();
}

class _ImageSelectorWidgetState extends State<ImageSelectorWidget> {
  XFile? pickedFile;
  String lastModified = 'hello';
  String mimeType = 'hello';
  String screenWidth = 'hello';
  String screenHeight = 'hello';

  Future<void> getImage() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      uploadImage(pickedFile!);
    }
  }

  Map<String, num> getScreenSize() {
    var screenSize = js.context.callMethod('getRealScreenSize');
    Map<String, num> values = {
      'width': screenSize['width']* MediaQuery.of(context).devicePixelRatio,
      'height': screenSize['height']* MediaQuery.of(context).devicePixelRatio,
    };

    return values;
  }

  Future<void> uploadImage(XFile image) async {
    var la = await image.lastModified();
    var law = image.mimeType;
    var Sizes = getScreenSize();
    final screenW = MediaQuery.of(context).devicePixelRatio *
        MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).devicePixelRatio *
        MediaQuery.of(context).size.height;

    var request = http.MultipartRequest(
        "POST", Uri.parse("http://192.168.1.12:8888/upload"));
    Map<String, String> headers = {
      "Accept": 'application/json',
    };

    if (image.path != '') {
      String fileName = '${image.path.toString().split('/').last}.jpg';
      print(fileName);
      Uint8List data = await image.readAsBytes();
      List<int> list = data.cast();
      request.files.add(
          http.MultipartFile.fromBytes('image', list, filename: image.name));
      // request.files.add(await http.MultipartFile.fromPath('image', fileName));
    }

    request.headers.addAll(headers);
    var response = await request.send();
    print(response.statusCode);
    print(response.reasonPhrase);

    if (response.statusCode == 200) {
      print('Imagen subida con éxito');
    } else {
      print('Error al subir la imagen: ${response.statusCode}');
    }
    setState(() {
      lastModified = la.toString();
      mimeType = law.toString();
      screenHeight = Sizes['height'].toString();
      screenWidth = Sizes['width'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: getImage,
            child: Text('Seleccionar Imagen'),
          ),
          Text(lastModified.toString()),
          Text(mimeType),
          Text(screenHeight),
          Text(screenWidth),
          //Text(response)
        ],
      ),
    );
  }
}
