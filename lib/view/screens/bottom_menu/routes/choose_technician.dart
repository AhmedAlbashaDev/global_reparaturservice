import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:global_reparaturservice/view_model/users/get_users_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/globals.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/pagination_footer.dart';
import '../../search.dart';
import 'new_route.dart';

class ChooseTechnician extends ConsumerStatefulWidget {
  const ChooseTechnician({super.key, required this.driverId});

  final int? driverId;

  @override
  ConsumerState createState() => _ChooseTechnicianState();
}

class _ChooseTechnicianState extends ConsumerState<ChooseTechnician> {

  final RefreshController _refreshControllerTech =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    ref.read(usersTechniciansViewModelProvider.notifier).loadAll(endPoint: 'drivers');
    super.initState();
  }

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
                  title: 'technicians'.tr(),
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(16),
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

                            technicians.data.removeWhere((element) => element.id == widget.driverId);

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
                                                                      (technician.name ?? technician.companyName) ?? '',
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
                                                                          '${technician.email}',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    onPressed: (ref.watch(selectedTechnician) == null) ? null :   () {
                      Navigator.pop(context, true);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ConfirmNewRoute()));
                    },
                    text: 'confirm'.tr(),
                    textColor: Colors.white,
                    bgColor: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
