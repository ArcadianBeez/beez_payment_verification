import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../elements/bank_account_details.dart';

import 'package:jwt_decode/jwt_decode.dart';

import '../elements/image_transfer_bank_picker.dart';
import '../models/bank_transfer_info.dart';

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



  @override
  void initState() {
    bankTransferInfo= extractJwtPayload(widget.jwt);
    super.initState();
  }

  BankTransferInfo extractJwtPayload(String token) {
    try {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      return BankTransferInfo.fromJson(payload);
    } catch (e) {
      print('Error al decodificar el token: $e');
      return BankTransferInfo.fromJson({});
    }
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

          ImageTransferBankPicker(bankName: bankTransferInfo.bankName ?? 'N/A'),


          //BankAccountDetails(bankInfo: bankInfo),
        ],
      )),
    );
  }
}
