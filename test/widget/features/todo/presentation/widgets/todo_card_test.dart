import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_card.dart';

void main() {
  group('TodoCard Widget Tests', () {
    testWidgets('should display todo text and date correctly', (
      WidgetTester tester,
    ) async {
      // Arrange: Create sample todo
      final sampleTodo = TodoEntity(
        id: 'test-1',
        text: 'Complete project documentation',
        completed: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act: Build TodoCard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoCard(
              todo: sampleTodo,
              onEdit: (todo) {},
              onDelete: (todo) {},
              onToggle: () {},
            ),
          ),
        ),
      );

      // Assert: Verify todo text is displayed
      expect(find.text('Complete project documentation'), findsOneWidget);

      // Assert: Verify date is displayed
      expect(find.text('Hari ini'), findsOneWidget);

      // Assert: Verify checkbox is displayed (unchecked)
      final checkboxContainer = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(checkboxContainer, isNotNull);
    });

    testWidgets('should render completed todo with strikethrough', (
      WidgetTester tester,
    ) async {
      // Arrange: Create completed todo
      final completedTodo = TodoEntity(
        id: 'test-2',
        text: 'Review code changes',
        completed: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      );

      // Act: Build TodoCard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoCard(
              todo: completedTodo,
              onEdit: (todo) {},
              onDelete: (todo) {},
              onToggle: () {},
            ),
          ),
        ),
      );

      // Assert: Verify todo text is displayed
      expect(find.text('Review code changes'), findsOneWidget);

      // Assert: Verify date shows "Kemarin" (yesterday)
      expect(find.text('Kemarin'), findsOneWidget);

      // Assert: Verify text has strikethrough decoration
      final textWidget = tester.widget<Text>(find.text('Review code changes'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);

      // Assert: Verify check icon is displayed for completed todo
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
