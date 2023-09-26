import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.showOrderStatus, required this.showOrderPaymentStatus, required this.showOrderCheckBox, required this.onPressed,});

  final bool showOrderStatus;
  final bool showOrderCheckBox;
  final bool showOrderPaymentStatus;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        elevation: .5,
        color: const Color(0xffF7F7F7),
        child: Container(
          height: showOrderPaymentStatus ? 115 : 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffF7F7F7),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(
                    'Oven Repair',
                    style: TextStyle(
                        color:
                        Theme.of(context).primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  AutoSizeText(
                    '15/9/2023',
                    style: TextStyle(
                        color:
                        Theme.of(context).primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                  Visibility(
                    visible: showOrderPaymentStatus,
                    child: true ? Container(
                      // height: 50,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(20),
                          color: const Color(0xff21AE38)
                              .withOpacity(.3)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                        child: AutoSizeText(
                          'paid'.tr(),
                          style: TextStyle(
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
                        padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                        child: AutoSizeText(
                          'not_paid'.tr(),
                          style: TextStyle(
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
                true ? AutoSizeText(
                  'completed'.tr(),
                  style: TextStyle(
                      color: Color(0xff23A26D),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ) : AutoSizeText(
                  'not_completed'.tr(),
                  style: TextStyle(
                      color: Color(0xffD51E1E),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              if(showOrderCheckBox)
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    value: true,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value){},
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
