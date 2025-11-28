import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'package:luarsekolah/features/todo/domain/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';
import 'package:luarsekolah/features/todo/data/models/todo_list_response.dart';

class TodoFirebaseRepositoryImpl implements TodoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's todos collection reference
  CollectionReference get _todosCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(userId).collection('todos');
  }

  @override
  Future<TodoListResponse> getTodos({
    int limit = 10,
    bool? completed,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _todosCollection.orderBy('createdAt', descending: true);

      // Add completed filter if provided
      if (completed != null) {
        query = query.where('completed', isEqualTo: completed);
      }

      // Add pagination cursor if provided
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Fetch limit + 1 to determine if more data exists
      query = query.limit(limit + 1);

      final snapshot = await query.get();
      final docs = snapshot.docs;

      // Check if there are more items
      final hasMore = docs.length > limit;

      // Take only the requested limit
      final todoDocs = hasMore ? docs.sublist(0, limit) : docs;
      final todos = todoDocs.map((doc) => Todo.fromFirestore(doc)).toList();

      // Get the last document for next pagination
      final newLastDocument = todoDocs.isNotEmpty ? todoDocs.last : null;

      return TodoListResponse(
        todos: todos,
        total: todos.length,
        limit: limit,
        lastDocument: newLastDocument,
        hasMore: hasMore,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get todo by ID from Firestore
  @override
  Future<TodoEntity> getTodoById(String id) async {
    try {
      final doc = await _todosCollection.doc(id).get();
      if (!doc.exists) {
        throw Exception('Todo not found');
      }
      return Todo.fromFirestore(doc);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create todo in Firestore
  @override
  Future<TodoEntity> createTodo(TodoEntity todo) async {
    try {
      final now = DateTime.now();
      final docRef = _todosCollection.doc();

      final newTodo = Todo(
        id: docRef.id,
        text: todo.text,
        completed: false,
        createdAt: now,
        updatedAt: now,
      );

      await docRef.set(newTodo.toFirestore());
      return newTodo;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Update todo in Firestore
  @override
  Future<TodoEntity> updateTodo(String id, TodoEntity todo) async {
    try {
      final updatedTodo = Todo(
        id: id,
        text: todo.text,
        completed: todo.completed,
        createdAt: todo.createdAt,
        updatedAt: DateTime.now(),
      );

      await _todosCollection.doc(id).update(updatedTodo.toFirestore());
      return updatedTodo;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete todo from Firestore
  @override
  Future<void> deleteTodo(String id) async {
    try {
      await _todosCollection.doc(id).delete();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Toggle todo completion in Firestore
  @override
  Future<TodoEntity> toggleTodoCompletion(String id) async {
    try {
      final doc = await _todosCollection.doc(id).get();
      if (!doc.exists) {
        throw Exception('Todo not found');
      }

      final currentTodo = Todo.fromFirestore(doc);
      final updatedTodo = Todo(
        id: id,
        text: currentTodo.text,
        completed: !currentTodo.completed,
        createdAt: currentTodo.createdAt,
        updatedAt: DateTime.now(),
      );

      await _todosCollection.doc(id).update(updatedTodo.toFirestore());
      return updatedTodo;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Private method to handle errors
  String _handleError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Akses ditolak. Silakan login kembali.';
        case 'not-found':
          return 'Data tidak ditemukan.';
        case 'unavailable':
          return 'Layanan tidak tersedia. Silakan coba lagi.';
        default:
          return error.message ?? 'Terjadi kesalahan';
      }
    }
    return error.toString();
  }

  /// DEBUG ONLY: Populate 70 test todos for lazy loading testing
  Future<void> populateTestTodos() async {
    try {
      final batch = _firestore.batch();

      final baseDate = DateTime(2025, 11, 27, 7, 0, 0);
      const timeRangeMinutes = 600;

      final todoTemplates = [
        'Complete project documentation',
        'Review code changes',
        'Update database schema',
        'Fix bug in authentication',
        'Implement lazy loading feature',
        'Write unit tests',
        'Optimize query performance',
        'Add error handling',
        'Refactor legacy code',
        'Update dependencies',
        'Design new UI component',
        'Create API endpoint',
        'Configure CI/CD pipeline',
        'Research new technology',
        'Conduct code review',
        'Deploy to staging',
        'Update user documentation',
        'Fix responsive layout',
        'Add loading indicators',
        'Implement caching strategy',
        'Setup monitoring alerts',
        'Improve accessibility',
        'Add validation rules',
        'Create backup strategy',
        'Optimize images',
        'Update security policies',
        'Integrate third-party API',
        'Add analytics tracking',
        'Create error logs',
        'Setup development environment',
        'Write technical specification',
        'Prepare release notes',
        'Test edge cases',
        'Add feature flags',
        'Update README file',
      ];

      for (int i = 0; i < 70; i++) {
        final docRef = _todosCollection.doc();

        // Random timestamp within range
        final randomMinutes =
            (i * 137) % timeRangeMinutes; // Pseudo-random distribution
        final timestamp = baseDate.add(Duration(minutes: randomMinutes));

        // Select todo text
        String todoText;
        if (i < todoTemplates.length) {
          todoText = todoTemplates[i];
        } else {
          final templateIndex = i % todoTemplates.length;
          todoText =
              '${todoTemplates[templateIndex]} #${(i ~/ todoTemplates.length) + 1}';
        }

        batch.set(docRef, {
          'text': todoText,
          'completed': false,
          'createdAt': Timestamp.fromDate(timestamp),
          'updatedAt': Timestamp.fromDate(timestamp),
        });
      }

      await batch.commit();
    } catch (e) {
      throw _handleError(e);
    }
  }
}
