import 'dart:convert';
import 'dart:html';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeData lightTheme = ThemeData(
    scrollbarTheme: ScrollbarThemeData(
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
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: config.Colors().mainColor(1)),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beez',
      home: const MyHomePage(),
      theme: lightTheme,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeListResolutionCallback:
          S.delegate.listResolution(fallback: const Locale('en', '')),
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
  String _uuid = '';
  bool isLoaded = true;
  bool isInvalid = false;

  @override
  void initState() {
    print(Uri.base);
    // _uuid = Uri.base.queryParameters['uuid'] ??
    //     '38608f6b-c93f-4015-8fc5-9c714760a2f5';
    if(Uri.base.queryParameters['uuid'] != null){
      _uuid = Uri.base.queryParameters['uuid']!;
      window.localStorage['uuid'] = _uuid;
    } else {
      _uuid = window.localStorage['uuid'] ?? '';
    }

    loadToken();

    super.initState();
  }

  loadToken() async {
    setState(() {
      isLoaded = true;
    });
    _token = await getToken(_uuid);
    setState(() {
      isLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded && !isInvalid) {
      return BankAccountInfoUploader(jwt: _token);
    } else if (isInvalid) {
      return Scaffold(
        backgroundColor: Colors.white,
        body:
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(_token),
                  const Text('Por favor, contacte al administrador')
                ],
              ))
      );
    } else {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Future<String> getToken(String uuid) async {
    const String apiToken =
        '?api_token=wvSij4xlWvsPR37f96TWYO5o64GfwsYWKwAyAsyXVqBz2AmaYwpxeMDjRFY1&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}get_token_with_uuid${apiToken}uuid=$uuid';
    final response = await http.get(Uri.parse(url));

    var request = json.decode(response.body);
    if (!request['status']) {
      setState(() {
        isInvalid = true;
      });
      return request['message'];
    }
    return request['token'];
  }
}
