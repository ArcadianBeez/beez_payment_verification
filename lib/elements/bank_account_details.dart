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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              // margin: const EdgeInsets.symmetric(horizontal: 20),
              // decoration: BoxDecoration(
              //   color: Theme.of(context).colorScheme.secondary,
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "DATOS DE LA CUENTA BANCARIA",
                    style:
                        Theme.of(context).textTheme.headline5!.merge(TextStyle(
                            color: Theme.of(context).hintColor,
                            //  color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  buildRowInfoBank(
                      context, 'Nombre del banco:', bankInfo.bankName ?? 'N/A', false),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'Número de cuenta:',
                      bankInfo.accountNumber ?? 'N/A', true),
                  const SizedBox(height: 5),
                  buildRowInfoBank(
                      context, 'Identificación:', bankInfo.ciNumber ?? 'N/A', true),
                  const SizedBox(height: 5),
                  buildRowInfoBank(
                      context, 'Tipo:', bankInfo.accountType ?? 'N/A', false),
                  const SizedBox(height: 5),
                  buildRowInfoBank(
                      context, 'Nombre:', bankInfo.ownerName ?? 'N/A', true),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'Email:', bankInfo.email ?? 'N/A', true),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'Total a pagar:',
                      '\$${bankInfo.price.toStringAsFixed(2)}', false),
                  Divider(color: Theme.of(context).hintColor),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Obligatorio: Para validar el pago, por favor leer el tutorial, colocar el correo electrónico correctamente y subir el comprobante de pago.',
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

  Row buildRowInfoBank(BuildContext context, String name, String value, bool isCopyable) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          width: 120,
          child: Text(
            name,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(width: 10),


    Row(
      children: [
        Text(
                value,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.4,
                    ),
              ),
        const SizedBox(width: 5),
        isCopyable? GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copiado: $value'),
                duration: const Duration(seconds: 3),
              ),
            );
          },
          child: Icon(Icons.copy, size: 15, color: Theme.of(context).hintColor),
        ) : const SizedBox(),
      ],
    ),

      ],
    );
  }
}
