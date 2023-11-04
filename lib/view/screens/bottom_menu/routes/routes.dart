import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/view_model/routes_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/globals.dart';
import '../../../../core/providers/app_mode.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/route_card.dart';
import '../../search.dart';
import 'new_route.dart';
import '../../../widgets/pagination_footer.dart';

final routesTabsSelectedProvider = StateProvider<int>((ref) => 0);


class RoutesScreen extends ConsumerStatefulWidget {
  const RoutesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends ConsumerState<RoutesScreen> with TickerProviderStateMixin {

  final RefreshController _todayRefreshController = RefreshController(initialRefresh: false);
  final RefreshController _otherRefreshController = RefreshController(initialRefresh: false);

  TabController? tabController;


  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(routesTabsSelectedProvider.notifier).state = 0;
      ref.read(todayRoutesViewModelProvider.notifier).loadAll(today: true);
      ref.read(routesViewModelProvider.notifier).loadAll();
    });

    tabController = TabController(length: 2, vsync: this);


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
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 4),
                    child: DefaultTabController(
                      length: 2,
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
                                      ref.read(routesTabsSelectedProvider.notifier).state = 0;
                                      tabController?.animateTo(0);
                                    },
                                    child: Container(
                                      decoration: ref.watch(routesTabsSelectedProvider) == 0 ?  BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(20)
                                      ) : null,
                                      child: Center(
                                        child: AutoSizeText(
                                          'Today'.tr(),
                                          style: ref.watch(routesTabsSelectedProvider) == 0 ?  const TextStyle(
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
                                      ref.read(routesTabsSelectedProvider.notifier).state = 1;
                                      tabController?.animateTo(1);
                                    },
                                    child: Container(
                                      decoration: ref.watch(routesTabsSelectedProvider) == 1 ?  BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(20)
                                      ) : null,
                                      child: Center(
                                        child: AutoSizeText(
                                          'Others'.tr(),
                                          style: ref.watch(routesTabsSelectedProvider) == 1 ?  const TextStyle(
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
                                ref.watch(todayRoutesViewModelProvider).maybeWhen(
                                  loading: () => const RoutesLoading(),
                                  data: (routes) {

                                    _todayRefreshController.refreshCompleted(resetFooterState: true);

                                    return Column(
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
                                                    const SizedBox(width: 5,),
                                                    Center(
                                                      child: SizedBox(
                                                        width: 35,
                                                        child: MaterialButton(
                                                          padding: EdgeInsets.zero,
                                                          materialTapTargetSize:
                                                          MaterialTapTargetSize.shrinkWrap,
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                PageTransition(
                                                                    type: PageTransitionType.rightToLeft,
                                                                    duration: const Duration(milliseconds: 500),
                                                                    child:  SearchScreen(endPoint: 'roads', title: 'routes'.tr()))).then((value) {
                                                              final snackBar = SnackBar(
                                                                backgroundColor: Theme.of(context).primaryColor,
                                                                showCloseIcon: true,
                                                                behavior: SnackBarBehavior.floating,
                                                                padding: EdgeInsets.zero,
                                                                content: CustomSnakeBarContent(
                                                                  icon: const Icon(
                                                                    Icons.info,
                                                                    color: Colors.green,
                                                                    size: 25,
                                                                  ),
                                                                  message: 'Pull-Down to refresh data'.tr(),
                                                                  bgColor: Colors.grey.shade600,
                                                                  borderColor: Colors.green.shade200,
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
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
                                          ],
                                        ),
                                        Expanded(
                                          child: routes.data.isEmpty
                                              ? const EmptyWidget()
                                              : SmartRefresher(
                                            controller: _todayRefreshController,
                                            enablePullDown: true,
                                            enablePullUp: false,
                                            onRefresh: () async {
                                              ref.read(todayRoutesViewModelProvider.notifier).loadAll();
                                            },
                                            header: const WaterDropHeader(),
                                            footer: const PaginationFooter(),
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
                                                          child: RouteCard(
                                                            routesModel: routes.data[index],
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
                                      ref.read(todayRoutesViewModelProvider.notifier).loadAll();
                                    },
                                  ),
                                  orElse: () => Center(
                                    child: CustomError(
                                      message: 'unknown_error_please_try_again'.tr(),
                                      onRetry: (){
                                        ref.read(todayRoutesViewModelProvider.notifier).loadAll();
                                      },
                                    ),
                                  ),
                                ),

                                ref.watch(routesViewModelProvider).maybeWhen(
                                  loading: () => const RoutesLoading(),
                                  data: (routes) {

                                    _otherRefreshController.refreshCompleted(resetFooterState: true);
                                    _otherRefreshController.loadComplete();

                                    return Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                AutoSizeText.rich(
                                                  TextSpan(text: 'routes'.tr(), children:  [
                                                    TextSpan(
                                                        text: ' (${routes.total})',
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
                                                    const SizedBox(width: 5,),
                                                    Center(
                                                      child: SizedBox(
                                                        width: 35,
                                                        child: MaterialButton(
                                                          padding: EdgeInsets.zero,
                                                          materialTapTargetSize:
                                                          MaterialTapTargetSize.shrinkWrap,
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                PageTransition(
                                                                    type: PageTransitionType.rightToLeft,
                                                                    duration: const Duration(milliseconds: 500),
                                                                    child:  SearchScreen(endPoint: 'roads', title: 'routes'.tr()))).then((value) {
                                                              final snackBar = SnackBar(
                                                                backgroundColor: Theme.of(context).primaryColor,
                                                                showCloseIcon: true,
                                                                behavior: SnackBarBehavior.floating,
                                                                padding: EdgeInsets.zero,
                                                                content: CustomSnakeBarContent(
                                                                  icon: const Icon(
                                                                    Icons.info,
                                                                    color: Colors.green,
                                                                    size: 25,
                                                                  ),
                                                                  message: 'Pull-Down to refresh data'.tr(),
                                                                  bgColor: Colors.grey.shade600,
                                                                  borderColor: Colors.green.shade200,
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
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
                                          ],
                                        ),
                                        Expanded(
                                          child: routes.data.isEmpty
                                              ? const EmptyWidget()
                                              : SmartRefresher(
                                            controller: _otherRefreshController,
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
                                                _otherRefreshController.loadNoData();
                                              }
                                            },
                                            header: const WaterDropHeader(),
                                            footer: const PaginationFooter(),
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
                                                          child: RouteCard(
                                                            routesModel: routes.data[index],
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
                                ),
                              ],
                            ),
                          ),
                        ],
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewRouteScreen())).then((value) {
              print('Added new routes update');
              if(value == 'update'){
                ref
                    .read(routesViewModelProvider.notifier)
                    .loadAll();
              }
            });
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