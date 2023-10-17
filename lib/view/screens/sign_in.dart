import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/view/screens/forget_password.dart';
import 'package:lottie/lottie.dart';

import '../../core/globals.dart';
import '../../core/providers/app_mode.dart';
import '../../core/providers/bottom_navigation_menu.dart';
import '../../core/providers/user_provider.dart';
import '../../models/response_state.dart';
import '../../models/user.dart';
import '../../view_model/auth_view_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snakbar.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/sign_in_top_view.dart';
import 'home.dart';


final hidePasswordProvider = StateProvider<bool>((ref) => true);


class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {

  late TextEditingController email;
  late TextEditingController password;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => ref.read(bottomNavigationMenuProvider.notifier).state = 0);
    // admin  (admin@admin.com    : 123admin )
    // driver (ahmedmohammedkhier@gmail.com : gDseinWe )
    email = TextEditingController(text: 'admin@admin.com');
    password = TextEditingController(text: '123admin');

  }

  @override
  void dispose() {

    super.dispose();
    email.dispose();
    password.dispose();

  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        // loading: (){
        //   showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (_) => const LoadingDialog(),
        //   );
        // },
        data: (user) {

          // if(ModalRoute.of(context)?.isCurrent != true){
          //   Navigator.pop(context);
          // }

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: email,
                              validator: (text){
                                if(text?.isEmpty ?? true){
                                  return 'this_filed_required'.tr();
                                }
                                else if(!isValidEmail(text: text)){
                                  return 'please_enter_valid_email'.tr();
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'user_email'.tr(),
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

                          const SizedBox(height: 10,),

                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AutoSizeText(
                                'forget_password'.tr(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30,),


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
                                      ref.read(authViewModelProvider.notifier).login(email: email.text, password: password.text);
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
