import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fractal_gold/blocks/avatar.dart';
import 'package:fractals/models/index.dart';
import 'package:get/get.dart';

import 'package:path/path.dart' as path;
import '/fractals/app.dart';
import '/screens/app.dart';

class AppBlock extends StatelessWidget {
  final AppFractal fractal;
  AppBlock(this.fractal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      child: Column(
        children: [
          Image.file(
            File(
              path.join(
                fractal.path.value,
                'assets/icon.png',
              ),
            ),
            fit: BoxFit.scaleDown,
            height: 200,
            width: 200,
          ),
          InkWell(
            onTap: () {
              Get.to(
                () => AppScreen(fractal),
              );
            },
            child: Text(
              fractal.name.value,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .merge(const TextStyle(fontSize: 22)),
            ),
          ),
        ],
      ),
    );
  }
}
