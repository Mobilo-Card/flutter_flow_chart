import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/src/elements/flow_element.dart';

/// Widget for displaying images in flow elements
class ElementImageWidget extends StatelessWidget {
  ///
  const ElementImageWidget({
    required this.element,
    super.key,
  });

  ///
  final FlowElement element;

  @override
  Widget build(BuildContext context) {
    if (element.imageProvider == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Image(
        image: element.imageProvider!,
        width: element.size.width * 0.6, // 60% of element width
        height: element.size.height * 0.6, // 60% of element height
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, color: Colors.red);
        },
      ),
    );
  }
}
