import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_mode.dart';
import '../widgets/custom_button.dart';
import '../widgets/sign_in_top_view.dart';
import 'home.dart';

class SignIn extends ConsumerWidget {
  SignIn({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  static GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SignInTopView(),

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
                              onChanged: (text){
                                print('Text is : $text');
                              },
                              decoration: InputDecoration(
                                labelText: 'User Email',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                    borderSide: BorderSide(color: Colors.grey.shade300 , width: 1.5)

                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1.5)
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15,),

                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: password,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye_rounded, color: Colors.grey.shade300,)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                    borderSide: BorderSide(color: Colors.grey.shade300 , width: 1.5)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1.5)
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10,),

                          InkWell(
                            onTap: (){},
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

                          CustomButton(
                              onPressed: (){
                                if(email.text == 'driver'){
                                  ref.read(currentAppModeProvider.notifier).state = AppMode.technician;
                                }
                                else {
                                  ref.read(currentAppModeProvider.notifier).state = AppMode.admins;
                                }
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                              },
                              text: 'sign_in'.tr(),
                              bgColor: Theme.of(context).primaryColor,
                              textColor: Colors.white)
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
