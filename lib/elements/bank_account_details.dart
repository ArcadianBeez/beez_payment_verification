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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "DATOS DE LA CUENTA BANCARIA",
                  style: Theme.of(context).textTheme.headline5!.merge(TextStyle(
                      color: Theme.of(context).hintColor,
                      //  color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Divider(color: Theme.of(context).hintColor),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'Nombre del banco:',
                      bankInfo.bankName ?? 'N/A', false, null),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'Número de cuenta:',
                      bankInfo.accountNumber ?? 'N/A', true, null),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'Identificación:',
                      bankInfo.ciNumber ?? 'N/A', true, null),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'Tipo:',
                      bankInfo.accountType ?? 'N/A', false, null),
                  const SizedBox(height: 5),
                  buildRowInfoBank(
                      context,
                      'Nombre:',
                      bankInfo.ownerName ?? 'N/A',
                      true,
                      bankInfo.email.length > 15 ? 14 : null),
                  const SizedBox(height: 10),
                  buildRowInfoBank(context, 'Email:', bankInfo.email ?? 'N/A',
                      true, bankInfo.email.length > 15 ? 14 : null),
                  const SizedBox(height: 5),
                  buildRowInfoBank(context, 'Total a pagar:',
                      '\$${bankInfo.price.toStringAsFixed(2)}', false, null),
                  Divider(color: Theme.of(context).hintColor),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Obligatorio: Para validar el pago, por favor colocar el correo electrónico correctamente y subir el comprobante de pago.',
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

  Row buildRowInfoBank(BuildContext context, String name, String value,
      bool isCopyable, double? letterSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          width: 100,
          child: Text(
            name,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(width: 5),
        Row(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontSize: letterSize ?? 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4,
                  ),
            ),
            const SizedBox(width: 10),
            isCopyable
                ? InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copiado: $value'),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Icon(Icons.copy,
                        size: 20, color: Theme.of(context).hintColor),
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
