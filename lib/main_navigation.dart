import 'package:flutter/material.dart';
import 'package:luarsekolah/features/kelas/pages/kelas_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'features/home/pages/home_page.dart';
import 'features/profile/pages/profile_page.dart';
import 'core/constants/app_colors.dart';
import 'features/kelasku/pages/kelasku_page.dart';
import 'features/koinLs/pages/koinLs_page.dart';
import 'features/todo/pages/todo_list_page.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: const HomePage(),
        item: ItemConfig(
          icon: const Icon(Icons.home),
          title: "Home",
          activeForegroundColor: AppColors.greenDecorative,
          inactiveForegroundColor: Colors.grey,
          iconSize: 23,
          textStyle: const TextStyle(fontSize: 11),
        ),
      ),
      PersistentTabConfig(
        screen: const KelasPage(),
        item: ItemConfig(
          icon: const Icon(Icons.class_),
          title: "Kelas",
          activeForegroundColor: AppColors.greenDecorative,
          inactiveForegroundColor: Colors.grey,
          iconSize: 23,
          textStyle: const TextStyle(fontSize: 11),
        ),
      ),
      PersistentTabConfig(
        screen: const KelaskuPage(),
        item: ItemConfig(
          icon: const Icon(Icons.play_arrow_rounded),
          title: "Kelasku",
          activeForegroundColor: AppColors.greenDecorative,
          inactiveForegroundColor: Colors.grey,
          iconSize: 23,
          textStyle: const TextStyle(fontSize: 11),
        ),
      ),
      PersistentTabConfig(
        screen: const KoinLsPage(),
        item: ItemConfig(
          icon: const Icon(Icons.monetization_on),
          title: "KoinLs",
          activeForegroundColor: AppColors.greenDecorative,
          inactiveForegroundColor: Colors.grey,
          iconSize: 23,
          textStyle: const TextStyle(fontSize: 11),
        ),
      ),
      PersistentTabConfig(
        screen: const TodoListPage(),
        item: ItemConfig(
          icon: const Icon(Icons.task_alt),
          title: "Todo",
          activeForegroundColor: AppColors.greenDecorative,
          inactiveForegroundColor: Colors.grey,
          iconSize: 23,
          textStyle: const TextStyle(fontSize: 11),
        ),
      ),
      PersistentTabConfig(
        screen: const ProfilePage(),
        item: ItemConfig(
          icon: const Icon(Icons.person),
          title: "Profile",
          activeForegroundColor: AppColors.greenDecorative,
          inactiveForegroundColor: Colors.grey,
          iconSize: 23,
          textStyle: const TextStyle(fontSize: 11),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: _tabs(),
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        height: 65,
        navBarDecoration: NavBarDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
          color: Colors.white,
        ),
      ),
      navBarOverlap: const NavBarOverlap.none(),
      stateManagement: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
    );
  }
}
