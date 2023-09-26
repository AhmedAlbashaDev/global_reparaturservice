import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/globals.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/gradient_background.dart';
import 'users_customers_tab.dart';
import 'users_technicians_tab.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> with TickerProviderStateMixin {

  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 400),);
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animation.dispose();
    searchController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackgroundWidget(),
          Column(
            children: [
              const CustomMenuScreenAppBar(),
              Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: screenWidth * 75,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              tabs: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Tab(
                                      text: 'customers'.tr(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Tab(
                                      text: 'technicians'.tr(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              UsersCustomersTab(fadeInFadeOut: _fadeInFadeOut, searchController: searchController, onClose: (){}, animation: animation),
                              UsersTechniciansTab(fadeInFadeOut: _fadeInFadeOut, searchController: searchController, onClose: (){}, animation: animation),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingAddButton(
        onPresses: (){},
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
