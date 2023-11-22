import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/providers/user_provider.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:global_reparaturservice/view/screens/home.dart';
import 'package:global_reparaturservice/view_model/splash_view_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import '../../core/globals.dart';
import '../../core/providers/app_locale.dart';
import '../../core/providers/app_mode.dart';
import '../../models/response_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snakbar.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/version_widget.dart';
import 'onboarding.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(splashViewModelProvider.notifier).checkAndGetLocalUser().then((language) {
        ref.read(currentAppLocaleProvider.notifier).state = language == 'de' ? AppLocale.de : AppLocale.en;
        ref.context.setLocale(Locale(language));
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    Jiffy.setLocale('en');

    ref.listen<ResponseState<UserModel>>(splashViewModelProvider, (previous, next) {
      next.whenOrNull(
        loading: (){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const LoadingDialog(),
          );
        },
        data: (user){

          ref.read(userProvider.notifier).state = user;

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

          if(user.role == 'admin'){
            ref.read(currentAppModeProvider.notifier).state = AppMode.admins;
          }
          else {
            ref.read(currentAppModeProvider.notifier).state = AppMode.technician;
          }

          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoarding()));

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));

        },
        success: (order) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoarding()));

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
              desc: 'unable_to_load_local_user_make_please_sign_in_again'.tr(),
              autoDismiss: false,
              dialogBackgroundColor: Colors.white,
              btnCancel: CustomButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoarding()));

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
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/titled_logo.png',
                fit: BoxFit.contain,
                height: screenHeight * 11,
              ),
            ),
            SizedBox(
              width: screenWidth * 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Lottie.asset(
                        'assets/images/global_loader.json',
                        height: 50
                    ),
                    const VersionWidget(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
