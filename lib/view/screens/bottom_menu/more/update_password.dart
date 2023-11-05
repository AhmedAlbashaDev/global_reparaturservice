import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/models/response_state.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/user.dart';
import '../../../../view_model/update_password_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/gradient_background.dart';

class UpdatePassword extends ConsumerStatefulWidget {
  const UpdatePassword({super.key});

  @override
  ConsumerState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends ConsumerState<UpdatePassword> {

  late TextEditingController password;
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(updatePasswordViewModelProvider, (previous, next) {
      next.whenOrNull(
        success: (order) {

          password.clear();

          AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'Password'.tr(),
              desc: 'Password Updated'.tr(),
              autoDismiss: false,
              dialogBackgroundColor: Colors.white,
              btnOk: CustomButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                radius: 10,
                text: 'Ok'.tr(),
                textColor: Colors.white,
                bgColor: Theme.of(context).primaryColor,
                height: 40,
              ),
              onDismissCallback: (dismiss) {})
              .show();
        },
        error: (error) {

          AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'Error'.tr(),
              desc: error.errorMessage,
              autoDismiss: false,
              dialogBackgroundColor: Colors.white,
              btnCancel: CustomButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                radius: 10,
                text: 'Ok'.tr(),
                textColor: Colors.white,
                bgColor: const Color(0xffd63d46),
                height: 40,
              ),
              onDismissCallback: (dismiss) {})
              .show();
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: ref.watch(updatePasswordViewModelProvider).maybeWhen(
            loading: () {
              return Stack(
                children: [
                  const GradientBackgroundWidget(),
                  Column(
                    children: [
                      CustomAppBar(
                        title: 'Update Password'.tr(),
                      ),
                      Expanded(
                        child: Center(
                          child: Lottie.asset(
                              'assets/images/global_loader.json',
                              height: 50
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
            orElse: (){
              return Stack(
                children: [
                  const GradientBackgroundWidget(),
                  Column(
                    children: [
                      CustomAppBar(
                        title: 'Update Password'.tr(),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),
                                SizedBox(
                                  height: screenHeight * 30,
                                  child: Form(
                                    key: _passwordFormKey,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AutoSizeText(
                                          'Enter new password'.tr(),
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 7,),
                                        CustomTextFormField(
                                          label: 'New Password'.tr(),
                                          validator: (String? text){
                                            if(text?.isEmpty ?? false){
                                              return 'this_filed_required'.tr();
                                            }
                                            return null;
                                          },
                                          controller: password,
                                          textInputType: TextInputType.text,
                                        ),
                                        const SizedBox(height: 7,),
                                        CustomButton(onPressed: (){
                                          if(_passwordFormKey.currentState?.validate() ?? false){
                                            ref.read(updatePasswordViewModelProvider.notifier).updatePassword(password: password.text);
                                          }
                                        }, text: 'Update', textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                                        const SizedBox(height: 10,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
        )
      ),
    );
  }
}
