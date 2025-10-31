import 'package:flutter/material.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/profile/pages/edit_profile.dart';
import '../../main_navigation.dart';
import 'package:luarsekolah/features/class/presentation/pages/add_class_page.dart';
import 'package:luarsekolah/features/class/presentation/pages/edit_class_page.dart';
import 'package:luarsekolah/features/class/models/course.dart';

class AppRoutes {
  static const String login = '/';
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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return fadeTransition(const LoginPage());
      case register:
        return slideTransition(const RegisterPage());
      case home:
        return fadeTransition(const MainNavigation());
      case editProfile:
        return slideTransition(const EditProfilePage());
      case editClass:
        // Expect Course object as argument
        final course = settings.arguments as Course?;
        if (course == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('Error: Course data is required')),
            ),
          );
        }
        return slideTransition(EditClassPage(course: course));
      case addClass:
        return slideTransition(const AddClassPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
