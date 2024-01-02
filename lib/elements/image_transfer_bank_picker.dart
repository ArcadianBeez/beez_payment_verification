import 'dart:html';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dialog_instructions_upload.dart';

class ImageTransferBankPicker extends StatefulWidget {
  final String bankName;
  final String token;

  final Function(XFile) onFilePicked;

  const ImageTransferBankPicker(
      {Key? key,
      required this.bankName,
      required this.token,
      required this.onFilePicked})
      : super(key: key);

  @override
  State<ImageTransferBankPicker> createState() =>
      _ImageTransferBankPickerState();
}

class _ImageTransferBankPickerState extends State<ImageTransferBankPicker> {
  XFile? pickedFile;
  File? imageFile;
  XFile? image;
  Uint8List? imageBytes;
  bool visibleInfoImage = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  visibleInfoImage = false;
                });
                _showDialogWithInstructions();
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 25),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)),
                child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20),
                    color: const Color(0xFF344968),
                    strokeWidth: 1.2,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        pickedFile == null
                            ? Center(
                                child: Column(
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            :
                            pickedFile == null
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width,
                                    height: 500,
                                    child: Container())
                                : Center(
                                    child: SizedBox(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        height: 600,
                                        child: Image.memory(
                                          imageBytes!,
                                        ))),
                        Positioned(
                            top: 2,
                            left: 10,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    visibleInfoImage = !visibleInfoImage;
                                  });
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child:  Icon(Icons.info,
                                      size: 20,
                                    color: Theme.of(context).colorScheme.secondary,
                                      //color: Colors.green
                                  ),
                                ))),
                        visibleInfoImage
                            ? Positioned(
                                top: 2,
                                left: 40,
                                child: Container(
                                  height: 120,
                                  width: 200,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(5),
                                     // color: Colors.green
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  child: Text(
                                      'Recuerda subir tu comprobante de pago siguiendo las instrucciones de nuestro tutorial para garantizar una aprobación rápida y sin inconvenientes.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                        color: Theme.of(context).hintColor,
                                             // color: Colors.white
                                      )),
                                ))
                            : Container()
                      ],
                    )),
              ),
            ),
          ],
        )
      ],
    );
  }

  _showDialogWithInstructions() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InstructionsDialog(
            getFromGalleryCallback: _getFromGallery, bankName: widget.bankName);
      },
    );
  }

  _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('selected image');
      image = pickedFile;
      imageBytes = await image!.readAsBytes();
      setState(() {});
      widget.onFilePicked(pickedFile!);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }
}
