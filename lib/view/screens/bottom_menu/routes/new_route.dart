import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:global_reparaturservice/view_model/users/get_users_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/globals.dart';
import '../../../../core/providers/selected_orders_new_order_provider.dart';
import '../../../../view_model/orders_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/order_card.dart';
import '../../../widgets/orders_loading.dart';
import '../../../widgets/pagination_footer.dart';
import '../../../widgets/search.dart';
import '../../search.dart';
import 'confirm_new_route.dart';


final selectTechnicianLater = StateProvider.autoDispose<bool?>((ref) => false);
final selectedTechnician = StateProvider.autoDispose<UserModel?>((ref) => null);

class NewRouteScreen extends ConsumerStatefulWidget {
  const NewRouteScreen({super.key});

  @override
  ConsumerState createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends ConsumerState<NewRouteScreen>
    with TickerProviderStateMixin {

  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  late TextEditingController searchController;

  late AnimationController animationTech;
  late Animation<double> _fadeInFadeOutTech;
  late TextEditingController searchControllerTech;

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  final RefreshController _refreshControllerTech =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(selectedOrdersToNewOrder).clear();
      ref.read(ordersViewModelProvider.notifier).loadAll(pendingOrdersOnly: true);
      ref.read(usersTechniciansViewModelProvider.notifier).loadAll(endPoint: 'drivers');
    });

    searchController = TextEditingController();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

    searchControllerTech = TextEditingController();
    animationTech = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeInFadeOutTech = Tween<double>(begin: 0.0, end: 1.0).animate(animationTech);
  }

  @override
  void dispose() {
    animation.dispose();
    searchController.dispose();
    animationTech.dispose();
    searchControllerTech.dispose();
    super.dispose();
  }

  //selected_orders
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: 'new_route'.tr(),
                ),
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ref.watch(ordersViewModelProvider).maybeWhen(
                    loading: () => OrdersLoading(title: 'selected_orders'.tr(),),
                    data: (orders) {

                      _refreshController.refreshCompleted(resetFooterState: true);
                      _refreshController.loadComplete();

                      return orders.data.isEmpty
                          ? EmptyWidget(text: 'no_orders'.tr())
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText.rich(
                                    TextSpan(text: 'selected_orders'.tr(), children:  [
                                      TextSpan(
                                          text: ' (${ref.watch(selectedOrdersToNewOrder).length})',
                                          style: const TextStyle(
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
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.rightToLeft,
                                                  duration: const Duration(milliseconds: 500),
                                                  child:  SearchScreen(endPoint: 'orders', title: 'orders'.tr() , callback: true,)));
                                        },
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
                          Expanded(
                            child: SmartRefresher(
                              controller: _refreshController,
                              enablePullDown: true,
                              enablePullUp: true,
                              onRefresh: () async {
                                ref.read(selectedOrdersToNewOrder).clear();
                                ref.read(ordersViewModelProvider.notifier).loadAll(pendingOrdersOnly: true);

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

                                      final order = orders.data[index];

                                      return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: const Duration(milliseconds: 400),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: OrderCard(
                                              orderModel: order,
                                              onPressed: (){
                                                if(ref.read(selectedOrdersToNewOrder).where((element) => element?.id == order.id).isNotEmpty){
                                                  ref.read(selectedOrdersToNewOrder.notifier).removeOrder(order);
                                                }
                                                else{
                                                  ref.read(selectedOrdersToNewOrder.notifier).addOrder(order);
                                                }
                                              },
                                              showOrderStatus: false,
                                              showOrderPaymentStatus: true,
                                              showOrderCheckBox: true,
                                              selected: ref.watch(selectedOrdersToNewOrder).contains(order),
                                              onChangeCheckbox: (value){
                                                if(ref.read(selectedOrdersToNewOrder).where((element) => element?.id == order.id).isNotEmpty){
                                                  ref.read(selectedOrdersToNewOrder.notifier).removeOrder(order);
                                                }
                                                else{
                                                  ref.read(selectedOrdersToNewOrder.notifier).addOrder(order);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: orders.data.length,
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
                        ref.read(ordersViewModelProvider.notifier).loadAll(pendingOrdersOnly: true);

                      },
                    ),
                    orElse: () => Center(
                      child: CustomError(
                        message: 'Unknown Error Please Try Again',
                        onRetry: (){
                          ref.read(ordersViewModelProvider.notifier).loadAll(pendingOrdersOnly: true);
                        },
                      ),
                    ),
                  )
                )),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        width: screenWidth * 60,
        child: CustomButton(
          onPressed: ref.watch(selectedOrdersToNewOrder).isEmpty ? null : () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                backgroundColor: Colors.white,
                isScrollControlled: true,
                builder: (context) {
                  return Consumer(builder: (context , ref , child){
                    return Container(
                      height: screenHeight * 80,
                      width: screenWidth * 100,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 8,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffD9D9D9)),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Expanded(
                              child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                                  child: ref.watch(usersTechniciansViewModelProvider).maybeWhen(
                                    loading: () => Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: Stack(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AutoSizeText.rich(
                                                    TextSpan(text: 'technicians'.tr(), children: const [
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
                                        ),
                                      ],
                                    ),
                                    data: (technicians) {

                                      _refreshControllerTech.refreshCompleted(resetFooterState: true);
                                      _refreshControllerTech.loadComplete();

                                      return technicians.data.isEmpty
                                          ? EmptyWidget(text: 'no_technicians'.tr())
                                          : Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AutoSizeText.rich(
                                                    TextSpan(text: 'technicians'.tr(), children:  [
                                                      TextSpan(
                                                          text: ' (${technicians.data.length})',
                                                          style: const TextStyle(
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
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  type: PageTransitionType.rightToLeft,
                                                                  duration: const Duration(milliseconds: 500),
                                                                  child:  SearchScreen(endPoint: 'drivers', title: 'technicians'.tr())));
                                                        },
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
                                          Expanded(
                                            child: SmartRefresher(
                                              controller: _refreshControllerTech,
                                              enablePullDown: true,
                                              enablePullUp: true,
                                              onRefresh: () async {
                                                ref.read(usersTechniciansViewModelProvider.notifier).loadAll(endPoint: 'drivers');
                                              },
                                              onLoading: () async {
                                                if (technicians.to != technicians.total) {
                                                  ref
                                                      .read(usersTechniciansViewModelProvider.notifier)
                                                      .loadMore(
                                                      endPoint: 'drivers',
                                                      pageNumber: technicians.currentPage + 1,
                                                      oldList: technicians.data);
                                                } else {
                                                  _refreshControllerTech.loadNoData();
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

                                                      final technician = technicians.data[index];

                                                      return AnimationConfiguration.staggeredList(
                                                        position: index,
                                                        duration: const Duration(milliseconds: 400),
                                                        child: SlideAnimation(
                                                          verticalOffset: 50.0,
                                                          child: FadeInAnimation(
                                                            child: Container(
                                                                margin: const EdgeInsets.all(5),
                                                                child: MaterialButton(
                                                                  onPressed: () {
                                                                    if(ref.watch(selectedTechnician)?.id == technician.id){
                                                                      ref.read(selectedTechnician.notifier).state = null;
                                                                    }
                                                                    else{
                                                                      ref.read(selectTechnicianLater.notifier).state = false;
                                                                      ref.read(selectedTechnician.notifier).state = technician;
                                                                    }
                                                                  },
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
                                                                                technician.name,
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
                                                                                technician
                                                                                    .phone ??
                                                                                    technician.email,
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
                                                                          Transform.scale(
                                                                            scale: 1.3,
                                                                            child: Checkbox(
                                                                              value: ref.watch(selectedTechnician)?.id == technician.id,
                                                                              activeColor: Theme.of(context).primaryColor,
                                                                              onChanged: (value){
                                                                                if(ref.watch(selectedTechnician)?.id == technician.id){
                                                                                  ref.read(selectedTechnician.notifier).state = null;
                                                                                }
                                                                                else{
                                                                                  ref.read(selectTechnicianLater.notifier).state = false;
                                                                                  ref.read(selectedTechnician.notifier).state = technician;
                                                                                }
                                                                              },
                                                                            ),
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
                                                    itemCount: technicians.data.length,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    error: (error) => CustomError(
                                      message: error.errorMessage ?? '',
                                      onRetry: (){
                                        ref.read(usersTechniciansViewModelProvider.notifier).loadAll(endPoint: 'drivers',);
                                      },
                                    ),
                                    orElse: () => Center(
                                      child: CustomError(
                                        message: 'Unknown Error Please Try Again',
                                        onRetry: (){
                                          ref.read(usersTechniciansViewModelProvider.notifier).loadAll(endPoint: 'drivers',);
                                        },
                                      ),
                                    ),
                                  )
                              )),
                          SizedBox(
                            height: 50,
                            child: CheckboxListTile(
                                value: ref.watch(selectTechnicianLater) ?? false,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value){
                                  if(value == true){
                                    ref.read(selectedTechnician.notifier).state = null;
                                  }
                                  ref.read(selectTechnicianLater.notifier).state = value ?? false;
                                },
                                title: AutoSizeText(
                                  'assign_driver_later'.tr(),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                            ),
                          ),
                            const SizedBox(height: 10,),
                          CustomButton(
                            onPressed: (ref.watch(selectTechnicianLater) == false && ref.watch(selectedTechnician) == null) ? null :   () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ConfirmNewRoute()));
                            },
                            text: 'confirm'.tr(),
                            textColor: Colors.white,
                            bgColor: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    );
                  });
                });
          },
          text: 'next'.tr(),
          textColor: Colors.white,
          bgColor: Theme.of(context).primaryColor.withOpacity(.8),
        ),
      ),
    );
  }
}
