import 'package:flutter/material.dart';
import '../auth/pages/login_page.dart';
import '../auth/pages/register_page.dart';
import '../profile/pages/edit_profile.dart';
import '../../main_navigation.dart';
import 'package:luarsekolah/features/class/presentation/pages/add_class_page.dart';
import 'package:luarsekolah/features/class/presentation/pages/edit_class_page.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/features/todo/presentation/pages/todo_list_page.dart';
import 'package:luarsekolah/features/todo/presentation/pages/add_todo_page.dart';
import 'package:luarsekolah/features/todo/presentation/bindings/todo_binding.dart';
import 'package:luarsekolah/features/class/presentation/pages/class_page.dart';
import 'package:luarsekolah/features/class/bindings/class_binding.dart';
// import route lain seperti login dan lain-lain di sini

class AppRoutes {
  static const String todoList = '/todoList';
  static const String addTodo = '/addTodo';
  static const String classList = '/classList';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String editProfile = '/editProfile';
  static const String editClass = '/editClass';
  static const String addClass = '/addClass';

  // Fade transition helper
  static Route<dynamic> fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  // Slide transition helper
  static Route<dynamic> slideTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static final List<GetPage> getPages = [
    // Route Todo
    GetPage(name: todoList, page: () => TodoListPage(), binding: TodoBinding()),
    // Route Add Todo (dapat Todo dari Get.arguments untuk edit, null untuk add)
    GetPage(
      name: addTodo,
      page: () => AddTodoPage(todo: Get.arguments),
    ),
    // Route Class
    GetPage(name: classList, page: () => ClassPage(), binding: ClassBinding()),
    // Route Login
    GetPage(name: login, page: () => const LoginPage()),
    // Route Register
    GetPage(name: register, page: () => const RegisterPage()),
    // Route Home
    GetPage(name: home, page: () => const MainNavigation()),
    // Route Edit Profile
    GetPage(name: editProfile, page: () => const EditProfilePage()),
    // Route Edit Class (dapat Course dari Get.arguments)
    GetPage(
      name: editClass,
      page: () => EditClassPage(course: Get.arguments),
    ),
    // Route Add Class
    GetPage(name: addClass, page: () => const AddClassPage()),
  ];
}
