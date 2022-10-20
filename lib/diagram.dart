import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fractal_gold/models/screen.dart';
import 'package:fractal_gold/screens/fscreen.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '/diagram_editor.dart';
import 'fractals/app.dart';
import 'models/diagram.dart';
import 'editor/data/custom_component_data.dart';
import 'editor/policy/canvas_widgets_policy.dart';
import 'editor/policy/component_design_policy.dart';
import 'editor/policy/custom_policy.dart';
import 'editor/policy/link_attachment_policy.dart';
import 'editor/policy/link_widgets_policy.dart';
import 'editor/policy/minimap_policy.dart';
import 'editor/policy/my_link_control_policy.dart';
import 'editor/policy/my_link_joint_control_policy.dart';
import 'editor/policy/my_policy_set.dart';
import '/editor/policy/canvas_widgets_policy.dart';
import '/editor/policy/component_widgets_policy.dart';
import '/editor/policy/custom_policy.dart';
import '/editor/policy/link_attachment_policy.dart';
import '/editor/policy/link_widgets_policy.dart';
import '/editor/policy/my_link_control_policy.dart';
import '/editor/policy/my_link_joint_control_policy.dart';
import 'widget/menu.dart';
import 'widget/option_icon.dart';
import 'package:fractals/models/index.dart';
import 'package:fluent_query_builder/fluent_query_builder.dart';

class DiagramApp extends StatefulWidget {
  File? file;
  DiagramApp({Key? key, this.file}) : super(key: key);

  @override
  _DiagramAppState createState() => _DiagramAppState();
}

class _DiagramAppState extends State<DiagramApp> {
  /*
  readfile() async {
    widget.file!.createSync();
    final cont = widget.file!.readAsStringSync();
    print(cont);

    diagramEditorContext.canvasModel.components.clear();
    if (cont.isEmpty) return;

    diagramEditorContext.policySet.canvasWriter.model;
    /*.deserializeDiagram(
      cont,
      //decodeCustomComponentFractal: (json) => MyComponentFractal.fromJson(json),
      decodeCustomLinkData: null,
    );
    */
  }
  */

  @override
  Widget build(BuildContext context) {
    final screen = Provider.of<ScreenFractal>(context) as DiagramScreenFractal;

    return FScreen(
      alpha: 120,
      Stack(
        children: [
          Container(color: Color.fromARGB(255, 206, 206, 206)),
          Positioned(
            child: DiagramEditor(
              diagramEditorContext: screen.diagramEditorContext,
            ),
          ),
          /*
        Positioned(
          bottom: 4,
          left: 4,
          right: 4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OptionIcon(
                color: Colors.grey.withOpacity(0.7),
                iconData: isOptionsVisible ? Icons.menu_open : Icons.menu,
                onPressed: () {
                  setState(() {
                    isMenuVisible = !isMenuVisible;
                  });
                },
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
                  */
              if (widget.file != null)
                OptionIcon(
                  tooltip: 'deserialize',
                  color: Colors.grey.withOpacity(0.7),
                  iconData: Icons.code_off_rounded,
                  onPressed: () => print(myPolicySet.deserialize()),
                ),
              OptionIcon(
                tooltip: 'reset view',
                color: Colors.grey.withOpacity(0.7),
                iconData: Icons.replay,
                onPressed: () => myPolicySet.resetView(),
              ),
              SizedBox(width: 8),
              OptionIcon(
                tooltip: 'delete all',
                color: Colors.grey.withOpacity(0.7),
                iconData: Icons.delete_forever,
                onPressed: () => myPolicySet.removeAll(),
              ),
              SizedBox(width: 8),
              OptionIcon(
                tooltip: myPolicySet.isGridVisible ? 'hide grid' : 'show grid',
                color: Colors.grey.withOpacity(0.7),
                iconData:
                    myPolicySet.isGridVisible ? Icons.grid_off : Icons.grid_on,
                onPressed: () {
                  setState(() {
                    myPolicySet.isGridVisible = !myPolicySet.isGridVisible;
                  });
                },
              ),
              OptionIcon(
                tooltip: isMiniMapVisible ? 'hide map' : 'show map',
                color: Colors.grey.withOpacity(0.7),
                iconData: isMiniMapVisible ? Icons.map : Icons.map_outlined,
                onPressed: () {
                  setState(() {
                    isMiniMapVisible = !isMiniMapVisible;
                  });
                },
              ),
              SizedBox(width: 8),
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
                          color: Colors.grey.withOpacity(0.7),
                          iconData: Icons.all_inclusive,
                          onPressed: () => myPolicySet.selectAll(),
                        ),
                        SizedBox(height: 8),
                        OptionIcon(
                          tooltip: 'duplicate selected',
                          color: Colors.grey.withOpacity(0.7),
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
                  SizedBox(height: 8),
                  OptionIcon(
                    tooltip: myPolicySet.isMultipleSelectionOn
                        ? 'cancel multiselection'
                        : 'enable multiselection',
                    color: Colors.grey.withOpacity(0.7),
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
          ),
        ),
          Positioned(
            top: 70,
            right: 9,
            child: Visibility(
              visible: screen.isMiniMapVisible,
              child: Container(
                width: 320,
                height: 240,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                    width: 2,
                  )),
                  child: DiagramEditor(
                    diagramEditorContext: screen.diagramEditorContextMiniMap,
                  ),
                ),
              ),
            ),
          ),
        */
        ],
      ),
    );
  }
}

// You can create your own Policy to define own variables and functions with canvasReader and canvasWriter.
mixin CustomPolicy implements PolicySet {
  String serializedDiagram = '{"components": [], "links": []}';

  // Save the diagram to String in json format.
  serialize() {
    serializedDiagram = canvasReader.model.serializeDiagram();
  }

  // Load the diagram from json format. Do it cautiously, to prevent unstable state remove the previous diagram (id collision can happen).
  deserialize() {
    canvasWriter.model.removeAllComponents();
    /*
    canvasWriter.model.deserializeDiagram(
      serializedDiagram,
      //decodeCustomComponentFractal: (json) => MyComponentFractal.fromJson(json),
      decodeCustomLinkData: null,
    );
    */
  }
}
