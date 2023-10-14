import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/routes/route_details_admin.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/routes/route_details_technician.dart';
import 'package:global_reparaturservice/view_model/routes_view_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/globals.dart';
import '../../../../core/providers/app_mode.dart';
import '../../../../core/providers/search_field_status.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/empty_widget.dart';
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

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(routesViewModelProvider.notifier).loadAll();
    });

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
                    child: ref.watch(routesViewModelProvider).maybeWhen(
                      loading: () => const RoutesLoading(),
                      data: (routes) {
                        _refreshController.refreshCompleted(resetFooterState: true);
                        _refreshController.loadComplete();
                        return routes.data.isEmpty
                            ? EmptyWidget(text: ref.read(currentAppModeProvider.notifier).state == AppMode.admins ? 'no_routes'.tr() : 'no_routes_technician'.tr(),)
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText.rich(
                                      TextSpan(text: 'routes'.tr(), children:  [
                                        TextSpan(
                                            text: ' (${routes.data.length})',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500))
                                      ]),
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // DropdownButton<String>(
                                        //   value: 'all'.tr(),
                                        //   onTap: (){},
                                        //   icon: Image.asset(
                                        //     'assets/images/filter.png',
                                        //     height: 18,
                                        //   ),
                                        //   items: <String>['all'.tr(), 'completed'.tr(), 'not_completed'.tr()]
                                        //       .map<DropdownMenuItem<String>>((String value) {
                                        //     return DropdownMenuItem(
                                        //       value: value,
                                        //       onTap: (){},
                                        //       child: AutoSizeText(
                                        //         value,
                                        //         style: const TextStyle(fontSize: 15),
                                        //       ),
                                        //     );
                                        //   }).toList(),
                                        //   onChanged: (value) {
                                        //     print('Value $value');
                                        //   },
                                        //
                                        // ),
                                        const SizedBox(width: 5,),
                                        Center(
                                          child: SizedBox(
                                            width: 35,
                                            child: MaterialButton(
                                              padding: EdgeInsets.zero,
                                              materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                              onPressed: () {
                                                ref
                                                    .read(searchFieldStatusProvider
                                                    .notifier)
                                                    .state = true;
                                                animation.forward();
                                              },
                                              child: Image.asset(
                                                'assets/images/search.png',
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SearchWidget(
                                  fadeInFadeOut: _fadeInFadeOut,
                                  searchController: searchController,
                                  onChanged: (text) {},
                                  onClose: () {
                                    ref.read(searchFieldStatusProvider.notifier).state =
                                    false;
                                    animation.reverse();
                                  },
                                  enabled: ref.watch(searchFieldStatusProvider),
                                )
                              ],
                            ),
                            Expanded(
                              child: SmartRefresher(
                                controller: _refreshController,
                                enablePullDown: true,
                                enablePullUp: true,
                                onRefresh: () async {
                                  ref.read(routesViewModelProvider.notifier).loadAll();
                                },
                                onLoading: () async {
                                  if (routes.to != routes.total) {
                                    ref
                                        .read(routesViewModelProvider.notifier)
                                        .loadMore(
                                        pageNumber: routes.currentPage + 1,
                                        oldList: routes.data);
                                  } else {
                                    _refreshController.loadNoData();
                                  }
                                },
                                header: const WaterDropHeader(),
                                footer: CustomFooter(
                                  builder: (context, mode) {
                                    Widget body;

                                    if (mode == LoadStatus.idle) {
                                      body = Text("pull_up_to_load".tr());
                                    } else if (mode == LoadStatus.loading) {
                                      body = Lottie.asset(
                                          'assets/images/global_loader.json',
                                          height: 50);
                                    } else if (mode == LoadStatus.failed) {
                                      body = Text("load_failed".tr());
                                    } else if (mode == LoadStatus.canLoading) {
                                      body = Text("release_to_load_more".tr());
                                    } else {
                                      body = Text("no_more_data".tr());
                                    }

                                    return SizedBox(
                                      height: 60.0,
                                      child: Center(child: body),
                                    );
                                  },
                                ),
                                child: SingleChildScrollView(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 400),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: MaterialButton(
                                                  onPressed: (){
                                                    if(ref.read(currentAppModeProvider.notifier).state == AppMode.admins){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailsAdmin(routeId: routes.data[index].id)
                                                      ));
                                                    }
                                                    else{
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailsTechnician(routeId: routes.data[index].id)
                                                      ));
                                                    }
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  clipBehavior: Clip.antiAlias,
                                                  elevation: .5,
                                                  color: Colors.white,
                                                  child: Container(
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.white,
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            AutoSizeText(
                                                              routes.data[index].referenceNo,
                                                              style: TextStyle(
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.bold),
                                                            ),
                                                            const SizedBox(height: 8,),
                                                            AutoSizeText(
                                                              routes.data[index].driver?.name ?? 'no_driver_assigned'.tr(),
                                                              style: TextStyle(
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w500),
                                                            ),
                                                            const SizedBox(height: 8,),
                                                            AutoSizeText(
                                                              Jiffy.parse(routes.data[index].createdAt.toString()).format(pattern: 'dd/MM/yyyy'),
                                                              style: TextStyle(
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                        AutoSizeText(
                                                          routes.data[index].statusName,
                                                          style: const TextStyle(
                                                              color: Color(0xFFE2BC37),
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: routes.data.length,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      error: (error) => CustomError(
                        message: error.errorMessage ?? '',
                        onRetry: (){
                          ref.read(routesViewModelProvider.notifier).loadAll();
                        },
                      ),
                      orElse: () => Center(
                        child: CustomError(
                          message: 'unknown_error_please_try_again'.tr(),
                          onRetry: (){
                            ref.read(routesViewModelProvider.notifier).loadAll();
                          },
                        ),
                      ),
                    )
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NewRouteScreen()));
          },
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class RoutesLoading extends StatelessWidget {
  const RoutesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText.rich(
                    TextSpan(text: 'routes'.tr(), children: const [
                      TextSpan(
                          text: ' ( - )',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500))
                    ]),
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
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        onPressed: null,
                        child: Image.asset(
                          'assets/images/search.png',
                          height: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context , index){
              return SizedBox(
                width: screenWidth * 100,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedShimmerContainer(
                              height: 17,
                              width: screenWidth * 60,
                            ),
                            const SizedBox(height: 10,),
                            RoundedShimmerContainer(
                              height: 15,
                              width: screenWidth * 55,
                            ),
                            const SizedBox(height: 10,),
                            RoundedShimmerContainer(
                              height: 15,
                              width: screenWidth * 40,
                            )
                          ],
                        ),
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedShimmerContainer(
                          height: 20,
                          width: 70,
                        ),
                      ],
                    )

                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}