import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/gradient_background.dart';

class AddNewTechnicianScreen extends StatelessWidget {
  const AddNewTechnicianScreen({super.key});

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
                    title: 'add_new_technician'.tr(),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          label: 'technician_name'.tr(),
                        ),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          label: 'phone_no'.tr(),
                        ),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          label: 'additional_info'.tr(),
                        ),
                        SizedBox(height: 40,),
                        CustomButton(onPressed: (){}, text: 'add_new_technician'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
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
