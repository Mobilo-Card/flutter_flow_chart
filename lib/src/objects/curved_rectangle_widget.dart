import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/src/elements/flow_element.dart';
import 'package:flutter_flow_chart/src/objects/element_text_widget.dart';
import 'package:flutter_flow_chart/src/objects/element_image_widget.dart';

/// A kind of element - Curved Rectangle (left side curved)
class CurvedRectangleWidget extends StatelessWidget {
  ///
  const CurvedRectangleWidget({
    required this.element,
    super.key,
  });

  ///
  final FlowElement element;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: element.size.width,
      height: element.size.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: element.size,
            painter: _CurvedRectanglePainter(
              element: element,
            ),
          ),
          if (element.imageProvider != null)
            ElementImageWidget(element: element),
          ElementTextWidget(element: element),
        ],
      ),
    );
  }
}

class _CurvedRectanglePainter extends CustomPainter {
  _CurvedRectanglePainter({
    required this.element,
  });

  final FlowElement element;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final path = Path();

    paint
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.fill
      ..color = element.backgroundColor;

    // Curved Rectangle shape: rectangle with curved left side only
    final curveRadius = size.height * 0.4; // 40% of height for the curve radius (more rounded)
    
    // Start from the curved left side
    final leftCenter = Offset(curveRadius, size.height / 2);
    
    // Create the path starting from the top-left curve
    path.moveTo(curveRadius, 0); // Start at top of curve
    
    // Top edge (straight)
    path.lineTo(size.width, 0);
    
    // Right edge (straight)
    path.lineTo(size.width, size.height);
    
    // Bottom edge (straight)
    path.lineTo(curveRadius, size.height);
    
    // Left curved side
    path.addArc(
      Rect.fromCenter(
        center: leftCenter,
        width: curveRadius * 2,
        height: size.height,
      ),
      1.5708, // 90 degrees in radians (start from top)
      3.14159, // 180 degrees in radians (half circle)
    );

    if (element.elevation > 0.01) {
      canvas.drawShadow(
        path.shift(Offset(element.elevation, element.elevation)),
        Colors.black,
        element.elevation,
        true,
      );
    }
    canvas.drawPath(path, paint);

    // Draw border
    paint
      ..strokeWidth = element.borderThickness
      ..color = element.borderColor
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
