import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/providers/app_mode.dart';
import 'package:global_reparaturservice/providers/bottom_navigation_menu.dart';
import 'package:global_reparaturservice/ui/screens/bottom_menu/more.dart';
import 'package:global_reparaturservice/ui/screens/bottom_menu/orders.dart';
import 'package:global_reparaturservice/ui/screens/bottom_menu/routes.dart';
import 'package:global_reparaturservice/ui/screens/bottom_menu/users.dart';

class Home extends ConsumerWidget {
  Home({super.key});

  final List<Widget> adminScreens = [
    const RoutesScreen(),
    const OrdersScreen(),
    const UsersScreen(),
    const MoreScreen(),
  ];

  final List<Widget> technicianScreens = [
    const RoutesScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBottomMenuItemSelected = ref.watch(bottomNavigationMenuProvider);

    final currentAppMode = ref.watch(currentAppModeProvider);

    return Scaffold(
      body: SafeArea(
          child: currentAppMode == AppMode.admins
              ? adminScreens.elementAt(currentBottomMenuItemSelected)
              : technicianScreens.elementAt(currentBottomMenuItemSelected),
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                  height: 20,
                  child: Image.asset('assets/images/bottom_bar_curve.png')),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBar(
                items: currentAppMode == AppMode.admins
                    ? <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        currentBottomMenuItemSelected == 0
                            ? 'assets/images/active_routes.png'
                            : 'assets/images/routes.png',
                        height: 30,
                      ),
                      label: 'routes'.tr()),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        currentBottomMenuItemSelected == 1
                            ? 'assets/images/active_orders.png'
                            : 'assets/images/orders.png',
                        height: 30,
                      ),
                      label: 'orders'.tr()),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        currentBottomMenuItemSelected == 2
                            ? 'assets/images/active_users.png'
                            : 'assets/images/users.png',
                        height: 30,
                      ),
                      label: 'users'.tr()),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        currentBottomMenuItemSelected == 3
                            ? 'assets/images/active_more.png'
                            : 'assets/images/more.png',
                        height: 30,
                      ),
                      label: 'more'.tr()),
                ]
                    : <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        currentBottomMenuItemSelected == 0
                            ? 'assets/images/active_routes.png'
                            : 'assets/images/routes.png',
                        height: 30,
                      ),
                      label: 'routes'.tr()),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        currentBottomMenuItemSelected == 3
                            ? 'assets/images/active_more.png'
                            : 'assets/images/more.png',
                        height: 30,
                      ),
                      label: 'more'.tr()),
                ],
                currentIndex: currentBottomMenuItemSelected,
                fixedColor: Theme.of(context).primaryColor,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                elevation: 0,
                selectedFontSize: 16,
                onTap: (index) {
                  ref.read(bottomNavigationMenuProvider.notifier).state = index;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
