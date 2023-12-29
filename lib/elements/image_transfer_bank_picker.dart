import 'dart:html';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dialog_instructions_upload.dart';

class ImageTransferBankPicker extends StatefulWidget {
  final String bankName;

  const ImageTransferBankPicker({Key? key, required this.bankName}) : super(key: key);

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
    print('shodialogw ');
    print( widget.bankName);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InstructionsDialog(getFromGalleryCallback: _getFromGallery, bankName: widget.bankName);
      },
    );
  }

  // _showDialogWithInstructions() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext contextDialog) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         insetPadding: const EdgeInsets.all(8),
  //         elevation: 10,
  //         titlePadding: const EdgeInsets.all(0.0),
  //         title: Align(
  //             alignment: AlignmentDirectional.topEnd,
  //             child: IconButton(
  //               icon: Icon(Icons.close, color: Theme.of(context).hintColor),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             )),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(
  //                 'Instrucciones al subir su comprabante',
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .headlineMedium!
  //                     .copyWith(fontSize: 14),
  //                 textAlign: TextAlign.center,
  //               ),
  //               Divider(color: Theme.of(context).hintColor),
  //               const SizedBox(height: 10),
  //               Container(
  //                   width: MediaQuery.of(context).size.width * 0.7,
  //                   child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Icon(Icons.check,
  //                                 size: 15, color: Theme.of(context).hintColor),
  //                             Container(
  //                               margin: EdgeInsets.only(left: 5, top: 0),
  //                               width: MediaQuery.of(context).size.width * 0.6,
  //                               child: Text(
  //                                   'Recuerde ingresar una captura nítida donde se puedan apreciar todos los valores de la misma.',
  //                                   style:
  //                                   Theme.of(context).textTheme.bodyText1),
  //                             ),
  //                           ],
  //                         ),
  //                         Divider(color: Theme.of(context).hintColor),
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Icon(Icons.check,
  //                                 size: 15, color: Theme.of(context).hintColor),
  //                             Container(
  //                               margin: EdgeInsets.only(left: 5, top: 0),
  //                               width: MediaQuery.of(context).size.width * 0.6,
  //                               child: Text(
  //                                   'Además debe colocar el correo electrónico correctamente para validar el pago.',
  //                                   style:
  //                                   Theme.of(context).textTheme.bodyText1),
  //                             ),
  //                           ],
  //                         ),
  //                         Divider(color: Theme.of(context).hintColor),
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Icon(Icons.check,
  //                                 size: 15, color: Theme.of(context).hintColor),
  //                             Container(
  //                               margin: EdgeInsets.only(left: 5, top: 0),
  //                               width: MediaQuery.of(context).size.width * 0.6,
  //                               child: Text(
  //                                   'El monto a cancelar debe ser el monto del plan + el IVA.',
  //                                   style:
  //                                   Theme.of(context).textTheme.bodyText1),
  //                             ),
  //                           ],
  //                         ),
  //                         Divider(color: Theme.of(context).hintColor),
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Icon(Icons.check,
  //                                 size: 15, color: Theme.of(context).hintColor),
  //                             Container(
  //                               margin: EdgeInsets.only(left: 5, top: 0),
  //                               width: MediaQuery.of(context).size.width * 0.6,
  //                               child: Text(
  //                                   'Después de cargar la imagen de su comprobante de pago, el sistema verificará los datos y acreditará el monto neto correspondiente en su billetera digital.',
  //                                   style:
  //                                   Theme.of(context).textTheme.bodyText1),
  //                             ),
  //                           ],
  //                         ),
  //                         Divider(color: Theme.of(context).hintColor),
  //                       ])),
  //               SizedBox(height: 10),
  //               Text('Por ejemplo:',
  //                   style: Theme.of(context).textTheme.bodyText1),
  //               SizedBox(height: 5),
  //               Image.asset(
  //                 'assets/img/comprobante.jpeg',
  //                 width: 300,
  //                 height: 400,
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           Container(
  //             padding: EdgeInsets.all(5),
  //             decoration: BoxDecoration(
  //               color: Color(0xFF344968),
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: TextButton(
  //               child: Text('Galeria',
  //                   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
  //                       fontSize: 14,
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w300)),
  //               onPressed: () {
  //                 _getFromGallery();
  //                 Navigator.pop(contextDialog);
  //               },
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
   // imageFile = File(pickedFile!.path);
    if (pickedFile != null) {
      print('selected image');
      String fileName = '${pickedFile!.path.toString().split('/').last}';
      const int maxSizeInBytes = 2 * 1024 * 1024;
      // if ((fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) && await imageFile!.length() > maxSizeInBytes) {
      //   showDialog(
      //     context: _con.scaffoldKey!.currentContext!,
      //     barrierDismissible: false,
      //     builder: (BuildContext context) {
      //       Future.delayed(Duration(seconds: 1), () {
      //         if (Navigator.of(context).canPop()) {
      //           Navigator.of(context).pop();
      //         }
      //       });
      //       return Dialog(
      //         child: Container(
      //             padding: EdgeInsets.all(20),
      //             child: Text("Procesando imagen...")),
      //       );
      //     },
      //   );
      // }
      image = pickedFile;
      imageBytes = await image!.readAsBytes();
      setState(() {});
      // ResponseCreatePlan response =
      // await _con.uploadImageToPlan(pickedFile!, _con.plan!.id!.toString());
    } else {
      print('No image selected.');
    }
    setState(() {});
  }
}
