import '/src/abstraction_layer/policy/base/policy_set.dart';
import '/src/canvas_context/canvas_state.dart';
import '/src/canvas_context/model/component_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Component extends StatelessWidget {
  final PolicySet policy;

  /// Fundamental building unit of a diagram. Represents one component on the canvas.
  const Component({
    Key? key,
    required this.policy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final componentFractal = Provider.of<ComponentFractal>(context);
    final canvasState = Provider.of<CanvasState>(context);

    return Positioned(
      left: canvasState.scale * componentFractal.position.dx +
          canvasState.position.dx,
      top: canvasState.scale * componentFractal.position.dy +
          canvasState.position.dy,
      width: canvasState.scale * componentFractal.size.width,
      height: canvasState.scale * componentFractal.size.height,
      child: Listener(
        onPointerSignal: (PointerSignalEvent event) {
          policy.onComponentPointerSignal(componentFractal.id, event);
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: componentFractal.size.width,
                height: componentFractal.size.height,
                child: Container(
                  transform: Matrix4.identity()..scale(canvasState.scale),
                  child: policy.showComponentBody(componentFractal),
                ),
              ),
              policy.showCustomWidgetWithComponentFractal(
                  context, componentFractal),
            ],
          ),
          onTap: () => policy.onComponentTap(componentFractal.id),
          onTapDown: (TapDownDetails details) =>
              policy.onComponentTapDown(componentFractal.id, details),
          onTapUp: (TapUpDetails details) =>
              policy.onComponentTapUp(componentFractal.id, details),
          onTapCancel: () => policy.onComponentTapCancel(componentFractal.id),
          onScaleStart: (ScaleStartDetails details) =>
              policy.onComponentScaleStart(componentFractal.id, details),
          onScaleUpdate: (ScaleUpdateDetails details) =>
              policy.onComponentScaleUpdate(componentFractal.id, details),
          onScaleEnd: (ScaleEndDetails details) =>
              policy.onComponentScaleEnd(componentFractal.id, details),
          onLongPress: () => policy.onComponentLongPress(componentFractal.id),
          onLongPressStart: (LongPressStartDetails details) =>
              policy.onComponentLongPressStart(componentFractal.id, details),
          onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) => policy
              .onComponentLongPressMoveUpdate(componentFractal.id, details),
          onLongPressEnd: (LongPressEndDetails details) =>
              policy.onComponentLongPressEnd(componentFractal.id, details),
          onLongPressUp: () =>
              policy.onComponentLongPressUp(componentFractal.id),
        ),
      ),
    );
  }
}
