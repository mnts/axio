import 'package:axio/diagram.dart';
import 'package:axio/editor/policy/minimap_policy.dart';
import 'package:axio/editor/policy/my_policy_set.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/models/screen.dart';
import 'package:fractals/models/index.dart';

import 'package:fluent_query_builder/fluent_query_builder.dart';
import '../diagram_editor.dart';

import '/diagram.dart';
import '/models/diagram.dart';
import '/screens/diagram/ctrl.dart';

class DiagramScreenFractal extends ScreenFractal {
  late DiagramEditorContext diagramEditorContext;
  late DiagramEditorContext diagramEditorContextMiniMap;
  MyPolicySet myPolicySet = MyPolicySet();
  MiniMapPolicySet miniMapPolicySet = MiniMapPolicySet();

  bool isMenuVisible = true;
  bool isOptionsVisible = true;

  DiagramScreenFractal({
    super.name = 'diagram',
    super.icon = Icons.grain_sharp,
    super.builder = DiagramApp.new,
    super.ctrl = DiagramCtrl.new,
  }) {
    diagramEditorContext = DiagramEditorContext(
      policySet: myPolicySet,
    );
    diagramEditorContextMiniMap = DiagramEditorContext.withSharedModel(
      diagramEditorContext,
      policySet: miniMapPolicySet,
    );

    /*

    catalog = CatalogFractal<ComponentFractal>(
      id: 'msgs',
      select: q.toSql(),
      type: LogFractal.w,
    )*/
    loadComponents();
  }

  void loadComponents() {
    diagramEditorContext.canvasModel.components.clear();

    // sql query to select all fields from 'components and positions' tables joined by id
    Acc.db.select('''
      SELECT components.*, positions.*
      FROM components
      JOIN positions
      ON components.id = positions.id
    ''').every((el) {
      if (el['id'] == null) return false;
      final c = ComponentFractal.fromMap(el.cast());
      diagramEditorContext.policySet.canvasWriter.model.addComponent(c);
      return true;
    });
  }
}
