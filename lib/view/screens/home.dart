import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_mode.dart';
import '../../core/providers/bottom_navigation_menu.dart';
import 'bottom_menu/more/more.dart';
import 'bottom_menu/orders/orders.dart';
import 'bottom_menu/routes/routes.dart';
import 'bottom_menu/users/users.dart';

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

    return WillPopScope(
      onWillPop: () async {
        if(ref.read(bottomNavigationMenuProvider) != 0){
          ref.read(bottomNavigationMenuProvider.notifier).state = 0;
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: currentAppMode == AppMode.admins
              ? adminScreens.elementAt(currentBottomMenuItemSelected)
              : technicianScreens.elementAt(currentBottomMenuItemSelected),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 20,
                child: Image.asset('assets/images/bottom_bar_curve.png')),
            BottomNavigationBar(
              // backgroundColor: Colors.red,
              items: currentAppMode == AppMode.admins
                  ? <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Image.asset(
                      currentBottomMenuItemSelected == 0
                          ? 'assets/images/active_routes.png'
                          : 'assets/images/routes.png',
                      height: 28,
                    ),
                    label: 'routes'.tr()),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      currentBottomMenuItemSelected == 1
                          ? 'assets/images/active_orders.png'
                          : 'assets/images/orders.png',
                      height: 28,
                    ),
                    label: 'orders'.tr()),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      currentBottomMenuItemSelected == 2
                          ? 'assets/images/active_users.png'
                          : 'assets/images/users.png',
                      height: 28,
                    ),
                    label: 'users'.tr()),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      currentBottomMenuItemSelected == 3
                          ? 'assets/images/active_more.png'
                          : 'assets/images/more.png',
                      height: 28,
                    ),
                    label: 'more'.tr()),
              ]
                  : <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Image.asset(
                      currentBottomMenuItemSelected == 0
                          ? 'assets/images/active_routes.png'
                          : 'assets/images/routes.png',
                      height: 28,
                    ),
                    label: 'routes'.tr()),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      currentBottomMenuItemSelected == 1
                          ? 'assets/images/active_more.png'
                          : 'assets/images/more.png',
                      height: 28,
                    ),
                    label: 'more'.tr()),
              ],
              currentIndex: currentBottomMenuItemSelected,
              fixedColor: Theme.of(context).primaryColor,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              elevation: 0,
              onTap: (index) {
                ref.read(bottomNavigationMenuProvider.notifier).state = index;
              },
            ),
          ],
        ),
      ),
    );
  }
}
