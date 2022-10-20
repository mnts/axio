import 'dart:convert';
import 'dart:typed_data';

import 'package:frac/frac.dart';
import 'package:fractal_socket/session.dart';
import 'package:fractal_socket/socket.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/extensions/word.dart';
import 'package:fractals/fracts/bytes.dart';
import 'package:fractals/models/created.dart';
import 'package:fractals/models/index.dart';
import 'package:fractals/models/message.dart';

const ts = String;

class OptionFractal extends Fractal {
  String title = '';

  OptionFractal({
    String id = '',
    String log_id = '',
    required this.title,
  }) : super(id);
}
