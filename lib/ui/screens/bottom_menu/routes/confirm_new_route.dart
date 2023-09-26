import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:global_reparaturservice/ui/widgets/custom_button.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/order_card.dart';

class ConfirmNewRoute extends StatelessWidget {
  const ConfirmNewRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'confirm_new_route'.tr(),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        AutoSizeText.rich(
                          TextSpan(
                              text: 'selected_orders_for_this_route'.tr(),
                              children: const [
                                TextSpan(
                                    text: ' (3)',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500))
                              ]),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return OrderCard(
                                onPressed: null,
                                showOrderStatus: false,
                                showOrderCheckBox: false,
                                showOrderPaymentStatus: true
                            );
                          },
                          itemCount: 3,
                        ),

                        SizedBox(height: 5,),

                        AutoSizeText(
                          'assigned_technician'.tr(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),

                        SizedBox(height: 10,),

                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xFFDBDBDB))
                          ),
                          clipBehavior: Clip.antiAlias,
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
                            ],
                          ),
                        ),

                        SizedBox(height: 20,),

                        CustomButton(
                          onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          text: 'place_route'.tr(),
                          textColor: Colors.white,
                          bgColor: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
