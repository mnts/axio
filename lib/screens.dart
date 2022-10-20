import 'package:flutter/material.dart';
import 'package:fractal_gold/models/screen.dart';
import 'package:fractal_gold/screens/index.dart';

import 'diagram.dart';
import 'models/diagram.dart';
import 'screens/diagram/ctrl.dart';

final peopleScreen = ScreenFractal(
  name: 'people',
  icon: Icons.people_outline,
  builder: PeopleScreen.new,
);

final diagramScreen = DiagramScreenFractal();

/*
final rtcScreen = ScreenFractal(
  name: 'rtc',
  icon: Icons.connect_without_contact,
  builder: DataChannelSample.new,
);
*/

final catalogScreen = ScreenFractal(
  name: 'catalog',
  icon: Icons.list,
  builder: CatalogScreen.new,
);
