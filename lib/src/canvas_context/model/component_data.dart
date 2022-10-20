import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/extensions/db.dart';
import 'package:fractals/extensions/word.dart';
import 'package:fractals/models/index.dart';
import 'package:fractals/models/link.dart';

import '/mixins/positioned.dart';
import '/src/canvas_context/model/connection.dart';
import 'package:flutter/material.dart';

const defaultType = 'container';

class ComponentFractal extends LinkFractal with PositionedFract {
  /// Component type to distinguish components.
  ///
  /// You can use it for example to distinguish what [data] type this component has.
  String type = defaultType;

  /// Assigned parent to this component.
  ///
  /// Use for hierarchical components.
  /// Functions such as [moveComponentWithChildren] work with this property.
  String? parentId;

  bool isHighlightVisible = false;

  /// List of children of this component.
  ///
  /// Use for hierarchical components.
  /// Functions such as [moveComponentWithChildren] work with this property.
  final List<String> childrenIds = [];

  /// Defines to which components is this components connected and what is the [connectionId].
  ///
  /// The connection can be [ConnectionOut] for link going from this component
  /// or [ConnectionIn] for link going from another to this component.
  final List<Connection> connections = [];

  /// Dynamic data for you to define your own data for this component.
  LinkFractal data;

  /// Represents data of a component in the model.
  ComponentFractal({
    String? id,
    //this.position,
    //this.size = const Size(80, 80),
    this.type = defaultType,
    required this.data,
  }) : //assert(minSize <= size),
        super(id ?? Uuid().v4());

  @override
  remove([sql = '']) {
    sql += '''
      $sql
      $removePositionedSQL
      DELETE FROM components WHERE id = '$id';
    ''';
    super.remove(sql);
  }

  // save component to database
  Future<void> save() async {
    Acc.db.insert(
      'components',
      {
        'id': id,
        'type': type,
        'ref': data.i,
      },
    );
    ensurePosition();
  }

  /// Updates this component on the canvas.
  ///
  /// Use this function if you somehow changed the component data and you want to propagate the change to canvas.
  /// Usually this is already called in most functions such as [move] or [setSize] so it's not necessary to call it again.
  ///
  /// It calls [notifyListeners] function of [ChangeNotifier].
  updateComponent() {
    notifyListeners();
  }

  /// Adds new connection to this component.
  ///
  /// Do not use it if you are not sure what you do. This is called in [connectTwoComponents] function.
  addConnection(Connection connection) {
    connections.add(connection);
  }

  /// Removes existing connection.
  ///
  /// Do not use it if you are not sure what you do. This is called eg. in [removeLink] function.
  removeConnection(String connectionId) {
    connections.removeWhere((conn) => conn.connectionId == connectionId);
  }

  /// Sets the component's parent.
  ///
  /// It's not possible to make a parent-child loop. (its ancestor cannot be its child)
  ///
  /// You should use it only with [addChild] on the parent's component.
  setParent(String parentId) {
    this.parentId = parentId;
  }

  /// Removes parent's id from this component data.
  ///
  /// You should use it only with [removeChild] on the parent's component.
  removeParent() {
    this.parentId = null;
  }

  /// Sets the component's parent.
  ///
  /// It's not possible to make a parent-child loop. (its ancestor cannot be its child)
  ///
  /// You should use it only with [setParent] on the child's component.
  addChild(String childId) {
    childrenIds.add(childId);
  }

  /// Removes child's id from children.
  ///
  /// You should use it only with [removeParent] on the child's component.
  removeChild(String childId) {
    childrenIds.remove(childId);
  }

  @override
  String toString() {
    return 'Component data ($id), position: $position';
  }

  ComponentFractal.fromMap(Map<String, dynamic> m)
      : data = Word('link').take(m['ref']) as LinkFractal,
        super(m) {
    //data = MyComponentFractal.fromMap(m['data']);

    fromMapPosition(m);
    //parentId = m['parentId'];
  }

  /*
  ComponentFractal.fromJson(
    Map<String, dynamic> json, {
    Function(Map<String, dynamic> json)? decodeCustomComponentFractal,
  })  : id = json['id'],
        position = Offset(json['position'][0], json['position'][1]),
        size = Size(json['size'][0], json['size'][1]),
        minSize = Size(json['min_size'][0], json['min_size'][1]),
        type = json['type'],
        zOrder = json['z_order'],
        parentId = json['parent_id'],
        data = decodeCustomComponentFractal?.call(json['dynamic_data']) {
    if (json['children_ids'] != null)
      this.childrenIds.addAll(
          (json['children_ids'] as List).map((id) => id as String).toList());
    if (json['connections'] != null)
      this.connections.addAll((json['connections'] as List)
          .map((connectionJson) => Connection.fromJson(connectionJson)));
  }
    */

  Map<String, dynamic> toJson() => {
        'id': id,
        'position': [position.dx, position.dy],
        'size': [size.width, size.height],
        'min_size': [minSize.width, minSize.height],
        'type': type,
        'z_order': zOrder,
        if (parentId != null) 'parent_id': parentId,
        if (childrenIds.isNotEmpty) 'children_ids': childrenIds,
        if (connections.isNotEmpty)
          'connections': [
            ...connections.map((con) => con.toJson()),
          ],
        'dynamic_data': data.toMap(),
      };

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'x': position.dx,
        'y': position.dy,
        'z': zOrder,
        'w': size.width,
        'h': size.height,
        'type': type,
        if (parentId != null) 'parent_id': parentId,
        /*
        'min_size': [minSize.width, minSize.height],
        if (childrenIds.isNotEmpty) 'children_ids': childrenIds,
        if (connections.isNotEmpty)
          'connections': [
            ...connections.map((con) => con.toJson()),
          ],
        'dynamic_data': data.toMap(),
        */
      };
}
