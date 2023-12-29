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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Datos de la cuenta bancaria',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(color: Colors.white),
            buildRowInfoBank(
                context, 'Nombre del banco: ', bankInfo!.bankName ?? 'N/A'),
            const SizedBox(height: 5),
            buildRowInfoBank(context, 'Número de cuenta: ',
                bankInfo!.accountNumber ?? 'N/A'),
            const SizedBox(height: 5),
            buildRowInfoBank(
                context, 'Identificación: ', bankInfo!.ciNumber ?? 'N/A'),
            const SizedBox(height: 5),
            buildRowInfoBank(context, 'Tipo: ', bankInfo!.accountType ?? 'N/A'),
            const SizedBox(height: 5),
            buildRowInfoBank(context, 'Nombre: ', bankInfo!.ownerName ?? 'N/A'),
            const SizedBox(height: 5),
            buildRowInfoBank(context, 'Email: ', bankInfo!.email ?? 'N/A'),
            const SizedBox(height: 5),
            Text(
              '⚠️ Obligatorio: Para validar el pago, por favor colocar el correo electrónico correctamente y subir el comprobante de pago.',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
            ),
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
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copiado: $name'),
                duration: const Duration(seconds: 3),
              ),
            );
          },
          child: Text(
            value,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
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
