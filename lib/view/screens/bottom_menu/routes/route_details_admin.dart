import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/models/routes.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:global_reparaturservice/view_model/route_view_model.dart';
import 'package:global_reparaturservice/view_model/routes_view_model.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/globals.dart';
import '../../../../core/providers/search_field_status.dart';
import '../../../../models/response_state.dart';
import '../../../../view_model/users/get_users_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/order_card.dart';
import '../../../widgets/search.dart';
import '../../search.dart';
import 'new_route.dart';
import '../../../widgets/pagination_footer.dart';


class RouteDetailsAdmin extends ConsumerStatefulWidget {
  const RouteDetailsAdmin({super.key, required this.routeId});

  final int routeId;

  @override
  ConsumerState createState() => _RouteDetailsAdminState(routeId: routeId);
}

class _RouteDetailsAdminState extends ConsumerState<RouteDetailsAdmin> with TickerProviderStateMixin {
  _RouteDetailsAdminState({required this.routeId});

  final int routeId;

  late AnimationController animationTech;
  late Animation<double> _fadeInFadeOutTech;
  late TextEditingController searchControllerTech;


  final RefreshController _refreshControllerTech =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(usersTechniciansViewModelProvider.notifier).loadAll(endPoint: 'drivers');
      ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId);
    });

    searchControllerTech = TextEditingController();
    animationTech = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeInFadeOutTech = Tween<double>(begin: 0.0, end: 1.0).animate(animationTech);
  }

  @override
  void dispose() {
    super.dispose();
    animationTech.dispose();
    searchControllerTech.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<RoutesModel>>(routeViewModelProvider, (previous, next) {
      next.whenOrNull(
        success: (order) {

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

          ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId);
          ref.read(routesViewModelProvider.notifier).loadAll();

        },
        error: (error) {

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.zero,
            content: CustomSnakeBarContent(
              icon: const Icon(Icons.error, color: Colors.red , size: 25,),
              message: error.errorMessage ?? '',
              bgColor: Colors.grey.shade600,
              borderColor: Colors.redAccent.shade200,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: 'route_details'.tr(),
                ),
                ref.watch(routeViewModelProvider).maybeWhen(
                    loading: () => Expanded(
                      child: Center(
                        child: Lottie.asset(
                            'assets/images/global_loader.json',
                            height: 50),
                      ),
                    ),
                  data: (routeDetails) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xffDCDCDC))),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    'route_status'.tr(),
                                    style:  TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  AutoSizeText(
                                    routeDetails.statusName.tr(),
                                    style:  TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AutoSizeText.rich(
                              TextSpan(
                                  text: 'selected_orders_for_this_route'.tr(),
                                  children:  [
                                    TextSpan(
                                        text: ' (${routeDetails.orders?.length})',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500))
                                  ]),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return OrderCard(
                                    orderModel: routeDetails.orders?[index],
                                    onPressed: null,
                                    showOrderStatus: true,
                                    showOrderCheckBox: false,
                                    showOrderPaymentStatus: true
                                );
                              },
                              itemCount: routeDetails.orders?.length,
                            ),

                            const SizedBox(height: 5,),

                            AutoSizeText(
                              'assigned_technician'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 20,),

                            routeDetails.driverId == null
                                ? SizedBox(
                              height: 50,
                              child: CustomButton(
                                onPressed: (){
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
                                                const SizedBox(height: 10,),
                                                CustomButton(
                                                  onPressed: (ref.watch(selectedTechnician) == null) ? null :   () {
                                                    Navigator.pop(context);
                                                    ref.read(routeViewModelProvider.notifier).update(routeId: routeId,description: routeDetails.description, driverId: ref.watch(selectedTechnician)?.id, orders: routeDetails.orders ?? []);
                                                    // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ConfirmNewRoute()));
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
                                text: 'assign_driver'.tr(),
                                textColor: Colors.white,
                                bgColor: Theme.of(context).primaryColor,
                              )
                            )
                                : Container(
                              height: 70,
                              padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFDBDBDB))
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/car.png', height: 30,),
                                      const SizedBox(width: 10,),
                                      AutoSizeText(
                                        '${routeDetails.driver?.name}',
                                        style: TextStyle(
                                            color:
                                            Theme.of(context).primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: IconButton(
                                        onPressed: () {},
                                        color: Theme.of(context).primaryColor,
                                        icon:  const Icon(Icons.call_rounded),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    );
                  },
                  error: (error) => CustomError(
                    message: error.errorMessage ?? '',
                    onRetry: () {
                      ref
                          .read(routeViewModelProvider.notifier)
                          .loadOne(routeId: routeId);
                    },
                  ),
                  orElse: () => Center(
                    child: CustomError(
                      message: 'unknown_error_please_try_again'.tr(),
                      onRetry: () {
                        ref
                            .read(routeViewModelProvider.notifier)
                            .loadOne(routeId: routeId);
                      },
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
