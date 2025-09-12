import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/src/elements/flow_element.dart';
import 'package:flutter_flow_chart/src/objects/element_text_widget.dart';
import 'package:flutter_flow_chart/src/objects/element_image_widget.dart';

/// A kind of element
class RectangleWidget extends StatelessWidget {
  ///
  const RectangleWidget({
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: element.backgroundColor,
              boxShadow: [
                if (element.elevation > 0.01)
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(element.elevation, element.elevation),
                    blurRadius: element.elevation * 1.3,
                  ),
              ],
              border: Border.all(
                color: element.borderColor,
                width: element.borderThickness,
              ),
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
