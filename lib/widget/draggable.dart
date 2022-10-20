import 'package:flutter/material.dart';

import '/diagram_editor.dart';
import '/editor/policy/my_policy_set.dart';

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
          child: body,
        ),
      ),
      child: body,
    );
  }
}
