import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/providers/app_mode.dart';
import 'package:global_reparaturservice/ui/screens/home.dart';
import 'package:global_reparaturservice/ui/widgets/custom_button.dart';
import 'package:global_reparaturservice/utils/globals.dart';

class SignIn extends ConsumerWidget {
  SignIn({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            Container(
              height: screenHeight * 30,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Image.asset('assets/images/logo.png' , height: screenHeight * 20,color: Colors.white,),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 27,
                ),
                Stack(
                  children: [
                    Image.asset('assets/images/white_curve.png'),
                    Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 2,
                        ),
                        Image.asset('assets/images/blue_curve.png'),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 60,
                                child: TextFormField(
                                  controller: email,
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
                                    ref.read(currentAppModeProvider.notifier).state = AppMode.admins;
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
                  ),
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}
