import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koobits_flutter_app/presentation/screen/home/widget/loading_state_widget.dart';

void main() {
  group('LoadingStateWidgetTest', () {
    testWidgets('containsText', (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingStateWidget(),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      expect(find.text('Now Loading'), findsOneWidget);
    });
  });
}
