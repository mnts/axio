import '../diagram.dart';
import '../editor/data/custom_component_data.dart';
import '../editor/policy/my_policy_set.dart';
import '/diagram_editor.dart';
import 'package:flutter/material.dart';

class DraggableMenu extends StatelessWidget {
  final MyPolicySet myPolicySet;

  const DraggableMenu({
    Key? key,
    required this.myPolicySet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...myPolicySet.bodies.map((componentType) {
          return Container();
          /*
            var componentFractal = getComponentFractal(componentType);
            return Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth < componentFractal.size.width
                        ? componentFractal.size.width *
                            (constraints.maxWidth / componentFractal.size.width)
                        : componentFractal.size.width,
                    height: constraints.maxWidth < componentFractal.size.width
                        ? componentFractal.size.height *
                            (constraints.maxWidth / componentFractal.size.width)
                        : componentFractal.size.height,
                    child: Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: componentFractal.size.aspectRatio,
                        child: Tooltip(
                          message: componentFractal.type,
                          child: DraggableComponent(
                            myPolicySet: myPolicySet,
                            componentFractal: componentFractal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              */
        }).toList(),
      ],
    );
  }

  /*
  ComponentFractal getComponentFractal(String componentType) {
    switch (componentType) {
      case 'junction':
        return ComponentFractal(
          //size: Size(16, 16),
          //minSize: Size(4, 4),
          data: MyComponentFractal(
            color: Colors.black,
            borderWidth: 0.0,
          ),
          type: componentType,
        );
        break;
      default:
        return ComponentFractal(
          //size: Size(120, 72),
          //minSize: Size(80, 64),
          data: MyComponentFractal(
            color: Colors.white,
            borderColor: Colors.black,
            borderWidth: 2.0,
          ),
          type: componentType,
        );
        break;
    }
  }
  */
}

class DraggableComponent extends StatelessWidget {
  final MyPolicySet myPolicySet;
  final ComponentFractal componentFractal;

  const DraggableComponent({
    Key? key,
    required this.myPolicySet,
    required this.componentFractal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = myPolicySet.showComponentBody(componentFractal);
    return Draggable<ComponentFractal>(
      affinity: Axis.horizontal,
      ignoringFeedbackSemantics: true,
      data: componentFractal,
      childWhenDragging: body,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: componentFractal.size.width,
          height: componentFractal.size.height,
          child: myPolicySet.showComponentBody(componentFractal),
        ),
      ),
      child: myPolicySet.showComponentBody(componentFractal),
    );
  }
}
