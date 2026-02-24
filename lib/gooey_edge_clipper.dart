import 'package:flutter/rendering.dart';
import 'gooey_edge.dart';

class GooeyEdgeClipper extends CustomClipper<Path> {
  final GooeyEdge edge;
  final double margin;

  GooeyEdgeClipper(this.edge, {this.margin = 0.0}) : super(reclip: edge);

  @override
  Path getClip(Size size) {
    return edge.buildPath(size, margin: margin);
  }

  @override
  bool shouldReclip(GooeyEdgeClipper oldClipper) => true;
}
