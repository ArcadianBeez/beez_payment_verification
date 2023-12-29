import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:image_picker/image_picker.dart';

import 'dialog_instructions_upload.dart';
import 'package:http/http.dart' as http;

class ImageTransferBankPicker extends StatefulWidget {
  final String bankName;
  final String token;

  final Function(XFile) onFilePicked;

   ImageTransferBankPicker({Key? key, required this.bankName, required this.token, required this.onFilePicked}) : super(key: key);

  @override
  State<ImageTransferBankPicker> createState() => _ImageTransferBankPickerState();
}

class _ImageTransferBankPickerState extends State<ImageTransferBankPicker> {

  XFile? pickedFile;
  File? imageFile;
  XFile? image;
  Uint8List? imageBytes;
  bool visibleInfoImage = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return         Center(
      child: Container(
        constraints:
        BoxConstraints(maxWidth: 1200),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          visibleInfoImage =
                          false;
                        });
                        // if (_con.plan!.status ==
                        //     0) {
                        _showDialogWithInstructions();
                     //   }
                      },
                      child: Container(
                        margin: EdgeInsets
                            .symmetric(
                            horizontal: 25,
                            vertical: 16),
                        width: MediaQuery.of(
                            context)
                            .size
                            .width,
                        height: 500,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(
                                20)),
                        child: DottedBorder(
                            borderType:
                            BorderType
                                .RRect,
                            radius:
                            Radius.circular(
                                20),
                            color: Color(
                                0xFF344968),
                            strokeWidth: 1.2,
                            child: Stack(
                              fit: StackFit
                                  .expand,
                              children: [
                                // _con.plan!.media!
                                //     .isEmpty &&
                                    pickedFile ==
                                        null
                                    ? Center(
                                  child:
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Image.asset(
                                          'assets/img/photo.png',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          'Seleccione la captura de su comprobante de pago',
                                          style: Theme.of(context).textTheme.bodyText1,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                                    :
                                    //(_con.plan!.media != null || _con.plan!.media!.isNotEmpty) &&
                                    pickedFile ==
                                        null
                                    ? Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width,
                                    height:
                                    500,
                                    child:
                         Container()
                                    )
                                    : Center(
                                    child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 600,
                                        child: Image.memory(
                                          imageBytes!,
                                        ))),
                                Positioned(
                                    top: 2,
                                    left: 10,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(
                                                  () {
                                                visibleInfoImage =
                                                !visibleInfoImage;
                                              });
                                        },
                                        child: Container(
                                          height:
                                          20,
                                          width:
                                          20,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: Icon(
                                              Icons.info,
                                              size: 20,
                                              color: Colors.blueAccent),
                                        ))),
                                visibleInfoImage
                                    ? Positioned(
                                    top: 2,
                                    left:
                                    40,
                                    child:
                                    Container(
                                      height:
                                      140,
                                      width:
                                      150,
                                      padding:
                                      EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.blueAccent),
                                      child: Text(
                                          'Recuerda que debes subir el comprobante de pago, aquí te dejamos un tutorial para que no tengas problemas en la aprobación de tu plan',
                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10, color: Colors.white)),
                                    ))
                                    : Container()
                              ],
                            )),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );

  }

  _showDialogWithInstructions() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InstructionsDialog(getFromGalleryCallback: _getFromGallery, bankName: widget.bankName);
      },
    );
  }


  _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
   // imageFile = File(pickedFile!.path);
    if (pickedFile != null) {
      print('selected image');

      image = pickedFile;
      imageBytes = await image!.readAsBytes();
      setState(() {
      });

      widget.onFilePicked(pickedFile!);
      // var response=await uploadImagePlan(widget.token, widget.pickedFile!);
      // print(response);
      // showDialog(context: context, builder: (BuildContext context){
      //   return AlertDialog(
      //     content: Text(response),
      //     actions: [
      //       TextButton(onPressed: (){
      //         Navigator.of(context).pop();
      //       }, child: Text("OK", style: Theme.of(context).textTheme.bodyMedium)),
      //     ],
      //   );
      // });

    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  Future<String> uploadImagePlan(String token, XFile? image) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}validate_image_metadata';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    // Añadir el encabezado de autorización
    request.headers['Authorization'] = 'Bearer $token';

    if (image != null && image.path != '') {
      String fileName = image.path.split('/').last;
      Uint8List data = await image.readAsBytes();
      List<int> list = data.cast();
      request.files.add(http.MultipartFile.fromBytes('file', list, filename: fileName));
    }

    // Corregir la estructura de los datos para que sea un Map en lugar de un Set
    Map<String, String> productObj = {
      "meta_json": json.encode({
        "fileName": "96c96c2f-a611-4d43-a887-c111607d92c8.jpeg",
        "fileSize": "27kB",
        "fileType": "JPEG",
        "fileExtension": "jpg",
        "mimeType": "image/jpeg",
        "jfifVersion": "1.01",
        "resolutionUnit": "None",
        "xResolution": 1,
        "yResolution": 1,
        "imageWidth": 375,
        "imageHeight": 629,
        "encodingProcess": "Progressive DCT, Huffman coding",
        "bitsPerSample": 8,
        "colorComponents": 3,
        "yCbCrSubsampling": "YCbCr4:2:0 (2 2)",
        "imageSize": "375x629",
        "megapixels": 0.236,
        "category": "image"
      })
    };
    request.fields.addAll(productObj);

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print(response.body);
    print(response.statusCode);
    try {
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      if (response.statusCode == 200) {

        return "Image subida exitosamente";
      } else {
        var responseData = json.decode(response.body);
        if (responseData is Map && responseData.containsKey('message')) {
          return responseData['message'];
        } else {
          return "Unknown error occurred";
        }
      }
    } on FormatException catch (e) {
      return "Syntax error, malformed JSON: ${e.message}";
    } catch (e) {
      return "An error occurred: ${e.toString()}";
    }
  }

}
