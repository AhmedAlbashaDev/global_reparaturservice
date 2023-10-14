import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/globals.dart';
import '../../../../core/providers/search_field_status.dart';
import '../../../../view_model/users/get_users_view_model.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/search.dart';
import 'add_new_customer.dart';

class UsersCustomersTab extends ConsumerWidget {
  UsersCustomersTab({super.key, required this.fadeInFadeOut, required this.searchController, required this.onClose, this.onChanged, required this.animation});

  final AnimationController animation;
  final Animation<double> fadeInFadeOut;
  final TextEditingController searchController;
  final VoidCallback onClose;
  final dynamic onChanged;

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 4),
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
                  SearchWidget(
                    fadeInFadeOut: fadeInFadeOut,
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
                                text: ' (${usersCustomers.data.length})',
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
                                ref
                                    .read(searchFieldStatusProvider.notifier)
                                    .state = true;
                                animation.forward();
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
                    SearchWidget(
                      fadeInFadeOut: fadeInFadeOut,
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
              ),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () async {
                    ref.read(usersCustomersViewModelProvider.notifier).loadAll(endPoint: 'customers');
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
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: MaterialButton(
                                      onPressed: (){},
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
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      AutoSizeText(
                                                        usersCustomers.data[index].name,
                                                        style: TextStyle(
                                                            color: Theme.of(context).primaryColor,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      Row(
                                                        children: [
                                                          AutoSizeText(
                                                            usersCustomers.data[index].email,
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
                                                          usersCustomers.data[index].address ?? 'Unknown Address',
                                                        style: TextStyle(
                                                            color: Theme.of(context).primaryColor,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    onPressed: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewCustomerScreen(
                                                        isUpdate: true,
                                                        userModel: usersCustomers.data[index],
                                                      )));
                                                    },
                                                    icon: Image.asset('assets/images/edit.png' , height: 20,),
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
            ref.read(usersCustomersViewModelProvider.notifier).loadAll(endPoint: 'customers');
          },
        ),
        orElse: () => CustomError(
          message: 'Unknown Error Please Try Again',
          onRetry: (){
            ref.read(usersCustomersViewModelProvider.notifier).loadAll(endPoint: 'customers');
          },
        ),
      ),
    );
  }
}

/*

* */
