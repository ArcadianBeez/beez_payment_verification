import 'package:flutter/material.dart';

class InstructionsDialog extends StatefulWidget {
  final VoidCallback getFromGalleryCallback;
  final String bankName;

  InstructionsDialog(
      {Key? key, required this.getFromGalleryCallback, required this.bankName})
      : super(key: key);

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
        _width = MediaQuery.of(context)
            .size
            .width; // o un tamaño específico más grande
        _height = MediaQuery.of(context)
            .size
            .height; // o un tamaño específico más grande
      }
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.black,
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
              'Instrucciones al subir su comprobante',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
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
                                'La imagen debe ser una captura de pantalla del comprobante de transferencia que incluya la hora visible.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 14)),
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
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                                'Todos los detalles importantes, marcados con puntos rojos, deben estar claramente visibles.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 14)),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 14))),
                        ],
                      ),
                      Divider(color: Theme.of(context).hintColor),
                    ])),
            const SizedBox(height: 10),
            Text('El comprobante de pago se debe ver como, (ejemplo):',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 14)),
            const SizedBox(height: 5),
            imageByBank(widget.bankName)
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xFF344968),
            borderRadius: BorderRadius.circular(10),
          ),
          child: MaterialButton(
            minWidth: 200,
            child: Text('Ir a galería',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            onPressed: () {
              widget.getFromGalleryCallback();
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  void _showExpandedImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: Image.asset(imagePath),
          ),
        );
      },
    );
  }

  Widget imageByBank(String bankName) {
    bankName = bankName.toLowerCase();
    String imagePath = bankName.contains('pichincha')
        ? 'assets/img/banks/pichincha.jpeg'
        : bankName.contains('produbanco')
            ? 'assets/img/banks/produbanco.jpeg'
            : bankName.contains('una')
                ? 'assets/img/banks/deuna.jpeg'
                : bankName.contains('internacional')
                    ? 'assets/img/banks/internacional.jpeg'
                    : bankName.contains('guayaquil')
                        ? 'assets/img/banks/guayaquil.jpeg'
                        : 'assets/img/banks/otrobanco.jpeg';

    return GestureDetector(
      onTap: () => _showExpandedImage(context, imagePath),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            imagePath,
            width: 500,
            height: 500,
          ),
          Positioned(
            bottom: 20,
            right: 70,
            child: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Icon(Icons.zoom_in,
                  color: Theme.of(context).hintColor, size: 25),
            ),
          ),
        ],
      ),
    );
  }
}
