import '/diagram_editor.dart';
import '/components/container.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget showComponentBody(ComponentFractal componentData) {
    return ContainerBody(componentFractal: componentData);
    /*
    switch (componentData.type) {
      case 'container':

      case 'rect':
        return RectBody(componentData: componentData);

      case 'round_rect':
        return RoundRectBody(componentData: componentData);
      case 'oval':
        return OvalBody(componentFractal: componentData);

      case 'crystal':
        return CrystalBody(componentData: componentData);

      case 'body':
        return RectBody(componentData: componentData);

      case 'rhomboid':
        return RhomboidBody(componentData: componentData);

      case 'bean':
        return BeanBody(componentData: componentData);

      case 'bean_left':
        return BeanLeftBody(componentData: componentData);

      case 'bean_right':
        return BeanRightBody(componentData: componentData);

      case 'document':
        return DocumentBody(componentData: componentData);

      case 'hexagon_horizontal':
        return HexagonHorizontalBody(componentData: componentData);

      case 'hexagon_vertical':
        return HexagonVerticalBody(componentData: componentData);

      case 'bend_left':
        return BendLeftBody(componentData: componentData);

      case 'bend_right':
        return BendRightBody(componentData: componentData);

      case 'no_corner_rect':
        return NoCornerRectBody(componentData: componentData);

      case 'junction':
        return OvalBody(componentFractal: componentData);

      default:
        return Container();
    }*/
  }
}
