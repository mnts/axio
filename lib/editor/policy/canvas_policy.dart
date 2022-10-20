import '/diagram_editor.dart';
import '/editor/policy/custom_policy.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  @override
  onCanvasTap() {
    multipleSelected = [];

    if (isReadyToConnect) {
      isReadyToConnect = false;
      canvasWriter.model.updateComponent(selectedComponentId);
    } else {
      selectedComponentId = '';
      hideAllHighlights();
    }
  }
}
