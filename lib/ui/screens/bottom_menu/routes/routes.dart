import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/providers/app_mode.dart';

import '../../../../providers/search_field_status.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/search.dart';
import 'new_route.dart';

class RoutesScreen extends ConsumerStatefulWidget {
  const RoutesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends ConsumerState<RoutesScreen> with TickerProviderStateMixin {

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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 4),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText.rich(
                                    TextSpan(
                                        text: 'routes'.tr(),
                                        children: const [
                                          TextSpan(
                                              text: ' (3)',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500
                                              )
                                          )
                                        ]
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: 35,
                                      child: MaterialButton(
                                        padding: EdgeInsets.zero,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        onPressed: (){
                                          ref.read(searchFieldStatusProvider.notifier).state = true;
                                          animation.forward();
                                        },
                                        child: Image.asset('assets/images/search.png' , height: 20,),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SearchWidget(
                                fadeInFadeOut: _fadeInFadeOut,
                                searchController: searchController,
                                onChanged: (text){
                                },
                                onClose: (){
                                  ref.read(searchFieldStatusProvider.notifier).state = false;
                                  animation.reverse();
                                },
                                enabled: ref.watch(searchFieldStatusProvider),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context , index){
                              return Container(
                                margin: const EdgeInsets.all(5),
                                child: MaterialButton(
                                  onPressed: (){},
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  elevation: .5,
                                  color: const Color(0xffF7F7F7),
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffF7F7F7),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            AutoSizeText(
                                              'Route Reference',
                                              style: TextStyle(
                                                  color:
                                                  Theme.of(context).primaryColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8,),
                                            AutoSizeText(
                                              'Driver name',
                                              style: TextStyle(
                                                  color:
                                                  Theme.of(context).primaryColor,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        AutoSizeText(
                                          'ongoing'.tr(),
                                          style: TextStyle(
                                              color: Color(0xFFE2BC37),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: 3,
                          ),
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: ref.watch(currentAppModeProvider) == AppMode.admins,
        child: FloatingAddButton(
          onPresses: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewRouteScreen()));
          },
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
