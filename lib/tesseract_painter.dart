import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class TesseractPainter extends CustomPainter {
  final double angle;
  TesseractPainter({this.angle});
  Paint painter = Paint()
    ..color = Color(0xFF000000)
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12;

  Vector2 m4;
  List<Vector2> square = [
    Vector2(-50, 50),
    Vector2(-50, -50),
    Vector2(50, -50),
    Vector2(50, 50),
  ];
  List<Vector3> cube = [
    Vector3(-50, -50, -50),
    Vector3(50, -50, -50),
    Vector3(50, 50, -50),
    Vector3(-50, 50, -50),
    Vector3(-50, -50, 50),
    Vector3(50, -50, 50),
    Vector3(50, 50, 50),
    Vector3(-50, 50, 50),
  ];
  List<Vector4> tesseract = [
    Vector4(-50, -50, -50, 50),
    Vector4(50, -50, -50, 50),
    Vector4(50, 50, -50, 50),
    Vector4(-50, 50, -50, 50),
    Vector4(-50, -50, 50, 50),
    Vector4(50, -50, 50, 50),
    Vector4(50, 50, 50, 50),
    Vector4(-50, 50, 50, 50),
    Vector4(-50, -50, -50, -50),
    Vector4(50, -50, -50, -50),
    Vector4(50, 50, -50, -50),
    Vector4(-50, 50, -50, -50),
    Vector4(-50, -50, 50, -50),
    Vector4(50, -50, 50, -50),
    Vector4(50, 50, 50, -50),
    Vector4(-50, 50, 50, -50),
  ];
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height / 2;
    double width = size.width / 2;
    List<Offset> points = List<Offset>();
    /*for (int i = 0; i < cube.length; i++) {
      points.add(get2dPoints(i, square, width, height, angle));
      points.add(get2dPoints(i + 1, square, width, height, angle));
    }*/
    /*for (int i = 0; i < 4; i++) {
      points.add(get3dPoints(i, cube, width, height, angle));
      points.add(get3dPoints((i + 1) % 4, cube, width, height, angle));

      points.add(get3dPoints(i + 4, cube, width, height, angle));
      points.add(get3dPoints(((i + 1) % 4) + 4, cube, width, height, angle));

      points.add(get3dPoints(i, cube, width, height, angle));
      points.add(get3dPoints(i + 4, cube, width, height, angle));
    }*/
    for (int i = 0; i < tesseract.length; i++) {
      points.add(get4dPoints(i, tesseract, width, height, angle));
      points.add(get4dPoints(i + 1, tesseract, width, height, angle));
    }
    canvas.drawPoints(PointMode.lines, points, painter);
  }

  Offset get2dPoints(int position, List<Vector2> square, double width,
      double height, double angle) {
    List<Vector2> secondVector = [
      Vector2(
        math.cos(angle),
        0,
      ),
      Vector2(0, 1)
    ];
    if (position >= square.length) {
      position = 0;
    }
    Vector2 input = Vector2(square[position].x, square[position].y);
    Vector2 output = matmul2d(input, secondVector);

    return Offset(output.x, output.y);
  }

  Offset get3dPoints(int position, List<Vector3> cube, double width,
      double height, double angle) {
    List<Vector3> rotX = [
      Vector3(1, 0, 0),
      Vector3(0, math.cos(angle), -math.sin(angle)),
      Vector3(0, math.sin(angle), math.cos(angle)),
    ];
    List<Vector3> rotY = [
      Vector3(math.cos(angle), 0, -math.sin(angle)),
      Vector3(0, 1, 0),
      Vector3(math.sin(angle), 0, math.cos(angle)),
    ];
    if (position >= cube.length) {
      position = 0;
    }
    Vector3 input =
        Vector3(cube[position].x, cube[position].y, cube[position].z);
    Vector3 output = matmul3d(input, rotY);
    Vector3 output2 = matmul3d(output, rotX);

    return Offset(width + output2.x, height + output2.y);
  }

  Offset get4dPoints(int position, List<Vector4> tesseract, double width,
      double height, double angle) {
    if (position >= tesseract.length) {
      position = 0;
    }
    double distance = 50;
    double focus = 1 / distance - tesseract[position].w;

    List<Vector4> rotX = [
      Vector4(focus, 0, 0, 0),
      Vector4(0, focus, 0, 0),
      Vector4(0, 0, focus, 0),
      Vector4(0, 0, 0, focus),
    ];

    Vector4 input = Vector4(tesseract[position].x, tesseract[position].y,
        tesseract[position].z, tesseract[position].w);
    Vector4 output = matmul4d(input, rotX);

    return Offset(width + output.x, height + output.y);
  }

  Vector2 matmul2d(Vector2 vector, List<Vector2> secondVector) {
    double x = vector.x * secondVector[0].x + vector.y * secondVector[1].x;
    double y = vector.x * secondVector[0].y + vector.y * secondVector[1].y;
    return Vector2(x, y);
  }

  Vector3 matmul3d(Vector3 vector, List<Vector3> secondVector) {
    double x = vector.x * secondVector[0].x +
        vector.y * secondVector[1].x +
        vector.z * secondVector[2].x;
    double y = vector.x * secondVector[0].y +
        vector.y * secondVector[1].y +
        vector.z * secondVector[2].y;
    double z = vector.x * secondVector[0].z +
        vector.y * secondVector[1].z +
        vector.z * secondVector[2].z;
    return Vector3(x, y, z);
  }

  Vector4 matmul4d(Vector4 vector, List<Vector4> secondVector) {
    double x = vector.x * secondVector[0].x +
        vector.y * secondVector[1].x +
        vector.z * secondVector[2].x +
        vector.w * secondVector[3].x;
    double y = vector.x * secondVector[0].y +
        vector.y * secondVector[1].y +
        vector.z * secondVector[2].y +
        vector.w * secondVector[3].y;
    double z = vector.x * secondVector[0].z +
        vector.y * secondVector[1].z +
        vector.z * secondVector[2].z +
        vector.w * secondVector[3].z;
    double w = vector.x * secondVector[0].w +
        vector.y * secondVector[1].w +
        vector.z * secondVector[2].w +
        vector.z * secondVector[3].w;
    return Vector4(x, y, z, w);
  }

  @override
  bool shouldRepaint(TesseractPainter oldDelegate) {
    return angle != oldDelegate.angle;
  }
}
