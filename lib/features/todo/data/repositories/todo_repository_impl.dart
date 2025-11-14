import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'package:luarsekolah/features/todo/domain/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';
import 'package:luarsekolah/features/todo/data/models/todo_list_response.dart';

class TodoRepositoryImpl implements TodoRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TodoRepositoryImpl(this.firestore, this.auth);

  // Get current user's todos collection reference
  CollectionReference get _todosCollection {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return firestore.collection('users').doc(userId).collection('todos');
  }

  /// Get todos from Firestore
  /// Query params: limit, offset, completed
  @override
  Future<TodoListResponse> getTodos({
    int limit = 10,
    int offset = 0,
    bool? completed,
  }) async {
    try {
      Query query = _todosCollection.orderBy('createdAt', descending: true);

      // Add completed filter if provided
      if (completed != null) {
        query = query.where('completed', isEqualTo: completed);
      }

      // Apply limit
      query = query.limit(limit);

      final snapshot = await query.get();
      final todos = snapshot.docs
          .map((doc) => Todo.fromFirestore(doc))
          .toList();

      return TodoListResponse(
        todos: todos,
        total: todos.length,
        limit: limit,
        offset: offset,
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
}
