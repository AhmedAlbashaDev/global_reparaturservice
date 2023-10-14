import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';

import 'package:lottie/lottie.dart';

import '../../../../view_model/order_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custsomer_card_new_order.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/gradient_background.dart';

class OrderDetailsAdmin extends ConsumerStatefulWidget {
  const OrderDetailsAdmin({super.key, required this.orderId});

  final int orderId;

  @override
  ConsumerState createState() => _OrderDetailsAdminState(orderId: orderId);
}

class _OrderDetailsAdminState extends ConsumerState<OrderDetailsAdmin> {
  _OrderDetailsAdminState({required this.orderId});

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
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: const Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Visit #',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF555B6A),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      AutoSizeText(
                                        'This is first visit',
                                        style: TextStyle(
                                          color: Color(0xFF555B6A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
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
                                        'Order status',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF555B6A),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      AutoSizeText(
                                        orderModel.statusName,
                                        style: const TextStyle(
                                          color: Color(0xFF555B6A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
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
                                        'Payment status',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF555B6A),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      AutoSizeText(
                                        orderModel.isPaid ? 'paid'.tr() : 'not_paid'.tr(),
                                        style: const TextStyle(
                                          color: Color(0xFF555B6A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
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
                                      AutoSizeText(
                                        'problem_summary'.tr(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF555B6A),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      AutoSizeText(
                                        orderModel.description,
                                        style: const TextStyle(
                                          color: Color(0xFF555B6A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
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
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const AutoSizeText(
                                            'Order phone',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF555B6A),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          AutoSizeText(
                                            '${orderModel.orderPhoneNumber}',
                                            style: const TextStyle(
                                              color: Color(0xFF555B6A),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
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
                                            icon: Icon(Icons.call_rounded),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
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
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const AutoSizeText(
                                        'Uploaded files',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF555B6A),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      orderModel.files?.isEmpty ?? true
                                ? Center(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EmptyWidget(text: 'no_files'.tr() , height: 20,textSize: 14,),
                                ))
                              :  ListView.builder(
                                        itemCount: 3,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context , index){
                                          return Container(
                                              height: 40,
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(color: Colors.grey.shade400)
                                                )
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AutoSizeText(
                                                      'File Name',
                                                      style: TextStyle(
                                                          color: Theme.of(context).primaryColor,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye_rounded , color: Theme.of(context).primaryColor,))
                                                  ],
                                                ),
                                              )
                                          );
                                        },
                                      ),
                                    ],
                                  ),
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
                                  padding: const EdgeInsets.all(12),
                                  child: const Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Order report',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF555B6A),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      AutoSizeText(
                                        'Order report should be here',
                                        style: TextStyle(
                                          color: Color(0xFF555B6A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
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
