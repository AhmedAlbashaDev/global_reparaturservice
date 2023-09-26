import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/ui/widgets/custom_button.dart';
import 'package:global_reparaturservice/ui/widgets/order_card.dart';
import 'package:global_reparaturservice/utils/globals.dart';

import '../../../../providers/search_field_status.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/search.dart';
import 'confirm_new_route.dart';

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

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animation.dispose();
    searchController.dispose();
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
                  title: 'new_route'.tr(),
                ),
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 50,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText.rich(
                                  TextSpan(
                                      text: 'selected_orders'.tr(),
                                      children: const [
                                        TextSpan(
                                            text: ' (10)',
                                            style: TextStyle(
                                                fontSize: 14,
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
                                            .read(searchFieldStatusProvider
                                                .notifier)
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
                              fadeInFadeOut: _fadeInFadeOut,
                              searchController: searchController,
                              onChanged: (text) {},
                              onClose: () {
                                ref
                                    .read(searchFieldStatusProvider.notifier)
                                    .state = false;
                                animation.reverse();
                              },
                              enabled: ref.watch(searchFieldStatusProvider),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return OrderCard(
                                onPressed: (){},
                                showOrderStatus: false,
                                showOrderPaymentStatus: true,
                                showOrderCheckBox: true,
                            );
                          },
                          itemCount: 10,
                        ),
                      )
                    ],
                  ),
                ))
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
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                backgroundColor: Colors.white,
                isScrollControlled: true,
                builder: (context) {
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
                                color: Color(0xffD9D9D9)),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        AutoSizeText(
                          'select_technician'.tr(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(5),
                                child: MaterialButton(
                                  onPressed: () {},
                                  padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xFFDBDBDB)),
                                      borderRadius: BorderRadius.circular(10)),
                                  clipBehavior: Clip.antiAlias,
                                  elevation: .5,
                                  color: const Color(0xffF7F7F7),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/images/car.png', height: 30,),
                                          SizedBox(width: 10,),
                                          AutoSizeText(
                                            'Technician name',
                                            style: TextStyle(
                                                color:
                                                Theme.of(context).primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Transform.scale(
                                        scale: 1.3,
                                        child: Checkbox(
                                          value: index == 0 ? true : false,
                                          activeColor: Theme.of(context).primaryColor,
                                          onChanged: (value){},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: 3,
                          ),
                        ),
                        CustomButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmNewRoute()));
                          },
                          text: 'confirm'.tr(),
                          textColor: Colors.white,
                          bgColor: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  );
                });
          },
          text: 'Next',
          textColor: Colors.white,
          bgColor: Theme.of(context).primaryColor.withOpacity(.7),
        ),
      ),
    );
  }
}
