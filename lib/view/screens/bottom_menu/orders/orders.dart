import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/orders/order_details_admin.dart';
import 'package:global_reparaturservice/view/screens/search.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../core/globals.dart';
import '../../../../view_model/orders_view_model.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/order_card.dart';
import '../../../widgets/orders_loading.dart';
import '../../../widgets/pagination_footer.dart';
import 'new_order.dart';


final ordersFilterProvider = StateProvider.autoDispose<String?>((ref) => 'all'.tr());
final ordersTabsSelectedProvider = StateProvider<int>((ref) => 0);


class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> with TickerProviderStateMixin {

  final RefreshController _todayRefreshController = RefreshController(initialRefresh: false);
  final RefreshController _otherRefreshController = RefreshController(initialRefresh: false);

  TabController? tabController;

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);



  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(ordersTabsSelectedProvider.notifier).state = 0;
      ref.read(todayOrdersViewModelProvider.notifier).loadAll(today: true);
      ref.read(ordersViewModelProvider.notifier).loadAll();
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                                    ref.read(ordersTabsSelectedProvider.notifier).state = 0;
                                    tabController?.animateTo(0);
                                  },
                                  child: Container(
                                    decoration: ref.watch(ordersTabsSelectedProvider) == 0 ?  BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(20)
                                    ) : null,
                                    child: Center(
                                      child: AutoSizeText(
                                        'Today'.tr(),
                                        style: ref.watch(ordersTabsSelectedProvider) == 0 ?  const TextStyle(
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
                                    ref.read(ordersTabsSelectedProvider.notifier).state = 1;
                                    tabController?.animateTo(1);
                                  },
                                  child: Container(
                                    decoration: ref.watch(ordersTabsSelectedProvider) == 1 ?  BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(20)
                                    ) : null,
                                    child: Center(
                                      child: AutoSizeText(
                                        'Others'.tr(),
                                        style: ref.watch(ordersTabsSelectedProvider) == 1 ?  const TextStyle(
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
                              ref.watch(todayOrdersViewModelProvider).maybeWhen(
                                loading: () => OrdersLoading(title: 'orders'.tr(),),
                                data: (orders) {
                                  _todayRefreshController.refreshCompleted(resetFooterState: true);

                                  List<OrderModel> todayFilteredList = [];

                                    if(ref.watch(ordersFilterProvider) == 'all'.tr()){
                                      todayFilteredList = orders.data;
                                    }
                                    else if (ref.watch(ordersFilterProvider) == 'Pending'.tr()){
                                      todayFilteredList = orders.data.where((order) => order.status == 1).toList();
                                    }
                                    else if (ref.watch(ordersFilterProvider) == 'On Progress'.tr()){
                                      todayFilteredList = orders.data.where((order) => order.status == 2).toList();
                                    }
                                    else if (ref.watch(ordersFilterProvider) == 'Finished'.tr()){
                                      todayFilteredList = orders.data.where((order) => order.status == 3).toList();
                                    }

                                  return Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              AutoSizeText.rich(
                                                TextSpan(text: 'orders'.tr(), children:  [
                                                  TextSpan(
                                                      text: ' (${orders.data.length})',
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
                                                  DropdownButton<String>(
                                                    value: ref.watch(ordersFilterProvider),
                                                    icon: Image.asset(
                                                      'assets/images/filter.png',
                                                      height: 18,
                                                    ),
                                                    items: <String>['all'.tr(), 'Pending'.tr(), 'On Progress'.tr() , 'Finished'.tr()]
                                                        .map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem(
                                                        value: value,
                                                        child: AutoSizeText(
                                                          value,
                                                          style: const TextStyle(fontSize: 14),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      ref.read(ordersFilterProvider.notifier).state = value;
                                                    },
                                                  ),
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
                                                                  child:  SearchScreen(endPoint: 'orders', title: 'orders'.tr()))).then((value) {
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
                                        child: todayFilteredList.isEmpty
                                            ? EmptyWidget(text: 'no_data'.tr())
                                            : SmartRefresher(
                                          controller: _todayRefreshController,
                                          enablePullDown: true,
                                          enablePullUp: false,
                                          onRefresh: () async {
                                            ref.read(todayOrdersViewModelProvider.notifier).loadAll(today: true);
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
                                                        child: OrderCard(
                                                          orderIndex: index + 1,
                                                          orderModel: todayFilteredList[index],
                                                          onPressed: (){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsAdmin(orderId: todayFilteredList[index].id,)));
                                                          },
                                                          showOrderStatus: true,
                                                          showOrderPaymentStatus: true,
                                                          showOrderCheckBox: false,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: todayFilteredList.length,
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
                                    ref.read(todayOrdersViewModelProvider.notifier).loadAll(today: true);
                                  },
                                ),
                                orElse: () => Center(
                                  child: CustomError(
                                    message: 'Unknown Error Please Try Again',
                                    onRetry: (){
                                      ref.read(todayOrdersViewModelProvider.notifier).loadAll(today: true);
                                    },
                                  ),
                                ),
                              ),

                              ref.watch(ordersViewModelProvider).maybeWhen(
                                loading: () => OrdersLoading(title: 'orders'.tr(),),
                                data: (orders) {
                                  _otherRefreshController.refreshCompleted(resetFooterState: true);
                                  _otherRefreshController.loadComplete();

                                  List<OrderModel> allFilteredList = [];

                                    if(ref.watch(ordersFilterProvider) == 'all'.tr()){
                                      allFilteredList = orders.data;
                                    }
                                    else if (ref.watch(ordersFilterProvider) == 'Pending'.tr()){
                                      allFilteredList = orders.data.where((order) => order.status == 1).toList();
                                    }
                                    else if (ref.watch(ordersFilterProvider) == 'On Progress'.tr()){
                                      allFilteredList = orders.data.where((order) => order.status == 2).toList();
                                    }
                                    else if (ref.watch(ordersFilterProvider) == 'Finished'.tr()){
                                      allFilteredList = orders.data.where((order) => order.status == 3).toList();
                                    }

                                  return Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              AutoSizeText.rich(
                                                TextSpan(text: 'orders'.tr(), children:  [
                                                  TextSpan(
                                                      text: ' (${orders.total})',
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
                                                  DropdownButton<String>(
                                                    value: ref.watch(ordersFilterProvider),
                                                    icon: Image.asset(
                                                      'assets/images/filter.png',
                                                      height: 18,
                                                    ),
                                                    items: <String>['all'.tr(), 'Pending'.tr(), 'On Progress'.tr() , 'Finished'.tr()]
                                                        .map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem(
                                                        value: value,
                                                        child: AutoSizeText(
                                                          value,
                                                          style: const TextStyle(fontSize: 14),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      ref.read(ordersFilterProvider.notifier).state = value;
                                                    },
                                                  ),
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
                                                                  child:  SearchScreen(endPoint: 'orders', title: 'orders'.tr()))).then((value) {
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
                                        child: allFilteredList.isEmpty
                                            ? EmptyWidget(text: 'no_data'.tr())
                                            : SmartRefresher(
                                          controller: _otherRefreshController,
                                          enablePullDown: true,
                                          enablePullUp: true,
                                          onRefresh: () async {
                                            ref.read(ordersViewModelProvider.notifier).loadAll();
                                          },
                                          onLoading: () async {
                                            if (orders.to != orders.total) {
                                              ref
                                                  .read(ordersViewModelProvider.notifier)
                                                  .loadMore(
                                                  pageNumber: orders.currentPage + 1,
                                                  oldList: orders.data);
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
                                                        child: OrderCard(
                                                          orderIndex: index + 1,
                                                          orderModel: allFilteredList[index],
                                                          onPressed: (){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsAdmin(orderId: allFilteredList[index].id,)));
                                                          },
                                                          showOrderStatus: true,
                                                          showOrderPaymentStatus: true,
                                                          showOrderCheckBox: false,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: allFilteredList.length,
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
                                    ref.read(ordersViewModelProvider.notifier).loadAll();
                                  },
                                ),
                                orElse: () => Center(
                                  child: CustomError(
                                    message: 'Unknown Error Please Try Again',
                                    onRetry: (){
                                      ref.read(ordersViewModelProvider.notifier).loadAll();
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
              ))
            ],
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        openCloseDial: isDialOpen,
        icon: Icons.add,
        activeIcon: Icons.close,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.directions_transit),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            label: 'new_order'.tr(),
            onTap: () {
              ref.read(newOrderTypeSelectedProvider.notifier).state = 0;
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewOrderScreen())).then((value) {
                if(value == 'update'){
                  ref
                      .read(ordersViewModelProvider.notifier)
                      .loadAll();
                  ref
                      .read(todayOrdersViewModelProvider.notifier)
                      .loadAll(today: true);
                }
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.directions_transit),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            label: 'Drop-Off Order'.tr(),
            onTap: () {
              ref.read(newOrderTypeSelectedProvider.notifier).state = 1;
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewOrderScreen())).then((value) {
                if(value == 'update'){
                  ref
                      .read(ordersViewModelProvider.notifier)
                      .loadAll();
                  ref
                      .read(todayOrdersViewModelProvider.notifier)
                      .loadAll(today: true);
                }
              });
            },
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
