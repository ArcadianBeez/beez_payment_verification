import 'dart:convert';
import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:payment_verification_app/pages/bank_account_info_uploader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config/app_config.dart' as config;
import 'firebase_options.dart';
import 'generated/i18n.dart';
import 'package:http/http.dart' as http;
import 'models/city.dart';

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
  List<City> cities = [];

  @override
  void initState() {
    print(Uri.base);
    // _uuid = Uri.base.queryParameters['uuid'] ??
    //     '173ecc74-b28b-43e4-a5d9-1394f98bc2af';
    if (Uri.base.queryParameters['uuid'] != null) {
      _uuid = Uri.base.queryParameters['uuid']!;
      window.localStorage['uuid'] = _uuid;
    } else {
      _uuid = window.localStorage['uuid'] ?? 'j';
    }

    loadToken();

    loadCities();

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

  loadCities() async {
    cities = await getCities();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded && !isInvalid) {
      return BankAccountInfoUploader(jwt: _token);
    } else if (isInvalid) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_token,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                ),
                child: MaterialButton(
                    //color: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/help.png',
                          width: 50,
                          height: 50,
                        ),
                        Text('Por favor, contacte al administrador',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white)),
                      ],
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Seleccione su ciudad',
                                  style: TextStyle(color: Colors.black)),
                              content: SizedBox(
                                width: 300,
                                height: 300,
                                child: ListView.builder(
                                  itemCount: cities.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(cities[index].name.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600)),
                                      onTap: () {
                                        String number =
                                            cities[index].supportNumber!;
                                        number = number[0] == '0'
                                            ? '+593${number.substring(1)}'
                                            : number;
                                        String whatsappUrl =
                                            "https://wa.me/$number";
                                        launch(whatsappUrl);
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ],
          )));
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

  Future<List<City>> getCities() async {
    List<City> cities = [];
    const String apiToken =
        '?api_token=wvSij4xlWvsPR37f96TWYO5o64GfwsYWKwAyAsyXVqBz2AmaYwpxeMDjRFY1&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}cities${apiToken}';
    final response = await http.get(Uri.parse(url));
    var citiesResponse = jsonDecode(response.body)['data'];
    citiesResponse.forEach((_city) {
      cities.add(City.fromJson(_city));
    });
    return cities;
  }
}
