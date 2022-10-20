import 'dart:async';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:fractals/models/index.dart';

mixin PositionedFract on Fractal {
  /// Position on the canvas.
  var position = Offset.zero;

  /// Size of the component.
  var size = const Size(120, 80);

  /// Minimal size of a component.
  ///
  /// When [resizeDelta] is called the size will not go under this value.
  var minSize = const Size(4, 4);

  /// This value determines if this component will be above or under other components.
  /// Higher value means on the top.
  int zOrder = 0;

  fromMapPosition(Map<String, dynamic> m) {
    isPositionSaved = true;

    final position = Offset(
      (m['x'] as num).toDouble(),
      (m['y'] as num).toDouble(),
    );
    if (position.dx > 0 || position.dy > 0) {
      setPosition(position);
    }

    final size = Size(
      (m['w'] as num).toDouble(),
      (m['h'] as num).toDouble(),
    );
    if (size.width > 0 && size.height > 0) {
      setSize(size);
    }
  }

  // construct positioned fract
  constructPositioned() {}

  bool isPositionSaved = false;

  /// Sqlite remove position data
  String get removePositionedSQL => 'DELETE FROM positions WHERE i = $i;';

  /// Saves position to database
  bool ensurePosition() {
    if (isPositionSaved) return false;
    Acc.db.execute('''
      INSERT INTO positions (id, x, y, w, h, z)
      VALUES (?, ?, ?, ?, ?, ?)
    ''', [id, position.dx, position.dy, size.width, size.height, zOrder]);
    isPositionSaved = true;
    return true;
  }

  updatePosition() {
    if (ensurePosition()) return;
    Acc.db.execute('''
      UPDATE positions
      SET x = ?, y = ?
      WHERE id = ?
    ''', [position.dx, position.dy, id]);
  }

  updateSize() {
    if (ensurePosition()) return;
    Acc.db.execute('''
      UPDATE positions
      SET w = ?, h = ?
      WHERE id = ?
    ''', [size.width, size.height, id]);
  }

  /// Translates the component by [offset] value.
  Timer? moveTimer;
  move(Offset offset) {
    this.position += offset;
    moveTimer?.cancel();
    moveTimer = Timer(const Duration(seconds: 1), updatePosition);
    notifyListeners();
  }

  /// Sets the position of the component to [position] value.
  setPosition(Offset position) {
    this.position = position;
    notifyListeners();
  }

  /// Translates the component by [offset] value.
  Timer? sizeTimer;

  /// Changes the component's size by [deltaSize].
  ///
  /// You cannot change its size to smaller than [minSize] defined on the component.
  resizeDelta(Offset deltaSize) {
    var tempSize = size + deltaSize;
    if (tempSize.width < minSize.width) {
      tempSize = Size(minSize.width, tempSize.height);
    }
    if (tempSize.height < minSize.height) {
      tempSize = Size(tempSize.width, minSize.height);
    }

    setSize(tempSize);

    moveTimer?.cancel();
    moveTimer = Timer(const Duration(seconds: 1), updateSize);
  }

  /// Sets the component's to [size].
  setSize(Size size) {
    this.size = size;
    notifyListeners();
  }

  /// Returns Offset position on this component from [alignment].
  ///
  /// [Alignment.topLeft] returns [Offset.zero]
  ///
  /// [Alignment.center] or [Alignment(0, 0)] returns the center coordinates on this component.
  ///
  /// [Alignment.bottomRight] returns offset that is equal to size of this component.
  Offset getPointOnComponent(Alignment alignment) {
    return Offset(
      size.width * ((alignment.x + 1) / 2),
      size.height * ((alignment.y + 1) / 2),
    );
  }
}
