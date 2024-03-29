import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../core/globals.dart';
import '../../core/providers/app_mode.dart';
import '../../core/providers/bottom_navigation_menu.dart';
import '../../core/providers/user_provider.dart';
import '../../models/response_state.dart';
import '../../models/user.dart';
import '../../view_model/auth_view_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/sign_in_top_view.dart';
import 'home.dart';

final hidePasswordProvider = StateProvider<bool>((ref) => true);

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {

  late TextEditingController userId;
  late TextEditingController password;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => ref.read(bottomNavigationMenuProvider.notifier).state = 0);

    // userId = TextEditingController(text: '111111111111');
    // password = TextEditingController(text: '123ahmed');

    // userId = TextEditingController(text: 'admin@admin.com');
    // password = TextEditingController(text: '123admin');

    userId = TextEditingController();
    password = TextEditingController();

    //sahlowle@gmail.com
    //q6eXUJrN

  }

  @override
  void dispose() {
    userId.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {

          if(user.role == 'admin'){
            ref.read(currentAppModeProvider.notifier).state = AppMode.admins;
          }
          else {
            ref.read(currentAppModeProvider.notifier).state = AppMode.technician;
          }

          ref.read(userProvider.notifier).state = user;

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));

        },
        error: (error) {

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SignInTopView(),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'sign_in'.tr(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20,),
                    Form(
                      key: _loginFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: userId,
                              validator: (text){
                                if(text?.isEmpty ?? true){
                                  return 'this_filed_required'.tr();
                                }
                                else if(isNumeric(text)){
                                  if(text!.length != 12){
                                    return 'Phone must be 12 number minimum'.tr();
                                  }
                                }
                                else if(!isValidEmail(text: text) && !isNumeric(text)){
                                  return 'please_enter_valid_email'.tr();
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'user_Id'.tr(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15,),

                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: password,
                              obscureText: ref.watch(hidePasswordProvider),
                              validator: (text){
                                if(text?.isEmpty ?? true){
                                  return 'this_filed_required'.tr();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'password'.tr(),
                                suffixIcon: IconButton(onPressed: (){
                                  ref.read(hidePasswordProvider.notifier).state = !ref.read(hidePasswordProvider);
                                }, icon: Icon(
                                    ref.watch(hidePasswordProvider)
                                        ? Icons.lock
                                        : Icons.lock_open
                                ),),
                              ),
                            ),
                          ),

                          // const SizedBox(height: 10,),
                          //
                          // InkWell(
                          //   onTap: (){
                          //     Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()));
                          //   },
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(5.0),
                          //     child: AutoSizeText(
                          //       'forget_password'.tr(),
                          //       style: TextStyle(
                          //           color: Theme.of(context).primaryColor,
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.bold
                          //       ),
                          //       textAlign: TextAlign.start,
                          //     ),
                          //   ),
                          // ),

                          const SizedBox(height: 20,),


                          ref.watch(authViewModelProvider).maybeWhen(
                            loading: () => Center(
                              child: Lottie.asset(
                                  'assets/images/global_loader.json',
                                  height: 50
                              ),
                            ),
                            orElse: (){
                              return  CustomButton(
                                  onPressed: (){
                                    if(_loginFormKey.currentState?.validate() ?? false){
                                      if(!isNumeric(userId.text)){
                                        ref.read(authViewModelProvider.notifier).loginAdmin(email: userId.text, password: password.text);
                                      }
                                      else{
                                        ref.read(authViewModelProvider.notifier).loginTechnician(phone: userId.text, password: password.text);
                                      }
                                    }
                                  },
                                  text: 'sign_in'.tr(),
                                  bgColor: Theme.of(context).primaryColor,
                                  textColor: Colors.white);
                            }
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
