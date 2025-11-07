# LuarSekolah - Architecture & Guide (Clean Architecture + GetX)

This document summarizes the architecture applied to the Todo and Class features: layering (data/domain/presentation), repository, use cases, controller, GetX DI bindings, and GetX Named Route routing.

## Goals

- Clear separation of concerns: data (API access), domain (business/use cases), presentation (UI + controller)
- Dependency Injection via GetX Bindings
- Consistent navigation with GetX Named Routes + per-route bindings

## Directory Structure (concise)

```
lib/
  core/
    constants/               // colors, keys, route helpers
    services/                // dio_client
  features/
    routes/
      app_routes.dart        // GetX named routes + getPages

    todo/
      data/
        models/
        repositories/
          todo_repository.dart
      domain/
        usecases/
          create_todo_usecase.dart
          delete_todo_usecase.dart
          get_todo_by_id_usecase.dart
          get_todos_usecase.dart
          toggle_todo_completion_usecase.dart
          update_todo_usecase.dart
      presentation/
        bindings/
          todo_binding.dart
        controllers/
          todo_controller.dart
        pages/
          todo_list_page.dart
          add_todo_page.dart
        widgets/
          ...
      services/
        todo_service.dart

    class/
      data/
        models/
        repositories/
          class_repository.dart
      domain/
        usecases/
          create_course_usecase.dart
          delete_course_usecase.dart
          get_course_by_id_usecase.dart
          get_courses_usecase.dart
          update_course_usecase.dart
      presentation/
        bindings/
          class_binding.dart
        controllers/
          class_controller.dart
        pages/
          class_page.dart
          add_class_page.dart
          edit_class_page.dart
        widgets/
          ...
      services/
        course_service.dart
```

## Data Flow

- UI (Page/Widget) → Controller (GetX) → Use Case (Domain) → Repository (Data) → Service (API)
- Controllers store reactive state (Rx), call use cases, and map results to UI.

## Bindings (GetX DI)

- Todo: `features/todo/presentation/bindings/todo_binding.dart`
  - Registers: `TodoService` → `TodoRepository` → all `UseCases` → `TodoController`
- Class: `features/class/presentation/bindings/class_binding.dart`
  - Registers: `CourseService` → `ClassRepository` → all `UseCases` → `ClassController`
- Use `Get.lazyPut`, and `fenix: true` for controllers if they need to be recreated when disposed.

## Routing (GetX Named Routes)

File: `features/routes/app_routes.dart`

Example:

```dart
GetPage(name: AppRoutes.todoList, page: () => const TodoListPage(), binding: TodoBinding()),
GetPage(name: AppRoutes.addTodo,  page: () => AddTodoPage(todo: Get.arguments)),
GetPage(name: AppRoutes.classList, page: () => const ClassPage(), binding: ClassBinding()),
GetPage(name: AppRoutes.addClass,  page: () => const AddClassPage()),
GetPage(name: AppRoutes.editClass, page: () => EditClassPage(course: Get.arguments)),
```

Usage:

```dart
Get.toNamed(AppRoutes.classList);
Get.offAllNamed(AppRoutes.home);
Get.toNamed(AppRoutes.editClass, arguments: course);
```

Note: For tabs rendered by bottom navigation (`MainNavigation`), bindings are initialized in `build()` so controllers are ready when tabs open.

## Use Case Pattern

- One file per action: easier to test and maintain.
- No UI references in the domain layer.

## Repository Pattern

- Thin adapter to service/API. Stateless.

## Navigation Migration

- `Navigator.push*` → `Get.toNamed / Get.off*Named`
- `Navigator.pop(context)` → `Get.back()`
- Return data: `Get.back(result: data)` and receive with `final result = await Get.to<T>(...)`

## Notes

- Bottom navigation does not automatically trigger per-route bindings; manual initialization in `MainNavigation.build()` is added.
