import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:flutter_flow_chart/src/dashboard.dart';
import 'package:flutter_flow_chart/src/elements/flow_element.dart';
import 'package:flutter_flow_chart/src/ui/draw_arrow.dart';

void main() {
  group('Dashboard Auto-Connection Tests', () {
    late Dashboard dashboard;

    setUp(() {
      dashboard = Dashboard();
    });

    test('First element should not have any connections', () {
      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element1);

      expect(dashboard.elements.length, 1);
      expect(element1.next.length, 0);
    });

    test('Second element should be automatically connected to first element', () {
      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      final element2 = FlowElement(
        position: const Offset(200, 100),
        size: const Size(80, 80),
        text: 'Element 2',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element1);
      dashboard.addElement(element2);

      expect(dashboard.elements.length, 2);
      expect(element1.next.length, 1);
      expect(element1.next.first.destElementId, element2.id);
    });

    test('Third element should be automatically connected to second element', () {
      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      final element2 = FlowElement(
        position: const Offset(200, 100),
        size: const Size(80, 80),
        text: 'Element 2',
        kind: ElementKind.rectangle,
      );

      final element3 = FlowElement(
        position: const Offset(300, 100),
        size: const Size(80, 80),
        text: 'Element 3',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element1);
      dashboard.addElement(element2);
      dashboard.addElement(element3);

      expect(dashboard.elements.length, 3);
      expect(element1.next.length, 1);
      expect(element2.next.length, 1);
      expect(element2.next.first.destElementId, element3.id);
    });

    test('Connection should be from right to left', () {
      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      final element2 = FlowElement(
        position: const Offset(200, 100),
        size: const Size(80, 80),
        text: 'Element 2',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element1);
      dashboard.addElement(element2);

      final connection = element1.next.first;
      expect(connection.arrowParams.startArrowPosition, Alignment.centerRight);
      expect(connection.arrowParams.endArrowPosition, Alignment.centerLeft);
    });

    test('Auto-connect can be disabled', () {
      dashboard.setAutoConnectElements(false);

      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      final element2 = FlowElement(
        position: const Offset(200, 100),
        size: const Size(80, 80),
        text: 'Element 2',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element1);
      dashboard.addElement(element2);

      expect(dashboard.elements.length, 2);
      expect(element1.next.length, 0); // No auto-connection when disabled
    });

    test('Auto-connect can be re-enabled', () {
      // First disable auto-connect
      dashboard.setAutoConnectElements(false);

      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      final element2 = FlowElement(
        position: const Offset(200, 100),
        size: const Size(80, 80),
        text: 'Element 2',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element1);
      dashboard.addElement(element2);

      expect(element1.next.length, 0); // No connection when disabled

      // Re-enable auto-connect
      dashboard.setAutoConnectElements(true);

      final element3 = FlowElement(
        position: const Offset(300, 100),
        size: const Size(80, 80),
        text: 'Element 3',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element3);

      expect(element2.next.length, 1); // Auto-connection works again
      expect(element2.next.first.destElementId, element3.id);
    });
  });

  group('Element Removal and Reconnection Tests', () {
    late Dashboard dashboard;

    setUp(() {
      dashboard = Dashboard();
    });

    test('Remove middle element and auto-reconnect', () {
      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      final element2 = FlowElement(
        position: const Offset(200, 100),
        size: const Size(80, 80),
        text: 'Element 2',
        kind: ElementKind.rectangle,
      );

      final element3 = FlowElement(
        position: const Offset(300, 100),
        size: const Size(80, 80),
        text: 'Element 3',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element1);
      dashboard.addElement(element2);
      dashboard.addElement(element3);

      // Verify initial connections
      expect(element1.next.length, 1);
      expect(element1.next.first.destElementId, element2.id);
      expect(element2.next.length, 1);
      expect(element2.next.first.destElementId, element3.id);

      // Remove middle element and reconnect
      final removed = dashboard.removeElementAndReconnect(element2);

      expect(removed, true);
      expect(dashboard.elements.length, 2);
      
      // Check that element1 now connects directly to element3
      expect(element1.next.length, 1);
      expect(element1.next.first.destElementId, element3.id);
    });

    test('Remove first element should not create new connections', () {
      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      final element2 = FlowElement(
        position: const Offset(200, 100),
        size: const Size(80, 80),
        text: 'Element 2',
        kind: ElementKind.rectangle,
      );

      final element3 = FlowElement(
        position: const Offset(300, 100),
        size: const Size(80, 80),
        text: 'Element 3',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element1);
      dashboard.addElement(element2);
      dashboard.addElement(element3);

      // Remove first element
      final removed = dashboard.removeElementAndReconnect(element1);

      expect(removed, true);
      expect(dashboard.elements.length, 2);
      
      // Element2 should still connect to element3, but no new connections should be created
      expect(element2.next.length, 1);
      expect(element2.next.first.destElementId, element3.id);
    });

    test('Remove last element should not create new connections', () {
      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      final element2 = FlowElement(
        position: const Offset(200, 100),
        size: const Size(80, 80),
        text: 'Element 2',
        kind: ElementKind.rectangle,
      );

      final element3 = FlowElement(
        position: const Offset(300, 100),
        size: const Size(80, 80),
        text: 'Element 3',
        kind: ElementKind.rectangle,
      );

      dashboard.addElement(element1);
      dashboard.addElement(element2);
      dashboard.addElement(element3);

      // Remove last element
      final removed = dashboard.removeElementAndReconnect(element3);

      expect(removed, true);
      expect(dashboard.elements.length, 2);
      
      // Element1 should still connect to element2, but no new connections should be created
      expect(element1.next.length, 1);
      expect(element1.next.first.destElementId, element2.id);
      expect(element2.next.length, 0);
    });

    test('Remove element with auto-connect disabled should not reconnect', () {
      dashboard.setAutoConnectElements(false);

      final element1 = FlowElement(
        position: const Offset(100, 100),
        size: const Size(80, 80),
        text: 'Element 1',
        kind: ElementKind.rectangle,
      );

      final element2 = FlowElement(
        position: const Offset(200, 100),
        size: const Size(80, 80),
        text: 'Element 2',
        kind: ElementKind.rectangle,
      );

      final element3 = FlowElement(
        position: const Offset(300, 100),
        size: const Size(80, 80),
        text: 'Element 3',
        kind: ElementKind.rectangle,
      );

      // Add elements first
      dashboard.addElement(element1);
      dashboard.addElement(element2);
      dashboard.addElement(element3);

      // Manually create connections since auto-connect is disabled
      final arrowParams = ArrowParams(
        startArrowPosition: Alignment.centerRight,
        endArrowPosition: Alignment.centerLeft,
        style: ArrowStyle.curve,
        color: Colors.black,
        thickness: 2.0,
      );
      
      dashboard.addNextById(element1, element2.id, arrowParams);
      dashboard.addNextById(element2, element3.id, arrowParams);

      // Remove middle element
      final removed = dashboard.removeElementAndReconnect(element2);

      expect(removed, true);
      expect(dashboard.elements.length, 2);
      
      // No reconnection should happen when auto-connect is disabled
      expect(element1.next.length, 0);
    });
  });
}
