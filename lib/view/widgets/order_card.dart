import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:jiffy/jiffy.dart';

class OrderCard extends ConsumerWidget {
  const OrderCard({super.key, required this.showOrderStatus, required this.showOrderPaymentStatus, required this.showOrderCheckBox, required this.onPressed, this.orderModel , this.selected = false , this.onChangeCheckbox});

  final bool showOrderStatus;
  final bool showOrderCheckBox;
  final bool selected;
  final bool showOrderPaymentStatus;
  final VoidCallback? onPressed;
  final OrderModel? orderModel;
  final dynamic onChangeCheckbox;
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        elevation: .5,
        color: Colors.white,
        child: Container(
          height: showOrderPaymentStatus ? 115 : 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(
                    '${orderModel?.referenceNo}',
                    style: TextStyle(
                        color:
                        Theme.of(context).primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  AutoSizeText(
                    Jiffy.parse('${orderModel?.createdAt}').format(pattern: 'dd/MM/yyyy'),
                    style: TextStyle(
                        color:
                        Theme.of(context).primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                  Visibility(
                    visible: showOrderPaymentStatus,
                    child: orderModel?.isPaid ?? false ? Container(
                      // height: 50,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(20),
                          color: const Color(0xff21AE38)
                              .withOpacity(.3)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                        child: AutoSizeText(
                          'paid'.tr(),
                          style: const TextStyle(
                              color: Color(0xff21AE38),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ) : Container(
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(20),
                          color: const Color(0xffE2BD38)
                              .withOpacity(.3)),
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                        child: AutoSizeText(
                          'not_paid'.tr(),
                          style: const TextStyle(
                              color: Color(0xffE2BD38),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if(showOrderStatus)
                orderModel?.status == 3 ? AutoSizeText(
                  '${orderModel?.statusName}'.tr(),
                  style: const TextStyle(
                      color: Color(0xff23A26D),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ) : orderModel?.status == 4 ? AutoSizeText(
                  '${orderModel?.statusName}'.tr(),
                  style: const TextStyle(
                      color: Color(0xffD51E1E),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ) : AutoSizeText(
                  '${orderModel?.statusName}'.tr(),
                  style: const TextStyle(
                      color: Color(0xffE2BD38),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              if(showOrderCheckBox)
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    value: selected,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: onChangeCheckbox,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
