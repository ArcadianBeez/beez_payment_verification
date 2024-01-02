import 'dart:convert';
import 'dart:js_util';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:payment_verification_app/pages/bank_account_info_uploader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/app_config.dart' as config;
import 'firebase_options.dart';
import 'generated/i18n.dart';
import 'package:http/http.dart' as http;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GlobalConfiguration().loadFromAsset("configurations");
  usePathUrlStrategy();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeData lightTheme = ThemeData(
    scrollbarTheme: ScrollbarThemeData(
      //isAlwaysShown: true,
        thickness: MaterialStateProperty.all(3),
        radius: const Radius.circular(10),
        minThumbLength: 100),
    fontFamily: 'Poppins',
    primaryColor: Colors.white,
    brightness: Brightness.light,
    focusColor: config.Colors().accentColor(1),
    hintColor: config.Colors().secondColor(1),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
          color: config.Colors().secondColor(1)),
      headline2: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: config.Colors().secondColor(1)),
      headline3: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: config.Colors().secondColor(1)),
      headline4: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          color: config.Colors().mainColor(1)),
      headline5: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w300,
          color: config.Colors().secondColor(1)),
      headline6: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
      ),
      subtitle2: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          color: config.Colors().secondColor(1)),
      subtitle1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: config.Colors().mainColor(1)),
      bodyText1:
      TextStyle(fontSize: 12.0, color: config.Colors().secondColor(1)),
      bodyText2:
      TextStyle(fontSize: 14.0, color: config.Colors().secondColor(1)),
      caption: TextStyle(fontSize: 12.0, color: config.Colors().accentColor(1)),
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: config.Colors().mainColor(1)),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beez',
      home: const MyHomePage(),
      theme: lightTheme,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeListResolutionCallback:
      S.delegate.listResolution(fallback: const Locale('en', '')),
      navigatorObservers: [
        // FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _token = '';
  bool isLoaded=true;

  @override
  void initState() {
    print(Uri.base);


    //_token = Uri.base.queryParameters['token'] ?? 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJMYXJhdmVsSldUIiwic3ViIjo1MTI4MiwiaWF0IjoxNzAzODc4MzA0LCJleHAiOjE3MDM4Nzg5MDQsIm9yZGVyX2lkIjoiMzI3ODg0IiwidXNlcl9pZCI6NTEyODIsInBheW1lbnRfaWQiOjMyNzgyOSwicHJpY2UiOjIuMjUsImFjY291bnRfbnVtYmVyIjoiMjIwNjIxNTcwMSIsImNpX251bWJlciI6IjEwOTE3ODk3MTYwMDEiLCJhY2NvdW50X3R5cGUiOiJBaG9ycm9zIiwib3duZXJfbmFtZSI6IkJFRVMgREVMSVZFUlkgQ0lBIExUREEiLCJlbWFpbCI6ImVkY2FpY2VkbzEyQGdtYWlsLmNvbSIsImJhbmtfbmFtZSI6IkIuIFBpY2hpbmNoYSJ9.IZIe99tSW-u6sQVaS1gCqwwx6t3k29Q3EvV1NfmOrEY';
   _token = Uri.base.queryParameters['uuid'] ??  '32897e3d-33d0-4590-8ea9-b5075b18e4f6';
    loadToken();
   // _token=Uri.base.queryParameters['token']??'hfrbfjr';

    print(_token);
    super.initState();

  }

  loadToken() async{
setState(() {
  isLoaded=true;
});
    _token= await getToken(_token);
    setState(() {
      isLoaded=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return !isLoaded?  BankAccountInfoUploader(jwt: _token):
    Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<String> getToken(String uuid) async {
    final String _apiToken = '?api_token=wvSij4xlWvsPR37f96TWYO5o64GfwsYWKwAyAsyXVqBz2AmaYwpxeMDjRFY1&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}get_token_with_uuid${_apiToken}uuid=$uuid';
   print('ruta');
    print(url);
    final response = await http.get(Uri.parse(url));
    var order = json.decode(response.body);
    print('uuuid');
    print(order);
    return order['token'];
  }
}
