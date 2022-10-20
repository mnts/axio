import '../../diagram.dart';
import '/diagram_editor.dart';
import '/editor/data/custom_link_data.dart';
import '/editor/policy/custom_policy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MyComponentPolicy implements ComponentPolicy, CustomStatePolicy {
  @override
  onComponentTap(String componentId) {
    if (isMultipleSelectionOn) {
      if (multipleSelected.contains(componentId)) {
        removeComponentFromMultipleSelection(componentId);
        hideComponentHighlight(componentId);
      } else {
        addComponentToMultipleSelection(componentId);
        highlightComponent(componentId);
      }
    } else {
      hideAllHighlights();

      if (isReadyToConnect) {
        isReadyToConnect = false;
        bool connected = connectComponents(selectedComponentId, componentId);
        if (connected) {
          print('connected');
          selectedComponentId = '';
        } else {
          print('not connected');
          selectedComponentId = componentId;
          highlightComponent(componentId);
        }
      } else {
        selectedComponentId = componentId;
        highlightComponent(componentId);
      }
    }
  }

  @override
  onComponentLongPress(String componentId) {
    var cmp = canvasReader.model.getComponent(componentId);
    //todo implement long press on component
    //showEditComponentDialog(Get.context!, cmp);
  }

  Offset lastFocalPoint = Offset.zero;

  @override
  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;

    hideLinkOption();
    if (isMultipleSelectionOn) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
    }
  }

  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;
    if (isMultipleSelectionOn) {
      multipleSelected.forEach((compId) {
        var cmp = canvasReader.model.getComponent(compId);
        canvasWriter.model.moveComponent(compId, positionDelta);
        cmp.connections.forEach((connection) {
          if (connection is ConnectionOut &&
              multipleSelected.contains(connection.otherComponentId)) {
            canvasWriter.model.moveAllLinkMiddlePoints(
                connection.connectionId, positionDelta);
          }
        });
      });
    } else {
      canvasWriter.model.moveComponent(componentId, positionDelta);
    }
    lastFocalPoint = details.localFocalPoint;
  }

  bool connectComponents(String sourceComponentId, String targetComponentId) {
    if (sourceComponentId == null) {
      return false;
    }
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    if (canvasReader.model.getComponent(sourceComponentId).connections.any(
        (connection) =>
            (connection is ConnectionOut) &&
            (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    canvasWriter.model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 4,
        arrowSize: 8,
        backArrowSize: 8,
        color: Colors.orange,
        backArrowType: ArrowType.centerCircle,
      ),
      data: MyLinkData(),
    );

    return true;
  }
}
