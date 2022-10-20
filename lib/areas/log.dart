import 'package:flutter/material.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/extensions/word.dart';
import 'package:fractals/models/index.dart';
import 'package:fractals/models/link.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../diagram_editor.dart';
import '../models/diagram.dart';

class LogArea extends StatefulWidget {
  LogArea({Key? key}) : super(key: key);

  @override
  State<LogArea> createState() => _LogAreaState();
}

class _LogAreaState extends State<LogArea> {
  final list = <LinkFractal>[];

  @override
  void initState() {
    load();
    super.initState();
    //controller = SwipeActionController();

    /*
    catalog.refreshed.listen((_) {
      setState(() {
        list = catalog.list.reversed.toList();
      });
    });
    */
  }

  load() {
    list.clear();
    final word = Word('link');
    Acc.db.select('''
      SELECT *
      FROM links
      ORDER BY time DESC
      ''' /*JOIN named
      ON links.i = named.id
    '''*/
        ).every((el) {
      if (el['i'] == null) return false;

      final map = el.cast<String, dynamic>();
      final f = word.take(map) as LinkFractal;
      list.add(f);
      return true;
    });
  }

  refresh() {
    load();
    setState(() {});
  }

  //Table table;

  //Text field controller
  late final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppFractal>(context);
    final screen = app.currentScreen as DiagramScreenFractal;

    final myPolicySet = screen.diagramEditorContext.policySet;

    return Column(children: [
      /*Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          humanTime ? Icons.punch_clock : Icons.timelapse,
        ),
        onPressed: () {
          setState(() {
            humanTime = !humanTime;
          });
        },
      ),
      body: */
      TextFormField(
        controller: ctrl,
        style: new TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
          color: Colors.black,
          height: 1,
        ),
        onFieldSubmitted: (value) async {
          final val = value.trim();
          if (val.isNotBlank) {
            submit(val);
          }
        },
        decoration: const InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: Icon(Icons.add),
          hintText: 'new..',
        ),
      ),
      ListView.builder(
        key: const Key('list'),
        primary: false,
        //buildDefaultDragHandles: false,
        //onReorder: (oldIndex, newIndex) {},
        shrinkWrap: true,
        itemBuilder: (c, index) {
          final f = list[index];
          /*
          final c = ComponentFractal(
            //size: Size(120, 72),
            //minSize: Size(80, 64),
            data: f,
            type: 'container',
          );
          */

          return Draggable<LinkFractal>(
            affinity: Axis.horizontal,
            ignoringFeedbackSemantics: true,
            data: f,
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: tile(f),
            ),
            feedback: Material(
              color: Colors.transparent,
              child: Container(
                width: 120, //c.size.width,
                height: 60, //c.size.height,
                child: tile(f),
              ),
            ),
            child: tile(f),
          );
        },
        itemCount: list.length,
      ),
    ]);
  }

  Widget tile(LinkFractal f) {
    return ListTile(
      title: Text(f.label.value),
      subtitle: Text(f.url),
      key: Key(
        f.id.toString(),
      ),
    );
  }

  submit(String val) async {
    ctrl.clear();
    final isUrl = (Uri.parse(val).isAbsolute);

    final f = LinkFractal(
      label: isUrl ? '' : val,
      url: isUrl ? val : '',
    );
    f.store();
    setState(() {
      refresh();
    });
  }
}
