import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/users/add_new_customer.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/users/add_new_technician.dart';
import 'package:global_reparaturservice/view/widgets/empty_widget.dart';
import 'package:global_reparaturservice/view/widgets/route_card.dart';

import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/globals.dart';
import '../../core/providers/selected_orders_new_order_provider.dart';
import '../../models/order.dart';
import '../../models/pagination_model.dart';
import '../../models/routes.dart';
import '../../models/user.dart';
import '../../view_model/search_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_shimmer.dart';
import '../widgets/custom_snakbar.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/floating_add_button.dart';
import '../widgets/gradient_background.dart';
import '../widgets/order_card.dart';
import '../widgets/pagination_footer.dart';
import 'bottom_menu/orders/order_details_admin.dart';
import 'bottom_menu/orders/select_or_add_customer.dart';
import 'bottom_menu/routes/track_technician.dart';
import 'bottom_menu/users/add_new_admin.dart';

final searchOrdersFilterProvider = StateProvider.autoDispose<String?>((ref) => 'all'.tr());
final searchRoutesFilterProvider = StateProvider.autoDispose<String?>((ref) => 'all'.tr());

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, required this.endPoint, required this.title , this.callback = false});

  final String endPoint;
  final String title;
  final bool callback;

  @override
  ConsumerState createState() =>
      _SearchScreenState(endPoint: endPoint, title: title , callback: callback);
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  _SearchScreenState({required this.endPoint, required this.title , this.callback});

  final String endPoint;
  final String title;
  final bool? callback;


  late TextEditingController searchController;

  final RefreshController _routesRefreshController = RefreshController(initialRefresh: false);
  final RefreshController _ordersRefreshController = RefreshController(initialRefresh: false);
  final RefreshController _usersRefreshController = RefreshController(initialRefresh: false);

  static final GlobalKey<FormState> _searchKey = GlobalKey<FormState>();

  DateTime? fromDate;
  DateTime? toDate;

  PaginationModel<RoutesModel>? routes;
  PaginationModel<OrderModel>? orders;
  PaginationModel<UserModel>? users;

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023, 1),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023, 1),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        toDate = picked;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                          key: _searchKey,//
                          child: CustomTextFormField(
                            controller: searchController,
                            validator: (String? text) {
                              if(endPoint.contains('roads')){
                                if ((text?.isEmpty ?? true) && (ref.watch(searchRoutesFilterProvider) == 'all'.tr())) {
                                  return 'this_filed_required'.tr();
                                }
                              }
                              else if (endPoint.contains('orders')){
                                if ((text?.isEmpty ?? true) && (ref.watch(searchOrdersFilterProvider) == 'all'.tr())) {
                                  return 'this_filed_required'.tr();
                                }
                              }
                              return null;
                            },
                            label: '${'Search in'.tr()} $title',
                            searchSuffix: Container(
                              margin: const EdgeInsets.all(10),
                              child: MaterialButton(
                                onPressed: () {
                                  if (_searchKey.currentState?.validate() ?? false) {
                                    if(endPoint.contains('orders') && ref.watch(searchOrdersFilterProvider.notifier).state == 'Specific Period'.tr()){
                                      if(fromDate != null && toDate != null){
                                        ref
                                            .read(searchViewModelProvider.notifier)
                                            .search(
                                          endPoint: endPoint,
                                          searchText: searchController.text,
                                          dateFrom: Jiffy.parse(fromDate?.toString() ?? '').format(pattern: 'yyyy-MM-dd'),
                                          dateTo: Jiffy.parse(toDate?.toString() ?? '').format(pattern: 'yyyy-MM-dd'),
                                        );
                                      }
                                      else{
                                        final snackBar = SnackBar(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          showCloseIcon: true,
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.zero,
                                          duration: const Duration(milliseconds: 1000),
                                          content: CustomSnakeBarContent(
                                            icon: const Icon(Icons.error, color: Colors.red , size: 25,),
                                            message: 'Select Dates First'.tr(),
                                            bgColor: Colors.grey.shade600,
                                            borderColor: Colors.redAccent.shade200,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    }
                                    else if(endPoint.contains('roads') && ref.watch(searchRoutesFilterProvider.notifier).state == 'Specific Date'.tr()){
                                      if(fromDate != null){
                                        ref
                                            .read(searchViewModelProvider.notifier)
                                            .search(
                                          endPoint: endPoint,
                                          searchText: searchController.text,
                                          dateFrom: Jiffy.parse(fromDate?.toString() ?? '').format(pattern: 'yyyy-MM-dd'),
                                          dateTo: Jiffy.parse(fromDate?.toString() ?? '').format(pattern: 'yyyy-MM-dd'),
                                        );
                                      }
                                      else{
                                        final snackBar = SnackBar(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          showCloseIcon: true,
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.zero,
                                          duration: const Duration(milliseconds: 1000),
                                          content: CustomSnakeBarContent(
                                            icon: const Icon(Icons.error, color: Colors.red , size: 25,),
                                            message: 'Select Dates First'.tr(),
                                            bgColor: Colors.grey.shade600,
                                            borderColor: Colors.redAccent.shade200,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    }
                                    else{
                                      ref
                                      .read(searchViewModelProvider.notifier)
                                          .search(
                                          endPoint: endPoint,
                                          searchText: searchController.text,
                                          withoutRoute: callback ?? false
                                      );
                                    }
                                  }
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero,
                                color: Colors.grey[100],
                                child: AutoSizeText(
                                  'Search'.tr(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if(endPoint.contains('orders') && callback == false)
                          Column(
                            children: [
                              const SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton<String>(
                                  value: ref.watch(searchOrdersFilterProvider),
                                  icon: Image.asset(
                                    'assets/images/filter.png',
                                    height: 15,
                                  ),
                                  isExpanded: true,
                                  items: <String>['all'.tr(), 'Specific Period'.tr()]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: AutoSizeText(
                                        value,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    ref.read(searchOrdersFilterProvider.notifier).state = value;
                                  },
                                ),
                              ),
                              Visibility(
                                visible: ref.watch(searchOrdersFilterProvider.notifier).state == 'Specific Period'.tr(),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: (){
                                            _selectFromDate(context);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:  const Color(0xffDCDCDC))),
                                            padding:  const EdgeInsets.all(6),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  'Orders From'.tr(),
                                                  style:  TextStyle(
                                                    fontSize: 11,
                                                    color: Theme.of(context).primaryColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  fromDate == null ? 'Select From Date'.tr() : Jiffy.parse(fromDate.toString()).format(pattern: 'dd-MM-yyyy'),
                                                  style:  TextStyle(
                                                    color: Theme.of(context).primaryColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: InkWell(
                                          onTap: (){
                                            _selectToDate(context);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:  const Color(0xffDCDCDC))),
                                            padding:  const EdgeInsets.all(6),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  'Orders To'.tr(),
                                                  style:  TextStyle(
                                                    fontSize: 11,
                                                    color: Theme.of(context).primaryColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  toDate == null ? 'Select To Date'.tr() : Jiffy.parse(toDate.toString()).format(pattern: 'dd-MM-yyyy'),
                                                  style:  TextStyle(
                                                    color: Theme.of(context).primaryColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        else if (endPoint.contains('roads') && callback == false)
                          Column(
                            children: [
                              const SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton<String>(
                                  value: ref.watch(searchRoutesFilterProvider),
                                  icon: Image.asset(
                                    'assets/images/filter.png',
                                    height: 15,
                                  ),
                                  isExpanded: true,
                                  items: <String>['all'.tr(), 'Specific Date'.tr()]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: AutoSizeText(
                                        value,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    ref.read(searchRoutesFilterProvider.notifier).state = value;
                                  },
                                ),
                              ),
                              Visibility(
                                visible: ref.watch(searchRoutesFilterProvider.notifier).state == 'Specific Date'.tr(),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: InkWell(
                                    onTap: (){
                                      _selectFromDate(context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color:  const Color(0xffDCDCDC))),
                                      padding:  const EdgeInsets.all(6),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            'Date'.tr(),
                                            style:  TextStyle(
                                              fontSize: 11,
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          AutoSizeText(
                                            fromDate == null ? 'Select Date'.tr() : Jiffy.parse(fromDate.toString()).format(pattern: 'dd-MM-yyyy'),
                                            style:  TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        else
                          const SizedBox(
                          height: 10,
                          ),
                        ref.watch(searchViewModelProvider).maybeWhen(
                              idle: () => Center(
                                child: Lottie.asset(
                                    'assets/images/search_animation_two.json',
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                              ),
                              loading: () {
                                if (endPoint.contains('roads')) {
                                  return Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: screenWidth * 100,
                                          height: 100,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      RoundedShimmerContainer(
                                                        height: 17,
                                                        width: screenWidth * 60,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      RoundedShimmerContainer(
                                                        height: 15,
                                                        width: screenWidth * 55,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      RoundedShimmerContainer(
                                                        height: 15,
                                                        width: screenWidth * 40,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                } else if (endPoint.contains('orders')) {
                                  return Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: screenWidth * 100,
                                          height: 110,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    RoundedShimmerContainer(
                                                      height: 15,
                                                      width: screenWidth * 55,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    RoundedShimmerContainer(
                                                      height: 10,
                                                      width: screenWidth * 40,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                } else {
                                  return Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: screenWidth * 100,
                                          height: 80,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      RoundedShimmerContainer(
                                                        height: 17,
                                                        width: screenWidth * 75,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      RoundedShimmerContainer(
                                                        height: 15,
                                                        width: screenWidth * 70,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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

                                if (endPoint.contains('roads')) {
                                  _routesRefreshController.refreshCompleted(
                                      resetFooterState: true);
                                  _routesRefreshController.loadComplete();
                                  routes = data as PaginationModel<RoutesModel>;
                                } else if (endPoint.contains('orders')) {
                                  _ordersRefreshController.refreshCompleted(
                                      resetFooterState: true);
                                  _ordersRefreshController.loadComplete();
                                  orders = data as PaginationModel<OrderModel>;
                                } else {
                                  _usersRefreshController.refreshCompleted(
                                      resetFooterState: true);
                                  _usersRefreshController.loadComplete();
                                  users = data as PaginationModel<UserModel>;
                                }

                                if (routes != null) {
                                  return routes?.data.isEmpty ?? true
                                      ? Center(
                                          child: Lottie.asset(
                                              'assets/images/empty_animation.json',
                                              width: double.infinity,
                                              fit: BoxFit.cover),
                                        )
                                      : Expanded(
                                          child: SmartRefresher(
                                            controller:
                                                _routesRefreshController,
                                            enablePullDown: false,
                                            enablePullUp: true,
                                            onLoading: () async {
                                              if (routes?.to != routes?.total) {
                                                ref
                                                    .read(
                                                        searchViewModelProvider
                                                            .notifier)
                                                    .searchMore(
                                                        pageNumber:
                                                            (routes?.currentPage ??
                                                                    1) +
                                                                1,
                                                        oldList:
                                                            routes?.data ?? [],
                                                        endPoint: endPoint,
                                                        searchText:
                                                            searchController
                                                                .text);
                                              } else {
                                                _routesRefreshController
                                                    .loadNoData();
                                              }
                                            },
                                            header: const WaterDropHeader(),
                                            footer: const PaginationFooter(),
                                            child: SingleChildScrollView(
                                              child: AnimationLimiter(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return AnimationConfiguration
                                                        .staggeredList(
                                                      position: index,
                                                      duration: const Duration(
                                                          milliseconds: 400),
                                                      child: SlideAnimation(
                                                        verticalOffset: 50.0,
                                                        child: FadeInAnimation(
                                                            child: RouteCard(routesModel: routes?.data[index])
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: routes?.data.length,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                }
                                else if (orders != null) {
                                  if (orders?.data.isEmpty ?? true) {
                                    return Center(
                                      child: Lottie.asset(
                                          'assets/images/empty_animation.json',
                                          width: double.infinity,
                                          fit: BoxFit.cover),
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
                                            ref
                                                .read(searchViewModelProvider
                                                    .notifier)
                                                .searchMore(
                                                    pageNumber:
                                                        (orders?.currentPage ??
                                                                1) +
                                                            1,
                                                    oldList: orders?.data ?? [],
                                                    endPoint: endPoint,
                                                    searchText:
                                                        searchController.text);
                                          } else {
                                            _ordersRefreshController
                                                .loadNoData();
                                          }
                                        },
                                        header: const WaterDropHeader(),
                                        footer: const PaginationFooter(),
                                        child: SingleChildScrollView(
                                          child: AnimationLimiter(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return AnimationConfiguration
                                                    .staggeredList(
                                                  position: index,
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  child: SlideAnimation(
                                                    verticalOffset: 50.0,
                                                    child: FadeInAnimation(
                                                        child: OrderCard(
                                                      showOrderStatus: false,
                                                      showOrderPaymentStatus:
                                                          true,
                                                      showOrderCheckBox: true,
                                                          onPressed: callback ?? false ? null : (){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsAdmin(orderId: orders?.data[index].id ?? 0,)));
                                                          },
                                                          selected: ref.watch(selectedOrdersToNewOrder).contains(orders?.data[index]),
                                                          onChangeCheckbox: (value){
                                                            if(ref.read(selectedOrdersToNewOrder).where((element) => element?.id == orders?.data[index].id).isNotEmpty){
                                                              ref.read(selectedOrdersToNewOrder.notifier).removeOrder(orders?.data[index]);
                                                            }
                                                            else{
                                                              ref.read(selectedOrdersToNewOrder.notifier).addOrder(orders?.data[index]);
                                                            }
                                                          },
                                                      orderModel:
                                                          orders?.data[index],
                                                    )),
                                                  ),
                                                );
                                              },
                                              itemCount: orders?.data.length,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                else {
                                  if (users?.data.isEmpty ?? true) {
                                    return const EmptyWidget(text: '',);
                                  } else {
                                    return Expanded(
                                      child: SmartRefresher(
                                        controller: _usersRefreshController,
                                        enablePullDown: false,
                                        enablePullUp: true,
                                        onLoading: () async {
                                          if (users?.to != users?.total) {
                                            ref.read(searchViewModelProvider.notifier).searchMore(
                                                pageNumber:
                                                    (users?.currentPage ?? 1) +
                                                        1,
                                                oldList: users?.data ?? [],
                                                endPoint: endPoint,
                                                searchText:
                                                    searchController.text);
                                          } else {
                                            _usersRefreshController
                                                .loadNoData();
                                          }
                                        },
                                        header: const WaterDropHeader(),
                                        footer: const PaginationFooter(),
                                        child: SingleChildScrollView(
                                          child: AnimationLimiter(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return AnimationConfiguration
                                                    .staggeredList(
                                                  position: index,
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  child: SlideAnimation(
                                                    verticalOffset: 50.0,
                                                    child: FadeInAnimation(
                                                      child: InkWell(
                                                        onTap: callback == false ? null : (){
                                                          ref.read(selectedUserToNewOrder.notifier).state = users?.data[index];
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: MaterialButton(
                                                              onPressed: null,
                                                              padding:
                                                                  EdgeInsets.zero,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              clipBehavior:
                                                                  Clip.antiAlias,
                                                              elevation: .5,
                                                              color: Colors.white,
                                                              child: Container(
                                                                height: 100,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            8),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        children: [
                                                                          AutoSizeText(
                                                                            '${users?.data[index].name}',
                                                                            style: TextStyle(
                                                                                color: Theme.of(context).primaryColor,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          AutoSizeText(
                                                                            '${users?.data[index].phone}',
                                                                            style: TextStyle(
                                                                                color: Theme.of(context).primaryColor,
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                            10,
                                                                          ),
                                                                          AutoSizeText(
                                                                            '${users?.data[index].email}',
                                                                            style: TextStyle(
                                                                                color: Theme.of(context).primaryColor,
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      if(callback == false)
                                                                        IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (endPoint.contains('admins')) {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => AddNewAdminScreen(
                                                                                          isUpdate: true,
                                                                                          userModel: users?.data[index],
                                                                                        ))).then((value) {
                                                                              if (value ==
                                                                                  'update') {
                                                                                ref.read(searchViewModelProvider.notifier).search(endPoint: endPoint, searchText: searchController.text);
                                                                              }
                                                                            });
                                                                          }
                                                                          else if (endPoint.contains('drivers')) {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => AddNewTechnicianScreen(
                                                                                          isUpdate: true,
                                                                                          userModel: users?.data[index],
                                                                                        ))).then((value) {
                                                                              if (value ==
                                                                                  'update') {
                                                                                ref.read(searchViewModelProvider.notifier).search(endPoint: endPoint, searchText: searchController.text);
                                                                              }
                                                                            });
                                                                          }
                                                                          else {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => AddNewCustomerScreen(
                                                                                          isUpdate: true,
                                                                                          userModel: users?.data[index],
                                                                                        ))).then((value) {
                                                                              if (value ==
                                                                                  'update') {
                                                                                ref.read(searchViewModelProvider.notifier).search(endPoint: endPoint, searchText: searchController.text);
                                                                              }
                                                                            });
                                                                          }
                                                                        },
                                                                        icon: Image
                                                                            .asset(
                                                                          'assets/images/edit.png',
                                                                          height:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
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
                                    fit: BoxFit.cover),
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
      floatingActionButton: Visibility(
        visible: endPoint.contains('drivers') && (users?.data.isNotEmpty ?? false),
        child: SizedBox(
          height: 60,
          child: FloatingAddButton(
            onPresses: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TrackTechnician(techniciansList: users?.data ?? [],)));
            },
            child: Icon(Icons.map , color: Theme.of(context).primaryColor,size: 40,),
          ),
        ),
      ),
    );
  }
}
