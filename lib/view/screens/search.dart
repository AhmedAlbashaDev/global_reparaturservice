import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/globals.dart';
import '../../core/providers/app_mode.dart';
import '../../models/order.dart';
import '../../models/pagination_model.dart';
import '../../models/routes.dart';
import '../../models/user.dart';
import '../../view_model/searchViewModel.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_shimmer.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/gradient_background.dart';
import '../widgets/order_card.dart';
import '../widgets/pagination_footer.dart';
import 'bottom_menu/routes/route_details_admin.dart';
import 'bottom_menu/routes/route_details_technician.dart';
import 'bottom_menu/routes/routes.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key ,required this.endPoint , required this.title});

  final String endPoint;
  final String title;

  @override
  ConsumerState createState() => _SearchScreenState(endPoint: endPoint , title: title);
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  _SearchScreenState({required this.endPoint , required this.title});

  final String endPoint;
  final String title;

  late TextEditingController searchController;

  final RefreshController _routesRefreshController = RefreshController(initialRefresh: false);
  final RefreshController _ordersRefreshController = RefreshController(initialRefresh: false);
  final RefreshController _usersRefreshController = RefreshController(initialRefresh: false);

  static final GlobalKey<FormState> _searchKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: '${'Search in'.tr()} $title',
                ),
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: _searchKey,
                          child: CustomTextFormField(
                            controller: searchController,
                            validator: (String? text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: '${'Search in'.tr()} $title',
                            searchSuffix: Container(
                              margin: const EdgeInsets.all(10),
                              child: MaterialButton(
                                onPressed: (){
                                  if(searchController.text.isNotEmpty) {
                                    ref.read(searchViewModelProvider.notifier)
                                        .search(endPoint: endPoint, searchText: searchController.text);
                                  }
                                },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero,
                                color: Colors.grey[100],
                                child: AutoSizeText(
                                  'Search'.tr(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        ref.watch(searchViewModelProvider).maybeWhen(
                          idle: () => Center(
                            child: Lottie.asset(
                                'assets/images/search_animation_two.json',
                                width: double.infinity,
                                fit: BoxFit.cover
                            ),
                          ),
                          loading: () {
                            if(endPoint.contains('roads')){
                              return Expanded(
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
                              );
                            }
                            else if(endPoint.contains('orders')){
                              return Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 10,
                                  itemBuilder: (context , index){
                                    return SizedBox(
                                      width: screenWidth * 100,
                                      height: 110,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex:2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                RoundedShimmerContainer(
                                                  height: 15,
                                                  width: screenWidth * 55,
                                                ),
                                                const SizedBox(height: 5,),
                                                RoundedShimmerContainer(
                                                  height: 10,
                                                  width: screenWidth * 40,
                                                ),
                                                const SizedBox(height: 5,),
                                                const RoundedShimmerContainer(
                                                  height: 35,
                                                  width: 80,
                                                  radius: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                RoundedShimmerContainer(
                                                  height: 20,
                                                  width: 80,
                                                ),
                                              ],
                                            ),
                                          )

                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            else {
                              return Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 10,
                                  itemBuilder: (context , index){
                                    return SizedBox(
                                      width: screenWidth * 100,
                                      height: 80,
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
                                                    width: screenWidth * 75,
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  RoundedShimmerContainer(
                                                    height: 15,
                                                    width: screenWidth * 70,
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
                                                width: 20,
                                                shape: BoxShape.circle,
                                              ),
                                            ],
                                          )

                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                          data: (data) {

                            PaginationModel<RoutesModel>? routes;
                            PaginationModel<OrderModel>? orders;
                            PaginationModel<UserModel>? users;

                            if(endPoint.contains('roads')){
                              _routesRefreshController.refreshCompleted(resetFooterState: true);
                              _routesRefreshController.loadComplete();
                              routes = data as PaginationModel<RoutesModel>;
                            }
                            else if(endPoint.contains('orders')){
                              _ordersRefreshController.refreshCompleted(resetFooterState: true);
                              _ordersRefreshController.loadComplete();
                              orders = data as PaginationModel<OrderModel>;
                            }
                            else {
                              _usersRefreshController.refreshCompleted(resetFooterState: true);
                              _usersRefreshController.loadComplete();
                              users = data as PaginationModel<UserModel>;
                            }

                            if(routes != null){
                              return routes.data.isEmpty
                                  ? Center(
                                child: Lottie.asset(
                                    'assets/images/empty_animation.json',
                                    width: double.infinity,
                                    fit: BoxFit.cover
                                ),
                              )
                                  : Expanded(
                                child: SmartRefresher(
                                  controller: _routesRefreshController,
                                  enablePullDown: false,
                                  enablePullUp: true,
                                  onLoading: () async {
                                    if (routes?.to != routes?.total) {
                                      ref.read(searchViewModelProvider.notifier).searchMore(pageNumber: (routes?.currentPage ?? 1) + 1, oldList: routes?.data ?? [] , endPoint: endPoint, searchText: searchController.text);
                                    } else {
                                      _routesRefreshController.loadNoData();
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
                                                  child:  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: MaterialButton(
                                                      onPressed: (){
                                                        if(ref.read(currentAppModeProvider.notifier).state == AppMode.admins){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailsAdmin(routeId: routes?.data[index].id ?? 0)
                                                          ));
                                                        }
                                                        else{
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailsTechnician(routeId: routes?.data[index].id ?? 0)
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
                                                                  '${routes?.data[index].referenceNo}',
                                                                  style: TextStyle(
                                                                      color:
                                                                      Theme.of(context).primaryColor,
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                                const SizedBox(height: 8,),
                                                                AutoSizeText(
                                                                  routes?.data[index].driver?.name ?? 'no_driver_assigned'.tr(),
                                                                  style: TextStyle(
                                                                      color:
                                                                      Theme.of(context).primaryColor,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                                const SizedBox(height: 8,),
                                                                AutoSizeText(
                                                                  Jiffy.parse('${routes?.data[index].createdAt.toString()}').format(pattern: 'dd/MM/yyyy'),
                                                                  style: TextStyle(
                                                                      color:
                                                                      Theme.of(context).primaryColor,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                              ],
                                                            ),
                                                            AutoSizeText(
                                                              '${routes?.data[index].statusName.tr()}',
                                                              style: TextStyle(
                                                                  color: routes?.data[index].status == 3 ? Colors.green : Color(0xFFE2BC37),
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: routes.data.length,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            else if (orders != null){
                              if (orders.data.isEmpty) {
                                return Center(
                                child: Lottie.asset(
                                    'assets/images/empty_animation.json',
                                    width: double.infinity,
                                    fit: BoxFit.cover
                                ),
                              );
                              }
                              else {
                                return Expanded(
                                    child: SmartRefresher(
                                      controller: _ordersRefreshController,
                                      enablePullDown: false,
                                      enablePullUp: true,
                                      onLoading: () async {
                                        if (orders?.to != orders?.total) {
                                          ref.read(searchViewModelProvider.notifier).searchMore(pageNumber: (orders?.currentPage ?? 1) + 1, oldList: orders?.data ?? [] , endPoint: endPoint, searchText: searchController.text);
                                        } else {
                                          _ordersRefreshController.loadNoData();
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
                                                      child: OrderCard(showOrderStatus: true, showOrderPaymentStatus: true, showOrderCheckBox: false, onPressed: (){},orderModel: orders?.data[index],)
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: orders.data.length,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                              }
                            }

                            else {
                              if (users?.data.isEmpty ?? true) {
                                return Center(
                                child: Lottie.asset(
                                    'assets/images/empty_animation.json',
                                    width: double.infinity,
                                    fit: BoxFit.cover
                                ),
                              );
                              } else {
                                return Expanded(
                                  child: SmartRefresher(
                                    controller: _usersRefreshController,
                                    enablePullDown: false,
                                    enablePullUp: true,
                                    onLoading: () async {
                                      if (users?.to != users?.total) {
                                        ref.read(searchViewModelProvider.notifier).searchMore(pageNumber: (users?.currentPage ?? 1) + 1, oldList: users?.data ?? [] , endPoint: endPoint, searchText: searchController.text);

                                      } else {
                                        _usersRefreshController.loadNoData();
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
                                                  child: Container(
                                                      margin: const EdgeInsets.all(5),
                                                      child: MaterialButton(
                                                        onPressed: () {},
                                                        padding: EdgeInsets.zero,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(10)),
                                                        clipBehavior: Clip.antiAlias,
                                                        elevation: .5,
                                                        color: Colors.white,
                                                        child: Container(
                                                          height: 90,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(10),
                                                            color: Colors.white,
                                                          ),
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 16, vertical: 8),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  children: [
                                                                    AutoSizeText(
                                                                      '${users?.data[index].name}',
                                                                      style: TextStyle(
                                                                          color:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                          fontSize: 15,
                                                                          fontWeight:
                                                                          FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    AutoSizeText(
                                                                      '${users?.data[index]
                                                                          .phone ??
                                                                          users?.data[index]
                                                                              .email}',
                                                                      style: TextStyle(
                                                                          color:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                          fontSize: 10,
                                                                          fontWeight:
                                                                          FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: users?.data.length,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }

                          },
                          orElse: () => Center(
                            child: Lottie.asset(
                                'assets/images/empty_animation.json',
                                width: double.infinity,
                                fit: BoxFit.cover
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
