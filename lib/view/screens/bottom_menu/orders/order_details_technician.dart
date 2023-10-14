import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:global_reparaturservice/view/widgets/custom_text_form_field.dart';
import 'package:lottie/lottie.dart';

import '../../../../view_model/order_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custsomer_card_new_order.dart';
import '../../../widgets/gradient_background.dart';

class OrderDetailsTechnician extends ConsumerStatefulWidget {
  const OrderDetailsTechnician({super.key, required this.orderId});

  final int orderId;

  @override
  ConsumerState createState() => _OrderDetailsTechnicianState(orderId: orderId);
}

class _OrderDetailsTechnicianState
    extends ConsumerState<OrderDetailsTechnician> {
  _OrderDetailsTechnicianState({required this.orderId});

  final int orderId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        ref.read(orderViewModelProvider.notifier).loadOne(orderId: orderId));
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
                  title: 'order_details'.tr(),
                ),
                ref.watch(orderViewModelProvider).maybeWhen(
                      loading: () => Expanded(
                        child: Center(
                          child: Lottie.asset(
                              'assets/images/global_loader.json',
                              height: 50),
                        ),
                      ),
                      data: (orderModel) {
                        return Expanded(
                          child: SizedBox(
                            width: screenWidth * 95,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                    Center(
                                      child: AutoSizeText(
                                        orderModel.isVisit ? 'This Is Second Visit' : 'This Is First Visit',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
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
                                          const AutoSizeText(
                                            'Order location',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF555B6A),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          AutoSizeText(
                                            orderModel.address,
                                            style: const TextStyle(
                                              color: Color(0xFF555B6A),
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
                                    CustomerCardNewOrder(
                                      userModel: orderModel.customer,
                                      isOrderDetails: true,
                                      empty: false,
                                    ),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.cloud_upload_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 30,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              AutoSizeText(
                                                'Upload Image',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.add_box_rounded,
                                              color:
                                                  Theme.of(context).primaryColor,
                                              size: 30,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ListView.builder(
                                      itemCount: 2,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context , index){
                                        return Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          margin: const EdgeInsets.all(1),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              AutoSizeText(
                                                'Image Name',
                                                style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye_rounded , color: Theme.of(context).primaryColor,)),
                                                  IconButton(onPressed: (){}, icon: Icon(Icons.close_rounded , color: Theme.of(context).primaryColor,)),
                                                ],
                                              )
                                            ],
                                          )
                                        );
                                      },
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color: const Color(0xffDCDCDC))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.cloud_upload_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 30,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              AutoSizeText(
                                                'Upload Video',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.add_box_rounded,
                                              color:
                                                  Theme.of(context).primaryColor,
                                              size: 30,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ListView.builder(
                                      itemCount: 1,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context , index){
                                        return Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            margin: const EdgeInsets.all(1),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                AutoSizeText(
                                                  'Video Name',
                                                  style: TextStyle(
                                                      color: Theme.of(context).primaryColor,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye_rounded , color: Theme.of(context).primaryColor,)),
                                                    IconButton(onPressed: (){}, icon: Icon(Icons.close_rounded , color: Theme.of(context).primaryColor,)),
                                                  ],
                                                )
                                              ],
                                            )
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      label: 'Order Report',
                                      textInputType: TextInputType.multiline,
                                      height: 100,
                                      validator: (text) {},
                                    ),
                                    const SizedBox(height: 20,),
                                    CustomButton(
                                      onPressed: (){},
                                      text: orderModel.isPaid ? 'Finish Order' : 'Pay & Finish Order',
                                      textColor: Colors.white,
                                      bgColor: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      error: (error) => CustomError(
                        message: error.errorMessage ?? '',
                        onRetry: () {
                          ref
                              .read(orderViewModelProvider.notifier)
                              .loadOne(orderId: orderId);
                        },
                      ),
                      orElse: () => Center(
                        child: CustomError(
                          message: 'unknown_error_please_try_again'.tr(),
                          onRetry: () {
                            ref
                                .read(orderViewModelProvider.notifier)
                                .loadOne(orderId: orderId);
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
