import '/diagram_editor.dart';
import '/editor/policy/custom_policy.dart';
import '../../widget/option_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin MyComponentWidgetsPolicy
    implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentFractalOver(
      BuildContext context, ComponentFractal f) {
    bool isJunction = f.type == 'junction';
    bool showOptions =
        (!isMultipleSelectionOn) && (!isReadyToConnect) && !isJunction;

    return Visibility(
      visible: f.isHighlightVisible,
      child: Stack(
        children: [
          if (showOptions) componentTopOptions(f, context),
          if (showOptions) componentBottomOptions(f),
          highlight(f, isMultipleSelectionOn ? Colors.cyan : Colors.red),
          if (showOptions) resizeCorner(f),
          if (isJunction && !isReadyToConnect) junctionOptions(f),
        ],
      ),
    );
  }

  Widget componentTopOptions(ComponentFractal c, context) {
    Offset componentPosition =
        canvasReader.state.toCanvasCoordinates(c.position);
    return Positioned(
      left: componentPosition.dx - 24,
      top: componentPosition.dy - 48,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.5),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 40,
            onPressed: () {
              canvasWriter.model.removeComponent(c.id);
              c.remove();
              selectedComponentId = '';
            },
          ),
          OptionIcon(
            color: Colors.grey.withOpacity(0.5),
            iconData: Icons.copy,
            tooltip: 'duplicate',
            size: 40,
            onPressed: () {
              String newId = duplicate(c);
              canvasWriter.model.moveComponentToTheFront(newId);
              selectedComponentId = newId;
              hideComponentHighlight(c.id);
              highlightComponent(newId);
            },
          ),
          /*
          SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.5),
            iconData: Icons.edit,
            tooltip: 'edit',
            size: 40,
            onPressed: () => showEditComponentDialog(context, ComponentFractal),
          ),
          SizedBox(width: 12),
          */
          OptionIcon(
            color: Colors.grey.withOpacity(0.5),
            iconData: Icons.link_off,
            tooltip: 'remove links',
            size: 40,
            onPressed: () =>
                canvasWriter.model.removeComponentConnections(c.id),
          ),
        ],
      ),
    );
  }

  Widget componentBottomOptions(ComponentFractal ComponentFractal) {
    Offset componentBottomLeftCorner = canvasReader.state.toCanvasCoordinates(
        ComponentFractal.position +
            ComponentFractal.size.bottomLeft(Offset.zero));
    return Positioned(
      left: componentBottomLeftCorner.dx - 16,
      top: componentBottomLeftCorner.dy + 8,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.5),
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () =>
                canvasWriter.model.moveComponentToTheFront(ComponentFractal.id),
          ),
          OptionIcon(
            color: Colors.grey.withOpacity(0.5),
            iconData: Icons.arrow_downward,
            tooltip: 'move to back',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () =>
                canvasWriter.model.moveComponentToTheBack(ComponentFractal.id),
          ),
          SizedBox(width: 40),
          OptionIcon(
            color: Colors.grey.withOpacity(0.5),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 40,
            onPressed: () {
              isReadyToConnect = true;
              ComponentFractal.updateComponent();
            },
          ),
        ],
      ),
    );
  }

  Widget highlight(ComponentFractal ComponentFractal, Color color) {
    return Positioned(
      left: canvasReader.state
          .toCanvasCoordinates(ComponentFractal.position - Offset(2, 2))
          .dx,
      top: canvasReader.state
          .toCanvasCoordinates(ComponentFractal.position - Offset(2, 2))
          .dy,
      child: CustomPaint(
        painter: ComponentHighlightPainter(
          width: (ComponentFractal.size.width + 4) * canvasReader.state.scale,
          height: (ComponentFractal.size.height + 4) * canvasReader.state.scale,
          color: color,
        ),
      ),
    );
  }

  resizeCorner(ComponentFractal ComponentFractal) {
    Offset componentBottomRightCorner = canvasReader.state.toCanvasCoordinates(
        ComponentFractal.position +
            ComponentFractal.size.bottomRight(Offset.zero));
    return Positioned(
      left: componentBottomRightCorner.dx - 12,
      top: componentBottomRightCorner.dy - 12,
      child: GestureDetector(
        onPanUpdate: (details) {
          canvasWriter.model.resizeComponent(
              ComponentFractal.id, details.delta / canvasReader.state.scale);
          canvasWriter.model.updateComponentLinks(ComponentFractal.id);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeDownRight,
          child: Container(
            width: 24,
            height: 24,
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.grey[200]!),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget junctionOptions(ComponentFractal ComponentFractal) {
    Offset componentPosition =
        canvasReader.state.toCanvasCoordinates(ComponentFractal.position);
    return Positioned(
      left: componentPosition.dx - 24,
      top: componentPosition.dy - 48,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 32,
            onPressed: () {
              canvasWriter.model.removeComponent(ComponentFractal.id);
              selectedComponentId = '';
            },
          ),
          SizedBox(width: 8),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 32,
            onPressed: () {
              isReadyToConnect = true;
              ComponentFractal.updateComponent();
            },
          ),
        ],
      ),
    );
  }
}
