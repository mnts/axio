import 'dart:io';

import 'package:axio/diagram.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/screens/index.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:path/path.dart' as path;
import '../fractals/app.dart';
import 'package:yaml/yaml.dart';
import 'dart:math';

import 'package:path/path.dart' as path;

class AppScreen extends StatefulWidget {
  AppFractal fractal;
  AppScreen(this.fractal, {Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late YamlMap pubspec;

  bool loading = false;

  @override
  void initState() {
    Future.wait([loadPubspec()]).then((_) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Future<void> loadPubspec() async {
    final file = File(path.join(
      widget.fractal.path.value,
      'pubspec.yaml',
    ));
    pubspec = loadYaml(await file.readAsString());
  }

  @override
  Widget build(BuildContext context) {
    return FScreen(
      HStack(
        [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(8),
            width: min(400, MediaQuery.of(context).size.width),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ZStack(
              [
                // return to previous screen
                Positioned(
                  top: 3,
                  left: 3,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                ),
                VStack(
                  [
                    Image.file(
                      File(
                        path.join(
                          widget.fractal.path.value,
                          'assets/icon.png',
                        ),
                      ),
                    ),
                    Text(
                      widget.fractal.name.value,
                      style: Theme.of(context).textTheme.headline5!.merge(
                            const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                    ),
                    if (loading)
                      CircularProgressIndicator()
                    else
                      VStack([Text(pubspec['description'])]),
                    HStack([
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Color.fromARGB(255, 47, 47, 47),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          tooltip: 'Open graph',
                          onPressed: () async {
                            final File file = File(
                              path.join(
                                widget.fractal.path.value,
                                'graph.json',
                              ),
                            );
                            openGraph(context, file);
                          },
                          icon: const Icon(
                            Icons.ac_unit,
                          ),
                        ),
                      ),
                    ]),
                    Container(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                  alignment: MainAxisAlignment.start,
                ),
              ],
            ),
          ),
          Container()
        ],
        crossAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  void openGraph(ctx, file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiagramApp(file: file),
      ),
    );
  }
}
