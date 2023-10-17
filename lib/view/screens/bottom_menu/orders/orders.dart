import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/orders/order_details_admin.dart';
import 'package:global_reparaturservice/view/screens/search.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/providers/search_field_status.dart';
import '../../../../view_model/orders_view_model.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/order_card.dart';
import '../../../widgets/orders_loading.dart';
import '../../../widgets/pagination_footer.dart';
import '../../../widgets/search.dart';
import 'new_order.dart';


final ordersFilterProvider = StateProvider<String?>((ref) => 'all'.tr());

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(ordersViewModelProvider.notifier).loadAll();
    });
  }

  @override
  void dispose() {
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
                  child: ref.watch(ordersViewModelProvider).maybeWhen(
                      loading: () => OrdersLoading(title: 'orders'.tr(),),
                      data: (orders) {

                        _refreshController.refreshCompleted(resetFooterState: true);
                        _refreshController.loadComplete();

                          List<OrderModel> filteredList = [];

                          if(ref.watch(ordersFilterProvider) == 'all'.tr()){
                            filteredList = orders.data;
                          }
                          else if (ref.watch(ordersFilterProvider) == 'Pending'.tr()){
                            filteredList = orders.data.where((order) => order.statusName == 'Pending').toList();
                          }
                          else if (ref.watch(ordersFilterProvider) == 'On progress'.tr()){
                            filteredList = orders.data.where((order) => order.statusName == 'On progress').toList();
                          }
                          else if (ref.watch(ordersFilterProvider) == 'Finished'.tr()){
                            filteredList = orders.data.where((order) => order.statusName == 'Finished').toList();
                          }
                          else if (ref.watch(ordersFilterProvider) == 'Cancelled'.tr()){
                            filteredList = orders.data.where((order) => order.statusName == 'Cancelled').toList();
                          }

                          if (orders.data.isEmpty) {
                            return EmptyWidget(text: 'no_orders'.tr());
                          } else {
                            return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                          items: <String>['all'.tr(), 'Pending'.tr(), 'On progress'.tr() , 'Finished'.tr() , 'Cancelled'.tr()]
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
                                                        child:  SearchScreen(endPoint: 'orders', title: 'orders'.tr())));
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
                              child: filteredList.isEmpty
                                  ? EmptyWidget(text: 'no_data'.tr())
                                  : SmartRefresher(
                                controller: _refreshController,
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
                                    _refreshController.loadNoData();
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
                                                orderModel: filteredList[index],
                                                onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsAdmin(orderId: filteredList[index].id,)));
                                                },
                                                showOrderStatus: true,
                                                showOrderPaymentStatus: true,
                                                showOrderCheckBox: false,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: filteredList.length,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                          }
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
                  )
              ))
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingAddButton(
        onPresses: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewOrderScreen()));
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
