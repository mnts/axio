import '/diagram_editor.dart';
import '/editor/data/custom_component_data.dart';
import 'package:flutter/material.dart';

mixin CustomStatePolicy implements PolicySet {
  bool _isGridVisible = true;
  bool get isGridVisible => _isGridVisible;
  set isGridVisible(bool value) {
    _isGridVisible = value;
    canvasReader.model.canvasState.notifyListeners();
  }

  List<String> bodies = [
    'container',
    'junction',
    'rect',
    'round_rect',
    'oval',
    'crystal',
    'rhomboid',
    'bean',
    'bean_left',
    'bean_right',
    'document',
    'hexagon_horizontal',
    'hexagon_vertical',
    'bend_left',
    'bend_right',
    'no_corner_rect',
  ];

  String selectedComponentId = '';

  bool isMultipleSelectionOn = false;
  List<String> multipleSelected = [];

  Offset deleteLinkPos = Offset.zero;

  bool isReadyToConnect = false;

  String selectedLinkId = '';
  Offset tapLinkPosition = Offset.zero;

  hideAllHighlights() {
    canvasWriter.model.hideAllLinkJoints();
    hideLinkOption();
    canvasReader.model.getAllComponents().values.forEach((component) {
      if (component.isHighlightVisible) {
        component.isHighlightVisible = false;
        canvasWriter.model.updateComponent(component.id);
      }
    });
  }

  highlightComponent(String componentId) {
    canvasReader.model.getComponent(componentId).isHighlightVisible = true;
    canvasReader.model.getComponent(componentId).updateComponent();
  }

  hideComponentHighlight(String componentId) {
    canvasReader.model.getComponent(componentId).isHighlightVisible = false;
    canvasReader.model.getComponent(componentId).updateComponent();
  }

  turnOnMultipleSelection() {
    isMultipleSelectionOn = true;
    isReadyToConnect = false;

    if (selectedComponentId.isNotEmpty) {
      addComponentToMultipleSelection(selectedComponentId);
      selectedComponentId = '';
    }
  }

  turnOffMultipleSelection() {
    isMultipleSelectionOn = false;
    multipleSelected = [];
    hideAllHighlights();
  }

  addComponentToMultipleSelection(String componentId) {
    if (!multipleSelected.contains(componentId)) {
      multipleSelected.add(componentId);
    }
  }

  removeComponentFromMultipleSelection(String componentId) {
    multipleSelected.remove(componentId);
  }

  String duplicate(ComponentFractal componentFractal) {
    var f = ComponentFractal(
      type: componentFractal.type,
      //size: componentFractal.size,
      //minSize: componentFractal.minSize,
      //data: MyComponentFractal.copy(componentFractal.data),
      data: componentFractal.data,
    );

    f.setPosition(
      componentFractal.position + Offset(20, 20),
    );
    f.save();
    String id = canvasWriter.model.addComponent(f);
    return id;
  }

  showLinkOption(String linkId, Offset position) {
    selectedLinkId = linkId;
    tapLinkPosition = position;
  }

  hideLinkOption() {
    selectedLinkId = '';
  }
}

mixin CustomBehaviourPolicy implements PolicySet, CustomStatePolicy {
  removeAll() {
    canvasWriter.model.removeAllComponents();
  }

  resetView() {
    canvasWriter.state.resetCanvasView();
  }

  removeSelected() {
    multipleSelected.forEach((compId) {
      canvasWriter.model.removeComponent(compId);
    });
    multipleSelected = [];
  }

  duplicateSelected() {
    List<String> duplicated = [];
    multipleSelected.forEach((componentId) {
      String newId = duplicate(canvasReader.model.getComponent(componentId));
      duplicated.add(newId);
    });
    hideAllHighlights();
    multipleSelected = [];
    duplicated.forEach((componentId) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
      canvasWriter.model.moveComponentToTheFront(componentId);
    });
  }

  selectAll() {
    var components = canvasReader.model.canvasModel.components.keys;

    components.forEach((componentId) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
    });
  }
}
