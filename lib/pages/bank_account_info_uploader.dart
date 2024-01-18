import 'dart:convert';
import 'dart:typed_data';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payment_verification_app/pages/success_page.dart';
import '../elements/bank_account_details.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../elements/image_transfer_bank_picker.dart';
import '../models/bank_transfer_info.dart';
import 'package:http/http.dart' as http;
import 'dart:js' as js;
import 'dart:ui' as ui;

class BankAccountInfoUploader extends StatefulWidget {
  final String jwt;

  const BankAccountInfoUploader({Key? key, required this.jwt})
      : super(key: key);

  @override
  State<BankAccountInfoUploader> createState() =>
      _BankAccountInfoUploaderState();
}

class _BankAccountInfoUploaderState extends State<BankAccountInfoUploader> {
  late BankTransferInfo? bankTransferInfo;
  bool isReady = false;
  XFile? pickedFile;
  bool loading = false;
  String? bankName;
  bool _isChecked = false;

  @override
  void initState() {
    bankTransferInfo = extractJwtPayload(widget.jwt);
    isReady = true;

    super.initState();
  }

  BankTransferInfo? extractJwtPayload(String token) {
    try {
      print('token: $token');
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      return BankTransferInfo.fromJson(payload);
    } catch (e) {
      print('Error al decodificar el token: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isReady && bankTransferInfo != null
          ? Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      BankAccountDetails(bankInfo: bankTransferInfo!),
                      ImageTransferBankPicker(
                        token: widget.jwt,
                        bankName: bankTransferInfo!.bankName ?? 'N/A',
                        onFilePicked: (pickedFile, bankName) {
                          setState(() {
                            this.pickedFile = pickedFile;
                            this.bankName = bankName;

                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width*0.9,
                        child: Row(
                          children: [
                            Checkbox(
                              focusColor: Theme.of(context).colorScheme.secondary,
                              value: _isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _isChecked = newValue!;
                                });
                              },
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: Text(
                                'Confirmo que los datos proporcionados en el certificado de pago son exactos y fidedignos.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).hintColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      MaterialButton(
                          minWidth: 200,
                          height: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () async {
                            if(pickedFile==null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Debes seleccionar una imagen'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }else{
                              if(!_isChecked){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Debes confirmar que los datos son correctos.'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                                return;
                              }else{
                                if (mounted) {
                                  setState(() {
                                    loading = true;
                                  });
                                }
                                var response =
                                await uploadImagePlan(widget.jwt, pickedFile!, bankName!);

                                if (mounted) {
                                  setState(() {
                                    loading = false;
                                  });

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => SuccessPage(response: response)),
                                  );
                              }


    }


                              // buildShowDialogResponse(context, response);




                            }
                          },
                          child: SizedBox(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ENVIAR',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                          color: Theme.of(context).hintColor,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1,
                                          fontSize: 18),
                                ),
                                const SizedBox(width: 10),
                                Icon(Icons.upload_rounded,
                                    color: Theme.of(context).hintColor)
                              ],
                            ),
                          )),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                if (loading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            )
          : const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Token Inválido'),
                Text('Por favor, contacte al administrador')
              ],
            )),
    );
  }

  Future<dynamic> buildShowDialogResponse(context, String response) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  response == 'Comprobante cargado con éxito'
                      ? Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Colors.green.withOpacity(1),
                                    Colors.green.withOpacity(0.2),
                                  ])),
                          child: const FlareActor(
                            'assets/img/check.flr',
                            animation: "Untitled",
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 20),
                  Text(
                    response,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4!.merge(
                        TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 10),
                  response == 'Comprobante cargado con éxito'?
                  Text(
                      'Pronto revisaremos tu transacción; este proceso suele tardar aproximadamente tres minutos. Una vez que la transacción sea aprobada, continuaremos con el procesamiento de tu pedido.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4!.merge(
                          TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500))):
                  Container(),

                ],
              ),
            ),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          );
        });
  }

  Future<String> uploadImagePlan(String token, XFile? image, String bankName) async {
    var Sizes = getScreenSize();
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}validate_image_metadata';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    request.headers['Authorization'] = 'Bearer $token';

    if (image != null && image.path != '') {
      String fileName = image.path.split('/').last;
      int fileSize = await image.length();
      String fileType = image.mimeType.toString();
      var lastModified = await image.lastModified();
      String screenHeight = Sizes['height'].toString();
      String screenWidth = Sizes['width'].toString();

      Uint8List imageData = await image.readAsBytes();
      ui.Image decodedImage = await decodeImageFromList(imageData);
      String imageWidth = decodedImage.width.toString();
      String imageHeight = decodedImage.height.toString();

      Uint8List data = await image.readAsBytes();
      List<int> list = data.cast();
      request.files
          .add(http.MultipartFile.fromBytes('file', list, filename: fileName));

      Map<String, String> fileDetails = {
        "meta_json": json.encode({
          "fileName": fileName,
          "fileSize": "${fileSize}B",
          "fileType": fileType.split('/').last.toUpperCase(),
          "fileExtension": fileName.split('.').last,
          "mimeType": fileType,
          "lastModified": lastModified.toString(),
          "screenWidth": screenWidth,
          "screenHeight": screenHeight,
          "imageWidth": imageWidth,
          "imageHeight": imageHeight,
          'bankName': bankName,
        })
      };
      request.fields.addAll(fileDetails);
    }

    var res = await request.send();
    var response = await http.Response.fromStream(res);

    if (response.statusCode == 200) {
      return "Comprobante cargado con éxito";
    } else {
      var responseData = json.decode(response.body);
      if (responseData is Map && responseData.containsKey('message')) {
        return responseData['message'];
      } else {
        return "Unknown error occurred";
      }
    }
  }

  Map<String, num> getScreenSize() {
    var screenSize = js.context.callMethod('getRealScreenSize');
    Map<String, num> values = {
      'width': screenSize['width'] * MediaQuery.of(context).devicePixelRatio,
      'height': screenSize['height'] * MediaQuery.of(context).devicePixelRatio,
    };

    return values;
  }
}
