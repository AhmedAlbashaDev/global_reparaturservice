import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/routes/track_technician.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/users/add_new_admin.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/users/users_admins_tab.dart';
import 'package:global_reparaturservice/view_model/users/get_users_view_model.dart';

import '../../../../core/globals.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/gradient_background.dart';
import 'add_new_customer.dart';
import 'add_new_technician.dart';
import 'users_customers_tab.dart';
import 'users_technicians_tab.dart';

final userTabsSelectedProvider = StateProvider<int>((ref) => 0);

class UsersScreen extends ConsumerStatefulWidget {
   const UsersScreen({super.key});

  @override
  ConsumerState createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> with TickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    super.initState();

    Future.microtask(() => {
      ref.read(userTabsSelectedProvider.notifier).state = 0,
    });

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
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
                          padding:  const EdgeInsets.symmetric(
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
                                        style: ref.watch(userTabsSelectedProvider) == 0 ?  const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ) :  TextStyle(
                                          color: Theme.of(context).primaryColor,
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
                                        style:  ref.watch(userTabsSelectedProvider) == 1 ?   const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ) :  TextStyle(
                                            color: Theme.of(context).primaryColor,
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
                                        style:  ref.watch(userTabsSelectedProvider) == 2 ?   const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ) :  TextStyle(
                                            color: Theme.of(context).primaryColor,
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
                            physics:  const NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: [
                              UsersAdminsTab(),
                              UsersTechniciansTab(),
                              UsersCustomersTab(),
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
      floatingActionButton: tabController?.index == 1
          ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 50,
            child: FloatingAddButton(
              onPresses: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => TrackTechnician(techniciansList: ref.watch(usersTechniciansViewModelProvider.notifier).users ?? [],)));
              },
              child: Icon(Icons.map , color: Theme.of(context).primaryColor,size: 30,),
            ),
          ),
          const SizedBox(height: 10,),
          FloatingAddButton(
            onPresses: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AddNewTechnicianScreen())).then((value) {
                  print('Added new Tech update');
                  if(value == 'update'){
                    ref
                        .read(usersTechniciansViewModelProvider.notifier)
                        .loadAll(endPoint: 'drivers');
                  }
                });
            },
          ),
        ],
      )
          : FloatingAddButton(
        onPresses: (){
          if(tabController?.index == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AddNewAdminScreen())).then((value) {
              print('Added new Admin update');
              if(value == 'update'){
                ref
                    .read(usersAdminsViewModelProvider.notifier)
                    .loadAll(endPoint: 'admins');
              }
            });
          }
          else if(tabController?.index == 1){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AddNewTechnicianScreen())).then((value) {
              print('Added new Tech update');
              if(value == 'update'){
                ref
                    .read(usersTechniciansViewModelProvider.notifier)
                    .loadAll(endPoint: 'drivers');
              }
            });
          }
          else {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AddNewCustomerScreen(outSide: true,))).then((value) {
              print('Added new Cus update');
              if(value == 'update'){
                ref
                    .read(usersCustomersViewModelProvider.notifier)
                    .loadAll(endPoint: 'customers');
              }
            });

          }
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
