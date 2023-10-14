import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/users/add_new_admin.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/users/users_admins_tab.dart';
import 'package:global_reparaturservice/view_model/users/get_users_view_model.dart';

import '../../../../core/providers/user_tab_selected.dart';
import '../../../../core/globals.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/gradient_background.dart';
import 'add_new_customer.dart';
import 'add_new_technician.dart';
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

  TabController? tabController;

  @override
  void initState() {
    super.initState();

    Future.microtask(() => {
      ref.read(userTabsSelectedProvider.notifier).state = 0,

      ref.read(usersAdminsViewModelProvider.notifier).loadAll(endPoint: 'admins'),
      ref.read(usersTechniciansViewModelProvider.notifier).loadAll(endPoint: 'drivers'),
      ref.read(usersCustomersViewModelProvider.notifier).loadAll(endPoint: 'customers'),

    });

    searchController = TextEditingController();
    tabController = TabController(length: 3, vsync: this);
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
              const SizedBox(height: 5,),
              Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          width: screenWidth * 90,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Row(
                            // controller: tabController,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap :(){
                                    ref.read(userTabsSelectedProvider.notifier).state = 0;
                                    tabController?.animateTo(0);
                                  },
                                  child: Container(
                                    decoration: ref.watch(userTabsSelectedProvider) == 0 ?  BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(20)
                                    ) : null,
                                    child: Center(
                                      child: AutoSizeText(
                                        'admins'.tr(),
                                        style: ref.watch(userTabsSelectedProvider) == 0 ? const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ) : const TextStyle(
                                          color: Color(0xFF555B6A),
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap :(){
                                    ref.read(userTabsSelectedProvider.notifier).state = 1;
                                    tabController?.animateTo(1);
                                  },
                                  child: Container(
                                    decoration: ref.watch(userTabsSelectedProvider) == 1 ?  BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(20)
                                    ) : null,
                                    child: Center(
                                      child: AutoSizeText(
                                        'technicians'.tr(),
                                        style:  ref.watch(userTabsSelectedProvider) == 1 ?  const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ) : const TextStyle(
                                            color: Color(0xFF555B6A),
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap :(){
                                    ref.read(userTabsSelectedProvider.notifier).state = 2;
                                    tabController?.animateTo(2);
                                  },
                                  child: Container(
                                    decoration: ref.watch(userTabsSelectedProvider) == 2 ?  BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(20)
                                    ) : null,
                                    child: Center(
                                      child: AutoSizeText(
                                        'customers'.tr(),
                                        style:  ref.watch(userTabsSelectedProvider) == 2 ?  const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ) : const TextStyle(
                                            color: Color(0xFF555B6A),
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: [
                              UsersAdminsTab(fadeInFadeOut: _fadeInFadeOut, searchController: searchController, onClose: (){}, animation: animation),
                              UsersTechniciansTab(fadeInFadeOut: _fadeInFadeOut, searchController: searchController, onClose: (){}, animation: animation),
                              UsersCustomersTab(fadeInFadeOut: _fadeInFadeOut, searchController: searchController, onClose: (){}, animation: animation),
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
        onPresses: (){
          if(tabController?.index == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewAdminScreen()));
          }
          else if(tabController?.index == 1){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewTechnicianScreen()));
          }
          else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewCustomerScreen()));

          }
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}