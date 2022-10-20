import '/src/utils/link_style.dart';
import '/src/utils/vector_utils.dart';
import 'package:flutter/material.dart';

class LinkPainter extends CustomPainter {
  final List<Offset> linkPoints;
  final double scale;
  final LinkStyle linkStyle;

  LinkPainter({
    required this.linkPoints,
    required this.scale,
    required this.linkStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = linkStyle.color
      ..strokeWidth = linkStyle.lineWidth * scale
      ..strokeJoin = StrokeJoin.bevel
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Path path = Path();
    //path.moveTo(linkPoints[0].dx, linkPoints[0].dy);

    for (int i = 0; i < linkPoints.length - 1; i++) {
      if (linkPoints.length == 2) {
        canvas.drawPath(
          linkStyle.getLinePath(
            VectorUtils.getShorterLineStart(
              linkPoints[i],
              linkPoints[i + 1],
              scale * linkStyle.getEndShortening(linkStyle.backArrowType),
            ),
            VectorUtils.getShorterLineEnd(
              linkPoints[i],
              linkPoints[i + 1],
              scale * linkStyle.getEndShortening(linkStyle.arrowType),
            ),
            scale,
          ),
          paint,
        );
      } else if (i == 0) {
        path.moveTo(linkPoints[i].dx, linkPoints[i].dy);
        /*
        canvas.drawPath(
          linkStyle.getLinePath(
            VectorUtils.getShorterLineStart(
              linkPoints[i],
              linkPoints[i + 1],
              scale * linkStyle.getEndShortening(linkStyle.backArrowType),
            ),
            linkPoints[i + 1],
            scale,
          ),
          paint,
        );
        */
      } else if (linkPoints.length < 3 && i == linkPoints.length - 2) {
        canvas.drawPath(
          linkStyle.getLinePath(
            linkPoints[i],
            VectorUtils.getShorterLineEnd(
              linkPoints[i],
              linkPoints[i + 1],
              scale * linkStyle.getEndShortening(linkStyle.arrowType),
            ),
            scale,
          ),
          paint,
        );
      } else {
        //path.lineTo(linkPoints[i].dx, linkPoints[i].dy);
        //path.arcToPoint(linkPoints[i], radius: Radius.circular(8));

        /*
        if (i.isEven)
          path.quadraticBezierTo(
            linkPoints[i].dx,
            linkPoints[i].dy,
            linkPoints[i + 1].dx,
            linkPoints[i + 1].dy,
          );
*/
        /*
        canvas.drawPath(
            linkStyle.getLinePath(
                linkPoints[i], linkPoints[i + 1], scale, linkPoints[i - 1]),
            paint);*/
      }
    }

    final ctrlValueT = 0.2;
    var points = <Offset>[]..addAll(linkPoints);
    path.reset();
    points.insert(0, Offset(points.first.dx, points.first.dy));
    points.add(Offset(points.last.dx, points.last.dy));
    points.add(Offset(points.last.dx, points.last.dy));
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length - 3; i++) {
      var ax =
          points[i].dx + (points[i + 1].dx - points[i - 1].dx) * ctrlValueT;
      var ay =
          points[i].dy + (points[i + 1].dy - points[i - 1].dy) * ctrlValueT;
      var bx =
          points[i + 1].dx - (points[i + 2].dx - points[i].dx) * ctrlValueT;
      var by =
          points[i + 1].dy - (points[i + 2].dy - points[i].dy) * ctrlValueT;
      path.cubicTo(ax, ay, bx, by, points[i + 1].dx, points[i + 1].dy);
    }

    //path.addPolygon(linkPoints, false);
    canvas.drawPath(path, paint);

    paint..style = PaintingStyle.fill;
    canvas.drawPath(
        linkStyle.getArrowTipPath(
          linkStyle.arrowType,
          linkStyle.arrowSize,
          linkPoints[linkPoints.length - 2],
          linkPoints[linkPoints.length - 1],
          scale,
        ),
        paint);

    canvas.drawPath(
        linkStyle.getArrowTipPath(
          linkStyle.backArrowType,
          linkStyle.backArrowSize,
          linkPoints[1],
          linkPoints[0],
          scale,
        ),
        paint);

    // DEBUG:
    // paint
    //   ..color = Colors.green
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = scale * 0.2;
    // canvas.drawPath(
    //     makeWiderLinePath(scale * (5 + linkStyle.lineWidth)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    Path path = makeWiderLinePath(scale * (5 + linkStyle.lineWidth));
    return path.contains(position);
  }

  Path makeWiderLinePath(double hitAreaWidth) {
    Path path = new Path();
    for (int i = 0; i < linkPoints.length - 1; i++) {
      var point1 = linkPoints[i];
      var point2 = linkPoints[i + 1];

      // if (i == 0)
      //   point1 = PainterUtils.getShorterLineStart(point1, point2, scale * 10);
      // if (i == linkPoints.length - 2)
      //   point2 = PainterUtils.getShorterLineEnd(point1, point2, scale * 10);

      path.addPath(VectorUtils.getRectAroundLine(point1, point2, hitAreaWidth),
          Offset(0, 0));
    }
    return path;
  }
}
