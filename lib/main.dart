import 'package:flutter/material.dart';
import 'package:supportme/theme/theme.dart';
import 'package:supportme/views/home.dart';
import 'package:supportme/views/splash.dart';

void main() {
  runApp(SupportMe());
}

class SupportMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SupportMe',
      theme: ThemeData(
        primarySwatch: AppTheme.pallete,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Widget _widget;

  @override
  void initState() {
    _widget = Splash();
    Future.delayed(Duration(milliseconds: 3000))
        .then((_) => setState(() => _widget = Home()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _widget,
    );
  }
}
