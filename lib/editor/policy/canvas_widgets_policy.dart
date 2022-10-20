import 'package:fractals/models/link.dart';

import '/diagram_editor.dart';
import '/editor/data/custom_component_data.dart';
import '/editor/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyCanvasWidgetsPolicy implements CanvasWidgetsPolicy, CustomStatePolicy {
  @override
  List<Widget> showCustomWidgetsOnCanvasBackground(BuildContext context) {
    return [
      Visibility(
        visible: isGridVisible,
        child: CustomPaint(
          size: Size.infinite,
          painter: GridPainter(
            offset: canvasReader.state.position / canvasReader.state.scale,
            scale: canvasReader.state.scale,
            lineWidth: (canvasReader.state.scale < 1.0)
                ? canvasReader.state.scale
                : 1.0,
            matchParentSize: false,
            lineColor: Colors.blue[900]!,
          ),
        ),
      ),
      DragTarget<LinkFractal>(
        builder: (_, __, ___) => Container(),
        onWillAccept: (LinkFractal? data) => true,
        onAcceptWithDetails: (DragTargetDetails<LinkFractal> details) =>
            _onAcceptWithDetails(details, context),
      ),
    ];
  }

  _onAcceptWithDetails(
    DragTargetDetails details,
    BuildContext context,
  ) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.offset);
    //ComponentFractal componentFractal = details.data;
    Offset componentPosition =
        canvasReader.state.fromCanvasCoordinates(localOffset);

    final LinkFractal f = details.data;

    final c = ComponentFractal(
      //data: MyComponentFractal.copy(componentFractal.data),
      data: details.data,
      type: 'container', // componentFractal.type,
    );
    String componentId = canvasWriter.model.addComponent(c);
    c.setPosition(componentPosition);
    c.save();

    canvasWriter.model.moveComponentToTheFrontWithChildren(componentId);
  }
}
