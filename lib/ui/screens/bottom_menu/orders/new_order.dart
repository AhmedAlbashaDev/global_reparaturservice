import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custsomer_card_new_order.dart';
import '../../../widgets/gradient_background.dart';

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context,) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'new_order'.tr(),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        CustomerCardNewOrder(empty: false,),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          label: 'maintenance_device'.tr(),
                        ),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          label: 'brand'.tr(),
                        ),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          label: 'address'.tr(),
                        ),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          label: 'city'.tr(),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                label: 'zip_code'.tr(),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: CustomTextFormField(
                                label: 'block_no'.tr(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          label: 'additional_info'.tr(),
                        ),
                        SizedBox(height: 10,),
                        CustomButton(onPressed: (){}, text: 'place_an_order'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                        SizedBox(height: 5,),
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
