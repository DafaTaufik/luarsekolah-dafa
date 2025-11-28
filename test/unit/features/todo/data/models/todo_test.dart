import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';

// Mock class for DocumentSnapshot
class MockDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('Todo Model Tests', () {
    test('fromFirestore should correctly parse Firestore document', () {
      // Arrange: Create mock document with test data
      final mockDoc = MockDocumentSnapshot();
      final testDate = DateTime(2025, 11, 28, 10, 30);
      final testTimestamp = Timestamp.fromDate(testDate);

      // Mock the document ID and data
      when(() => mockDoc.id).thenReturn('test-todo-123');
      when(() => mockDoc.data()).thenReturn({
        'text': 'Complete project documentation',
        'completed': false,
        'createdAt': testTimestamp,
        'updatedAt': testTimestamp,
      });

      // Act: Parse the document into Todo model
      final todo = Todo.fromFirestore(mockDoc);

      // Assert: Verify all fields are parsed correctly
      expect(todo.id, 'test-todo-123');
      expect(todo.text, 'Complete project documentation');
      expect(todo.completed, false);
      expect(todo.createdAt, testDate);
      expect(todo.updatedAt, testDate);
    });

    test('fromFirestore should handle completed todo correctly', () {
      // Arrange: Create mock document for completed todo
      final mockDoc = MockDocumentSnapshot();
      final testDate = DateTime(2025, 11, 27, 15, 45);
      final testTimestamp = Timestamp.fromDate(testDate);

      when(() => mockDoc.id).thenReturn('completed-todo-456');
      when(() => mockDoc.data()).thenReturn({
        'text': 'Review code changes',
        'completed': true,
        'createdAt': testTimestamp,
        'updatedAt': testTimestamp,
      });

      // Act
      final todo = Todo.fromFirestore(mockDoc);

      // Assert
      expect(todo.id, 'completed-todo-456');
      expect(todo.text, 'Review code changes');
      expect(todo.completed, true);
    });

    test('toFirestore should convert Todo to Firestore format', () {
      // Arrange: Create a Todo instance
      final testDate = DateTime(2025, 11, 28, 12, 0);
      final todo = Todo(
        id: 'todo-789',
        text: 'Write unit tests',
        completed: false,
        createdAt: testDate,
        updatedAt: testDate,
      );

      // Act: Convert to Firestore format
      final firestoreData = todo.toFirestore();

      // Assert: Verify the output format
      expect(firestoreData['text'], 'Write unit tests');
      expect(firestoreData['completed'], false);
      expect(firestoreData['createdAt'], isA<Timestamp>());
      expect(firestoreData['updatedAt'], isA<Timestamp>());

      // Verify the timestamp values
      final createdAtTimestamp = firestoreData['createdAt'] as Timestamp;
      final updatedAtTimestamp = firestoreData['updatedAt'] as Timestamp;
      expect(createdAtTimestamp.toDate(), testDate);
      expect(updatedAtTimestamp.toDate(), testDate);
    });
  });
}
