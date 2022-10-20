import 'package:velocity_x/velocity_x.dart';

import '/diagram_editor.dart';
import '/editor/data/custom_component_data.dart';
import 'package:flutter/material.dart';

class ContainerBody extends StatelessWidget {
  final ComponentFractal componentFractal;

  const ContainerBody({
    Key? key,
    required this.componentFractal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customData = componentFractal.data;

    final text = customData.label.value.toString();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(4, 4), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Align(
          //alignment: customData.textAlignment,
          child: Text(
            text,
            style: TextStyle(
                //fontSize: customData.textSize,
                ),
          ),
        ),
      ),
    );
  }
}
