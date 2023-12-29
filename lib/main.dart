import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:payment_verification_app/pages/bank_account_info_uploader.dart';

import 'config/app_config.dart' as config;

void main() {
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
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      theme: lightTheme,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _token = '';

  @override
  void initState() {
    print(Uri.base);
    super.initState();
    _token = Uri.base.queryParameters['token'] ?? 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJMYXJhdmVsSldUIiwic3ViIjo4MCwiaWF0IjoxNzAzODYzNjEyLCJleHAiOjE3MDM4NjQyMTIsIm9yZGVyX2lkIjoiMzI3ODc4IiwidXNlcl9pZCI6ODAsInBheW1lbnRfaWQiOjMyNzgyMywicHJpY2UiOjIxLjk5LCJhY2NvdW50X251bWJlciI6IjIyMDYyMTU3MDEiLCJjaV9udW1iZXIiOiIxMDkxNzg5NzE2MDAxIiwiYWNjb3VudF90eXBlIjoiQWhvcnJvcyIsIm93bmVyX25hbWUiOiJCRUVTIERFTElWRVJZIENJQSBMVERBIiwiZW1haWwiOiJlZGNhaWNlZG8xMkBnbWFpbC5jb20iLCJiYW5rX25hbWUiOiJCLiBQaWNoaW5jaGEifQ.A_u27HjAygLRWsdmiN8vr9FXqiY3a9vQwZaJu0fm_WM';
  }


  @override
  Widget build(BuildContext context) {
    return  BankAccountInfoUploader(jwt: _token);
  }
}
