import 'package:fractal_gold/dex.dart';
import 'package:fractal_gold/schema.dart';
import 'package:fractal_gold/ui.dart';
import 'package:fractals/io.dart';
import 'package:fractals/models/index.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  Dex.ipfs;

  await Hive.initFlutter('HiveFStorage');
  await define();

  //Acc.db = sqlite3.open('fractal.db');

  await FractalUI.init();
  FIO.documentsPath = '/Users/mk/Data/Documents';

  await Fractal.init();
  /*
  if (!(Platform.isMacOS || Platform.isIOS)) {
    Acc.storageAlt = const FlutterSecureStorage();
  }
  */

  runApp(MyApp());
}
