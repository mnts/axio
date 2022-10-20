import 'package:frac/frac.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/models/fractal.dart';
import 'package:fractals/schema.dart';

final schema = FractalSchema.main;

class WordFractal extends Fractal {
  final name = Frac<String>('');
  static final w = schema.word;
  WordFractal({String name = '', int id = 0}) : super(id) {
    fm[schema.name] = this.name..value = name;
  }
}
