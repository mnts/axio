import 'package:axio/screens.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/auth/fractals/index.dart';
import 'package:fractal_gold/layouts/fractal.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractals/models/index.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Acc.connect();
    });
  }

  final app = AppFractal(
    id: 'axio',
    color: Color.fromARGB(255, 120, 0, 133),
    icon: Image.asset('assets/icon.png'),
    title: 'AXIO',
    //hideAppBar: true,
    auths: [
      LocalAuthFractal(),
      PasswordAuthFractal(),
      MetamaskAuthFractal(),
    ],
    home: diagramScreen,
    /*ScreenFractal(
    icon: Icons.picture_in_picture_outlined,
    name: 'pix8',
    builder: Pix8Screen.new,
  ),*/
    screens: [
      catalogScreen,
      peopleScreen,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return FractalLayout(app);
  }
}
