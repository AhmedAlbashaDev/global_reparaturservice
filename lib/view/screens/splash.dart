import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/providers/user_provider.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:global_reparaturservice/view/screens/home.dart';
import 'package:global_reparaturservice/view_model/splash_view_model.dart';
import 'package:lottie/lottie.dart';
import '../../core/globals.dart';
import '../../core/providers/app_mode.dart';
import '../../models/response_state.dart';
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
      ref.read(splashViewModelProvider.notifier).checkAndGetLocalUser();
    });
  }

  @override
  Widget build(BuildContext context) {

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

          final snackBar = SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            showCloseIcon: true,
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.zero,
            content: CustomSnakeBarContent(
              icon: const Icon(Icons.error, color: Colors.red , size: 25,),
              message: 'unable_to_load_local_user_make_please_sign_in_again'.tr(),
              bgColor: Colors.grey.shade600,
              borderColor: Colors.redAccent.shade200,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoarding()));
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
