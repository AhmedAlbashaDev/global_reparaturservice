import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:global_reparaturservice/view_model/forget_email_view_model.dart';
import 'package:lottie/lottie.dart';

import '../../core/globals.dart';
import '../../models/response_state.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snakbar.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/gradient_background.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {


  late TextEditingController email;

  static final GlobalKey<FormState> _forgetPasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(forgetEmailViewModelProvider, (previous, next) {
      next.whenOrNull(
        success: (order) {
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.zero,
            content: CustomSnakeBarContent(
              icon: Icon(Icons.email, color: Theme.of(context).primaryColor , size: 25,),
              message: 'password_sent_to_your_email'.tr(),
              bgColor: Colors.grey.shade600 ,
              borderColor: Theme.of(context).primaryColor,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        error: (error) {

          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.zero,
            content: CustomSnakeBarContent(
              icon: const Icon(Icons.error, color: Colors.red , size: 25,),
              message: error.errorMessage ?? '',
              bgColor: Colors.grey.shade600,
              borderColor: Colors.redAccent.shade200,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: ref.watch(forgetEmailViewModelProvider).maybeWhen(
          loading: () {
            return Stack(
              children: [
                const GradientBackgroundWidget(),
                Column(
                  children: [
                    CustomAppBar(
                      title: 'forget_password'.tr(),
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
          orElse: () {
            return Stack(
              children: [
                const GradientBackgroundWidget(),
                Column(
                  children: [
                    CustomAppBar(
                      title: 'forget_password'.tr(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                          child: Form(
                            key: _forgetPasswordFormKey,
                            child: Column(
                              children: [
                                SizedBox(height: screenHeight * 10,),
                                AutoSizeText(
                                  'forget_email_message'.tr(),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20,),
                                CustomTextFormField(
                                  controller: email,
                                  validator: (String? text) {
                                    if (text?.isEmpty ?? true) {
                                      return 'this_filed_required'.tr();
                                    } else if (!isValidEmail(text: text)) {
                                      return 'please_enter_valid_email'.tr();
                                    }
                                    return null;
                                  },
                                  label: 'email'.tr(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomButton(
                                    onPressed: () {
                                      if(_forgetPasswordFormKey.currentState?.validate() ?? false){
                                        ref.read(forgetEmailViewModelProvider.notifier).forgetPassword(email: email.text);
                                      }
                                    },
                                    text: 'send_new_password'.tr(),
                                    textColor: Colors.white,
                                    bgColor: Theme.of(context).primaryColor),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
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
