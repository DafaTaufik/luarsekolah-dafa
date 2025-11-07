import 'package:get/get.dart';
import 'package:luarsekolah/features/todo/services/todo_service.dart';
import 'package:luarsekolah/features/todo/data/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:luarsekolah/features/todo/domain/usecases/get_todo_by_id_usecase.dart';
import 'package:luarsekolah/features/todo/domain/usecases/create_todo_usecase.dart';
import 'package:luarsekolah/features/todo/domain/usecases/update_todo_usecase.dart';
import 'package:luarsekolah/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:luarsekolah/features/todo/domain/usecases/toggle_todo_completion_usecase.dart';
import 'package:luarsekolah/features/todo/presentation/controllers/todo_controller.dart';
import 'package:luarsekolah/core/services/dio_client.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodoService(DioClient().dio));
    Get.lazyPut(() => TodoRepository(Get.find()));
    Get.lazyPut(() => GetTodosUseCase(Get.find()));
    Get.lazyPut(() => GetTodoByIdUseCase(Get.find()));
    Get.lazyPut(() => CreateTodoUseCase(Get.find()));
    Get.lazyPut(() => UpdateTodoUseCase(Get.find()));
    Get.lazyPut(() => DeleteTodoUseCase(Get.find()));
    Get.lazyPut(() => ToggleTodoCompletionUseCase(Get.find()));
    Get.lazyPut(() => TodoController(), fenix: true);
  }
}
