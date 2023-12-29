import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:image_picker/image_picker.dart';

import '../elements/bank_account_details.dart';

import 'package:jwt_decode/jwt_decode.dart';

import '../elements/image_transfer_bank_picker.dart';
import '../models/bank_transfer_info.dart';
import 'package:http/http.dart' as http;


class BankAccountInfoUploader extends StatefulWidget {
  final String jwt;

  const BankAccountInfoUploader({Key? key, required this.jwt})
      : super(key: key);

  @override
  State<BankAccountInfoUploader> createState() =>
      _BankAccountInfoUploaderState();
}

class _BankAccountInfoUploaderState extends State<BankAccountInfoUploader> {
   late BankTransferInfo bankTransferInfo;
   XFile? pickedFile;


  @override
  void initState() {
    bankTransferInfo= extractJwtPayload(widget.jwt);
    super.initState();
  }

  BankTransferInfo extractJwtPayload(String token) {
   // try {
    print('token: $token');
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      return BankTransferInfo.fromJson(payload);
    // } catch (e) {
    //   print('Error al decodificar el token: $e');
    //   return BankTransferInfo.fromJson({});
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          BankAccountDetails(bankInfo: bankTransferInfo),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total a pagar: ', style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(child: Container()),
                Text(bankTransferInfo.price.toStringAsFixed(2), style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          ),

          ImageTransferBankPicker(
              token: widget.jwt,
              bankName: bankTransferInfo.bankName ?? 'N/A',
            onFilePicked: (pickedFile) {
              setState(() {
                this.pickedFile = pickedFile;
              });
            },

          ),
          MaterialButton(
            minWidth: 200,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () async {
                var response=await uploadImagePlan(widget.jwt, pickedFile!);
                print(response);
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    content: Text(response),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text("OK", style: Theme.of(context).textTheme.bodyMedium)),
                    ],
                  );
                });
            }
          , child: Text('ENVIAR', style: Theme.of(context).textTheme.headline2!.copyWith(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold, fontSize: 15),)),
        ],
      )),
    );
  }

   Future<String> uploadImagePlan(String token, XFile? image) async {
     final String url =
         '${GlobalConfiguration().getValue('api_base_url')}validate_image_metadata';

     var request = http.MultipartRequest(
       'POST',
       Uri.parse(url),
     );

     request.headers['Authorization'] = 'Bearer $token';

     if (image != null && image.path != '') {
       String fileName = image.path.split('/').last;
       Uint8List data = await image.readAsBytes();
       List<int> list = data.cast();
       request.files.add(http.MultipartFile.fromBytes('file', list, filename: fileName));
     }

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

   }
}
