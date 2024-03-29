import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/users/add_new_admin.dart';
import 'package:global_reparaturservice/view_model/users/get_users_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/pagination_footer.dart';
import '../../search.dart';
class UsersAdminsTab extends ConsumerStatefulWidget {
  const UsersAdminsTab({super.key});

  @override
  ConsumerState createState() => _UsersAdminsTabState();
}

class _UsersAdminsTabState extends ConsumerState<UsersAdminsTab> {
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    Future.microtask(() => {
      ref.read(usersAdminsViewModelProvider.notifier).loadAll(endPoint: 'admins'),

    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final adminsWatcher = ref.watch(usersAdminsViewModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: adminsWatcher.maybeWhen(
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
                        TextSpan(text: 'admins'.tr(), children: const [
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
        data: (usersAdmins) {
          _refreshController.refreshCompleted(resetFooterState: true);
          _refreshController.loadComplete();
          return usersAdmins.data.isEmpty
              ? EmptyWidget(text: 'no_admins'.tr())
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
                          TextSpan(text: 'admins'.tr(), children: [
                            TextSpan(
                                text: ' (${usersAdmins.total})',
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
                                        child:  SearchScreen(endPoint: 'admins', title: 'admins'.tr()))).then((value)
                                {
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
                        )
                      ],
                    ),],
                ),
              ),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () async {
                    ref.read(usersAdminsViewModelProvider.notifier).loadAll(endPoint: 'admins');
                  },
                  onLoading: () async {
                    if (usersAdmins.to != usersAdmins.total) {
                      ref
                          .read(usersAdminsViewModelProvider.notifier)
                          .loadMore(
                          endPoint: 'admins',
                          pageNumber: usersAdmins.currentPage + 1,
                          oldList: usersAdmins.data);
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
                                                    (usersAdmins.data[index].name ?? usersAdmins.data[index].companyName) ?? '',
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
                                                    usersAdmins.data[index]
                                                        .phone ??
                                                        '${usersAdmins
                                                            .data[index]
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
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewAdminScreen(
                                                    isUpdate: true,
                                                    userModel: usersAdmins.data[index],
                                                  ))).then((value) {
                                                    print('Added new Admin update');
                                                    if(value == 'update'){
                                                      ref
                                                          .read(usersAdminsViewModelProvider.notifier)
                                                          .loadAll(endPoint: 'admins');
                                                    }
                                                  });
                                                },
                                                icon: Image.asset(
                                                  'assets/images/edit.png',
                                                  height: 20,
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
                        itemCount: usersAdmins.data.length,
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
            ref.read(usersAdminsViewModelProvider.notifier).loadAll(endPoint: 'admins');
          },
        ),
        orElse: () => Center(
          child: CustomError(
            message: 'Unknown Error Please Try Again',
            onRetry: (){
              ref.read(usersAdminsViewModelProvider.notifier).loadAll(endPoint: 'admins');
            },
          ),
        ),
      ),
    );
  }
}
