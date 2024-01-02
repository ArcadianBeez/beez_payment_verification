import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/bank_transfer_info.dart';

class BankAccountDetails extends StatelessWidget {
  final BankTransferInfo bankInfo;

  const BankAccountDetails({Key? key, required this.bankInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bankInfo == null) {
      return const Center(child: Text('No hay información disponible'));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        //color: Theme.of(context).hintColor.withOpacity(0.9),
        //  color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          children: [
            // Text(
            //   'DATOS DE LA CUENTA BANCARIA',
            //   style: Theme.of(context).textTheme.headline2!.copyWith(
            //         // color: Colors.white,
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            // ),
            // Divider(color: Theme.of(context).hintColor),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              // margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  //  Image.asset('assets/img/logo.png', width: 30, height: 30,),

                  const SizedBox(width: 10),
                  Text(
                    "DATOS DE LA CUENTA BANCARIA",
                    style:
                        Theme.of(context).textTheme.headline5!.merge(TextStyle(
                            color: Theme.of(context).hintColor,
                            //  color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  buildRowInfoBank(
                      context, 'NOMBRE BANCO:', bankInfo.bankName ?? 'N/A'),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'NUMERO CUENTA:',
                      bankInfo.accountNumber ?? 'N/A'),
                  const SizedBox(height: 5),
                  buildRowInfoBank(
                      context, 'IDENTIFICACION:', bankInfo.ciNumber ?? 'N/A'),
                  const SizedBox(height: 5),
                  buildRowInfoBank(
                      context, 'TIPO:', bankInfo.accountType ?? 'N/A'),
                  const SizedBox(height: 5),
                  buildRowInfoBank(
                      context, 'NOMBRE:', bankInfo.ownerName ?? 'N/A'),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'EMAIL:', bankInfo.email ?? 'N/A'),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'TOTAL A PAGAR:',
                      '\$${bankInfo.price.toStringAsFixed(2)}'),
                  Divider(color: Theme.of(context).hintColor),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '⚠️ Obligatorio: \n\nPara validar el pago, por favor colocar el correo electrónico correctamente y subir el comprobante de pago.',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        ),
      ),
    );
  }

  Row buildRowInfoBank(BuildContext context, String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          width: 120,
          child: Text(
            name,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  // color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copiado: $value'),
                duration: const Duration(seconds: 3),
              ),
            );
          },
          child: Text(
            value,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  // color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                ),
          ),
        ),
      ],
    );
  }
}
