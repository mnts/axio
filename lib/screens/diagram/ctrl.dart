import '../../areas/log.dart';
import '../../widget/menu.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

import '/models/diagram.dart';
import '../../widget/option_icon.dart';

class DiagramCtrl extends StatefulWidget {
  DiagramCtrl({Key? key}) : super(key: key);

  @override
  State<DiagramCtrl> createState() => _DiagramCtrlState();
}

class _DiagramCtrlState extends State<DiagramCtrl> {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppFractal>(context);
    final screen = app.currentScreen as DiagramScreenFractal;
    final myPolicySet = screen.myPolicySet;

    bool isOptionsVisible = true;
    bool isMiniMapVisible = false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        JustTheTooltip(
          triggerMode: TooltipTriggerMode.tap,
          backgroundColor: Colors.white.withAlpha(160),
          showWhenUnlinked: true,
          hoverShowDuration: const Duration(
            seconds: 2,
          ),
          isModal: true,
          //barrierDismissible: false,
          child: Icon(Icons.list_alt),

          content: Container(
            width: 300,
            height: 700,
            padding: EdgeInsets.all(8.0),
            child: LogArea(
                //myPolicySet: screen.myPolicySet,
                ),
          ),
        ),
        JustTheTooltip(
          triggerMode: TooltipTriggerMode.tap,
          backgroundColor: Colors.white.withAlpha(160),
          showWhenUnlinked: true,
          hoverShowDuration: const Duration(
            seconds: 2,
          ),
          isModal: true,
          //barrierDismissible: false,
          child: Icon(Icons.menu),

          content: Container(
            width: 300,
            height: 700,
            padding: EdgeInsets.all(8.0),
            child: DraggableMenu(
              myPolicySet: screen.myPolicySet,
            ),
          ),
        ),
        /*
                if (widget.file != null)
                  OptionIcon(
                    tooltip: 'serialize',
                    color: Colors.grey.withOpacity(0.7),
                    iconData: Icons.code,
                    onPressed: () {
                      final model = myPolicySet.canvasReader.model.canvasModel,
                          diagram = model.getDiagram();

                      final links = <Map<String, dynamic>>[
                        ...diagram.links.map((link) => link.toJson())
                      ];
                      final components = <Map<String, dynamic>>[
                        ...diagram.components.map((comp) => comp.toJson())
                      ];

                      final content = json.encode({
                        'components': components,
                        'links': links,
                      });
                      widget.file!.writeAsString(content);
                    },
                  ),
        if (widget.file != null)
          OptionIcon(
            tooltip: 'deserialize',
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.code_off_rounded,
            onPressed: () => print(myPolicySet.deserialize()),
          ),
                  */
        OptionIcon(
          tooltip: 'reset view',
          iconData: Icons.replay,
          onPressed: () => myPolicySet.resetView(),
        ),
        OptionIcon(
          tooltip: 'delete all',
          iconData: Icons.delete_forever,
          onPressed: () => myPolicySet.removeAll(),
        ),
        OptionIcon(
          tooltip: myPolicySet.isGridVisible ? 'hide grid' : 'show grid',
          iconData: myPolicySet.isGridVisible ? Icons.grid_off : Icons.grid_on,
          onPressed: () {
            setState(() {
              myPolicySet.isGridVisible = !myPolicySet.isGridVisible;
            });
          },
        ),
        OptionIcon(
          tooltip: isMiniMapVisible ? 'hide map' : 'show map',
          iconData: isMiniMapVisible ? Icons.map : Icons.map_outlined,
          onPressed: () {
            setState(() {
              isMiniMapVisible = !isMiniMapVisible;
            });
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: myPolicySet.isMultipleSelectionOn,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OptionIcon(
                    tooltip: 'select all',
                    iconData: Icons.all_inclusive,
                    onPressed: () => myPolicySet.selectAll(),
                  ),
                  SizedBox(height: 8),
                  OptionIcon(
                    tooltip: 'duplicate selected',
                    iconData: Icons.copy,
                    onPressed: () => myPolicySet.duplicateSelected(),
                  ),
                  SizedBox(height: 8),
                  OptionIcon(
                    tooltip: 'remove selected',
                    color: Colors.grey.withOpacity(0.7),
                    iconData: Icons.delete,
                    onPressed: () => myPolicySet.removeSelected(),
                  ),
                ],
              ),
            ),
            OptionIcon(
              tooltip: myPolicySet.isMultipleSelectionOn
                  ? 'cancel multiselection'
                  : 'enable multiselection',
              iconData: myPolicySet.isMultipleSelectionOn
                  ? Icons.group_work
                  : Icons.group_work_outlined,
              onPressed: () {
                setState(() {
                  if (myPolicySet.isMultipleSelectionOn) {
                    myPolicySet.turnOffMultipleSelection();
                  } else {
                    myPolicySet.turnOnMultipleSelection();
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
