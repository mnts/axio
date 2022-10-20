import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fractal_gold/inputs/string.dart';
import 'package:fractals/helpers/random.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:timeago/timeago.dart';
import '../fractals/table.dart';

class TablesScreen extends StatefulWidget {
  TablesScreen({Key? key}) : super(key: key);

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  final list = <TableFractal>[];

  late SwipeActionController controller;

  @override
  void initState() {
    controller = SwipeActionController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VStack([
        Expanded(
          child: VStack([
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                shrinkWrap: true,
                itemBuilder: (c, index) => _item(list[index], index),
                itemCount: list.length,
              ),
            ),
          ]),
        ),
        buildInput(),
      ]),
    );
  }

  buildInput() => StringInput(
        hint: 'table_name',
        onSave: (doc) {
          final i1 = doc.indexOf('('), i2 = doc.lastIndexOf(')');
          final text = (i1 == -1 ? doc : doc.substring(0, i1)).trim();

          List<String> args =
              (i1 != -1 && i2 > i1) ? doc.substring(i1 + 1, i2).split('|') : [];

          setState(() {
            final log = TableFractal(
              name: text,
              id: getRandomString(4),
            );
            list.add(log);
          });

          //log.store();
          //log.sync();

          /*
          for (final a in args) {
            OptionFractal(text: a.trim()).sync();
          }
          */

          //f.sync();
        },
      );

  Widget _buildString(TableFractal item) {
    return Container(
      height: 40,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => {} //AppScreen(item),
                    );
              },
              child: Container(
                height: 40,
                child: Text(
                  item.name,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ).expand(),
            Text(
              format(
                item.time,
                locale: 'en_short',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _item(TableFractal item, int index) {
    return SwipeActionCell(
        controller: controller,

        ///index is required if you want to enter edit mode
        index: index,
        key: ValueKey(index),
        leadingActions: [
          SwipeAction(
            color: Colors.green,
            icon: Icon(Icons.image),
            onTap: (g) {},
          ),
          SwipeAction(
            nestedAction: SwipeNestedAction(
              ///customize your nested action content

              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 234, 216, 17),
                ),
                width: 130,
                height: 60,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      Text('Act',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),

            ///you should set the default  bg color to transparent
            color: Colors.transparent,

            ///set content instead of title of icon
            content: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),

                ///set you real bg color in your content
                color: Colors.orange,
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
            onTap: (handler) async {
              setState(() {
                list.removeAt(index);
              });
            },
          ),
        ],
        trailingActions: [
          SwipeAction(
            nestedAction: SwipeNestedAction(
              ///customize your nested action content

              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.red,
                ),
                width: 130,
                height: 60,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text('Remove?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          )),
                    ],
                  ),
                ),
              ),
            ),

            ///you should set the default  bg color to transparent
            color: Colors.transparent,

            ///set content instead of title of icon
            content: _getIconButton(Colors.red, Icons.delete),
            onTap: (handler) async {
              setState(() {
                list.removeAt(index);
              });
            },
          ),
          /*
        SwipeAction(
          content: VStack([
            Text(
              timeago.format(
                item.createdAt,
                locale: 'en_short',
              ),
            ),
            Text(
              item.id,
              style: TextStyle(fontSize: 18),
            ),
          ]),
          color: Colors.transparent,
          onTap: (handler) {},
        ),
        */
        ],
        child: _buildString(item)
        /*
              Container(
                child: Text(
                  item.createdAt.millisecondsSinceEpoch.toString(),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              */ /* Column(children: [
            .expand(),
            Container(
              child: Text(
                item.createdAt.millisecondsSinceEpoch.toString(),
                style: TextStyle(fontSize: 18),
              ),
              width: 500,
            ),
          ]),*/
        );
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        ///set you real bg color in your content
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
