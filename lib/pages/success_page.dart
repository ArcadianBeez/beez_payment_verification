import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String response;

  const SuccessPage({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Pantalla de Éxito'),
      // ),
      body: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                'Pronto revisaremos tu transacción; este proceso suele tardar aproximadamente un minuto. Una vez que la transacción sea aprobada, continuaremos con el procesamiento de tu pedido.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4!.merge(
                    TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500))):
            Container(),

          ],
        )

        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Text(
        //       response,
        //       style: TextStyle(fontSize: 24),
        //     ),
        //     SizedBox(height: 20),
        //     Text(
        //       'Pronto revisaremos tu transacción; este proceso suele tardar aproximadamente un minuto. Una vez que la transacción sea aprobada, continuaremos con el procesamiento de tu pedido.',
        //       textAlign: TextAlign.center,
        //       style: TextStyle(fontSize: 16),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
