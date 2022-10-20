import 'package:frac/frac.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/models/fractal.dart';

const ts = String;

/*
class LogFractal extends Message implements FractalSocketAbs {
  final text = Frac<String>('');
  final of = Frac<String>('');
  List<OptionFractal> options = [];
  String get message => text.value;

  String thing = '';

  @override
  get word => w;
  static final w = Word('log')..fractal = ([m]) => LogFractal.xi(m);

  LogFractal({
    super.name,
    super.text,
    //this.thing = '',
    //this.options = const [],
    required super.id,
  }) : super();

  factory LogFractal.xi([x]) => x is Map
      ? LogFractal(
          name: '',
          text: x['text'] ?? '',
          id: x['id'] ?? '',
        )
      : LogFractal(
          name: '',
          text: '',
          id: x,
        );

  @override
  handle(FractalSocket socket) {
    socket;
  }
}

*/

class AppFractal extends Fractal {
  AppFractal({
    String id = '',
    String name = '',
    String path = '',
    int time = 0,
  }) : super(id) {
    this['name'] = this.name..value = name;
    this['path'] = this.path..value = path;
    this['time'] = this.time..value = time;

    /*
    final query = db.select(db.options);
    options = CatalogFractal<OptionFractal>(
      id: id + '_options',
      select: query,
      type: LogFractal.w,
    );
    */
  }

  //CatalogFractal<OptionFractal> options;

  static final w = Word('app');

  final name = Frac<String>('');

  final path = Frac<String>('');
  final time = Frac<int>(0);

  @override
  get word => w;
}

class AxioAppFractal extends AppFractal with ConnMix, StoreMix {
  final hey = 'fdsg';
  AxioAppFractal() {
    ab++;
    check();
    ax.value;
  }
}

mixin ConnMix on AppFractal {
  int ab = 8;

  late final ax = this['ax'] = Frac<int>(0);

  increase() {
    ax.value++;
    ab++;
  }
}

mixin StoreMix on ConnMix {
  check() {
    print(name.value);
    ax.value;
  }
}

test() {
  final a = AxioAppFractal();
  if (a is StoreMix) {
    print('yes');
  }
}
