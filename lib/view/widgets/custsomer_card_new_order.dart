import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/bottom_menu/orders/select_or_add_customer.dart';
import 'custom_button.dart';

class CustomerCardNewOrder extends StatelessWidget {
  const CustomerCardNewOrder(
      {super.key,
      required this.empty,
      this.userModel,
      this.isOnMap = false,
      this.orderPhone,
      this.isOrderDetails = false});

  final bool empty;
  final bool isOrderDetails;
  final bool isOnMap;
  final String? orderPhone;
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isOnMap ? 100 : 90,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDBDBDB)),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: empty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/user.png',
                      height: 45,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 10,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFDBDBDB).withOpacity(.6)),
                          ),
                          Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFDBDBDB).withOpacity(.6)),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 10,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFDBDBDB)
                                        .withOpacity(.6)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 10,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFDBDBDB)
                                        .withOpacity(.6)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 10,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFDBDBDB)
                                        .withOpacity(.6)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: 50,
                    width: 100,
                    child: CustomButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectOrAddCustomerScreen()));
                        },
                        text: 'select'.tr(),
                        textColor: Colors.white,
                        bgColor: Theme.of(context).primaryColor))
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/user.png',
                      height: 45,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AutoSizeText(
                            userModel?.name ?? '',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            userModel?.phone ?? '',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          ),
                          AutoSizeText(
                            '',// '${userModel.address}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: isOrderDetails
                      ? Center(
                        child: isOnMap == false
                            ? Container(
                          height: 40,
                          width: 90,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: '${userModel?.phone}',
                              );
                              await launchUrl(launchUri);
                            },
                            color: Theme.of(context).primaryColor,
                            icon: const Icon(Icons.call_rounded),
                          ),
                        )
                            :  Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 90,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: '${userModel?.phone}',
                                  );
                                  await launchUrl(launchUri);
                                },
                                  color: Theme.of(context).primaryColor,
                                  icon: const Icon(Icons.call_rounded),
                                ),
                            ),
                            Container(
                              height: 40,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: '${orderPhone}',
                                  );
                                  await launchUrl(launchUri);
                                },
                                color: Theme.of(context).primaryColor,
                                icon: const Icon(Icons.call_rounded),
                              ),
                            ),
                          ],
                        ),
                      )
                      : SizedBox(
                          height: 50,
                          child: CustomButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SelectOrAddCustomerScreen()));
                              },
                              text: 'edit'.tr(),
                              textColor: Colors.white,
                              bgColor: const Color(0xffD51E1E))),
                )
              ],
            ),
    );
  }
}
