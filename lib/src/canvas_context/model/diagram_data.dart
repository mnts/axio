import '/diagram_editor.dart';

class DiagramData {
  final List<ComponentFractal> components;
  final List<LinkData> links;

  /// Contains list of all components and list of all links of the diagram
  DiagramData({
    required this.components,
    required this.links,
  });

  /*
  DiagramData.fromJson(
    Map<String, dynamic> json, {
    Function(Map<String, dynamic> json)? decodeCustomComponentFractal,
    Function(Map<String, dynamic> json)? decodeCustomLinkData,
  })  : components = (json['components'] != null)
            ? (json['components'] as List)
                .map((componentJson) => ComponentFractal.fromJson(
                      componentJson,
                      decodeCustomComponentFractal:
                          decodeCustomComponentFractal,
                    ))
                .toList()
            : [],
        links = (json['links'] != null)
            ? (json['links'] as List)
                .map((linkJson) => LinkData.fromJson(
                      linkJson,
                      decodeCustomLinkData: decodeCustomLinkData,
                    ))
                .toList()
            : [];
    */

  Map<String, dynamic> toJson() => {
        'components': components,
        'links': links,
      };
}
