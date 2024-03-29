import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/globals.dart';
import '../../../../view_model/users/get_users_view_model.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/pagination_footer.dart';
import '../../search.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/gradient_background.dart';
import '../users/add_new_customer.dart';
import 'new_order.dart';

final selectedUserToNewOrder = StateProvider<UserModel?>((ref) => null);

class SelectOrAddCustomerScreen extends ConsumerStatefulWidget {
  const SelectOrAddCustomerScreen({super.key});

  @override
  ConsumerState createState() => _SelectOrAddCustomerScreenState();
}

class _SelectOrAddCustomerScreenState extends ConsumerState<SelectOrAddCustomerScreen> {

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
      Future.microtask(() {
        ref.read(selectedUserToNewOrder.notifier).state = null;
        ref.read(usersCustomersViewModelProvider.notifier).loadAll(endPoint: 'customers?active=true');
      }
    );
  }

  @override
  Widget build(BuildContext context,) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: 'select_customer'.tr(),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 8),
                      child: ref.watch(usersCustomersViewModelProvider).maybeWhen(
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
                                        TextSpan(text: 'customers'.tr(), children: const [
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
                                                  width: screenWidth * 75,
                                                ),
                                                const SizedBox(height: 5,),
                                                RoundedShimmerContainer(
                                                  height: 15,
                                                  width: screenWidth * 70,
                                                ),
                                                const SizedBox(height: 5,),
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
                        data: (usersCustomers) {
                          _refreshController.refreshCompleted(resetFooterState: true);
                          _refreshController.loadComplete();
                          return usersCustomers.data.isEmpty
                              ? EmptyWidget(text: 'no_customers'.tr())
                              : Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        AutoSizeText.rich(
                                          TextSpan(text: 'customers'.tr(), children: [
                                            TextSpan(
                                                text: ' (${usersCustomers.total})',
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
                                                        child:  SearchScreen(endPoint: 'customers', title: 'customers'.tr() , callback: true,active: true,)));
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
                              ),
                              Expanded(
                                child: SmartRefresher(
                                  controller: _refreshController,
                                  enablePullDown: true,
                                  enablePullUp: true,
                                  onRefresh: () async {
                                    ref.read(usersCustomersViewModelProvider.notifier).loadAll(endPoint: 'customers?active=true');
                                  },
                                  onLoading: () async {
                                    if (usersCustomers.to != usersCustomers.total) {
                                      ref
                                          .read(usersCustomersViewModelProvider.notifier)
                                          .loadMore(
                                          endPoint: 'customers',
                                          pageNumber: usersCustomers.currentPage + 1,
                                          oldList: usersCustomers.data);
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
                                                  child: Container(
                                                      margin: const EdgeInsets.all(5),
                                                      child: MaterialButton(
                                                        onPressed: (){
                                                          ref.read(selectedUserToNewOrder.notifier).state = usersCustomers.data[index];
                                                          ref
                                                              .read(selectedAddressToNewOrder.notifier)
                                                              .state = {
                                                            'address' : usersCustomers.data[index].address,
                                                            'lat' : usersCustomers.data[index].lat,
                                                            'lng' : usersCustomers.data[index].lng,
                                                            'postal_code' : usersCustomers.data[index].postalCode,
                                                            'city' : usersCustomers.data[index].city,
                                                            'zone_area' : usersCustomers.data[index].zoneArea,
                                                          };
                                                          Navigator.pop(context);
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
                                                          child: Container(
                                                            height: 90,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.white,
                                                            ),
                                                            child: Center(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    AutoSizeText(
                                                                      (usersCustomers.data[index].name ?? usersCustomers.data[index].companyName) ?? '',
                                                                      style: TextStyle(
                                                                          color: Theme.of(context).primaryColor,
                                                                          fontSize: 15,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        AutoSizeText(
                                                                          usersCustomers.data[index].email ??'',
                                                                          style: TextStyle(
                                                                              color: Theme.of(context).primaryColor,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        const SizedBox(width: 5,),
                                                                        const CircleAvatar(
                                                                          radius: 3,
                                                                          backgroundColor: Colors.grey,
                                                                        ),
                                                                        const SizedBox(width: 5,),
                                                                        AutoSizeText(
                                                                          '${usersCustomers.data[index].phone}',
                                                                          style: TextStyle(
                                                                              color: Theme.of(context).primaryColor,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    AutoSizeText(
                                                                      usersCustomers.data[index].address ?? 'unknown_address'.tr(),
                                                                      style: TextStyle(
                                                                          color: Theme.of(context).primaryColor,
                                                                          fontSize: 10,
                                                                          fontWeight: FontWeight.w500),

                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: usersCustomers.data.length,
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
                            ref.read(usersCustomersViewModelProvider.notifier).loadAll(endPoint: 'customers?active=true');
                          },
                        ),
                        orElse: () => CustomError(
                          message: 'Unknown Error Please Try Again',
                          onRetry: (){
                            ref.read(usersCustomersViewModelProvider.notifier).loadAll(endPoint: 'customers?active=true');
                          },
                        ),
                      ),
                    ),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingAddButton(
        onPresses: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewCustomerScreen())).then((value){
            if(value == 'update'){
              ref.read(usersCustomersViewModelProvider.notifier).loadAll(endPoint: 'customers?active=true');
            }
          });
        },
      )
    );
  }
}