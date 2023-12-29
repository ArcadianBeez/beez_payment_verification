import 'package:flutter/material.dart';

class InstructionsDialog extends StatefulWidget {
  final VoidCallback getFromGalleryCallback;
  final String bankName;

  InstructionsDialog({Key? key, required this.getFromGalleryCallback, required this.bankName}) : super(key: key);

  @override
  _InstructionsDialogState createState() => _InstructionsDialogState();
}

class _InstructionsDialogState extends State<InstructionsDialog> {


  double _width = 500;
  double _height = 500;
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      if (_isExpanded) {
        _width = 500;
        _height = 500;
      } else {
        _width = MediaQuery.of(context).size.width; // o un tamaño específico más grande
        _height = MediaQuery.of(context).size.height; // o un tamaño específico más grande
      }
      _isExpanded = !_isExpanded;
    });
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(8),
      elevation: 10,
      titlePadding: const EdgeInsets.all(0.0),
      title: Align(
          alignment: AlignmentDirectional.topEnd,
          child: IconButton(
            icon: Icon(Icons.close, color: Theme.of(context).hintColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Instrucciones al subir su comprabante',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            Divider(color: Theme.of(context).hintColor),
            const SizedBox(height: 10),
            Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check,
                              size: 15, color: Theme.of(context).hintColor),
                          Container(
                            margin: EdgeInsets.only(left: 5, top: 0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                                'La imagen debe ser una captura de pantalla del comprobante de transferencia que incluya la hora visible. Todos los detalles importantes, marcados con puntos rojos, deben estar claramente visibles.',
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ],
                      ),
                      Divider(color: Theme.of(context).hintColor),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check,
                              size: 15, color: Theme.of(context).hintColor),
                          SizedBox(width: 5),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            width: MediaQuery.of(context).size.width *
                                0.7, // Ajuste del ancho
                            child: Text(
                              'Todos los detalles importantes, marcados con puntos rojos, deben estar claramente visibles.',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Theme.of(context).hintColor),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check,
                              size: 15, color: Theme.of(context).hintColor),
                          Container(
                            margin: const EdgeInsets.only(left: 5, top: 0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                                'Al final te dejamos el ejemplo proporcionado para ver cómo debe lucir tu comprobante de pago.',
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ],
                      ),
                      Divider(color: Theme.of(context).hintColor),
                    ])),
            const SizedBox(height: 10),
            Text('Por ejemplo:', style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 5),
            imageByBank(widget.bankName)
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Color(0xFF344968),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            child: Text('Galeria',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w300)),
            onPressed: () {
              widget.getFromGalleryCallback();
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  imageByBank(bankName) {
    return GestureDetector(
      onTap: _toggleExpansion,
      child: Stack(
        alignment: Alignment.topCenter, // Alinea el icono en el centro de la parte superior
        children: [
          Image.asset(
            bankName.contains('Pichincha')
                ? 'assets/img/banks/pichincha.jpeg'
                : bankName.contains('produbanco')
                ? 'assets/img/banks/produbanco.jpeg'
                : 'assets/img/banks/otrobanco.jpeg', // Asegúrate de tener la ruta correcta aquí
            width: _width,
            height: _height,
          ),
          Positioned(
            top: 10,
            left: 0,
            child: Icon(Icons.expand, color: Colors.black45, size: 50), // Ajusta el tamaño del icono si es necesario
          ),
        ],
      ),
    );
  }
}
