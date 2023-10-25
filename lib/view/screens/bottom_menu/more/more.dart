import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/more/update_password.dart';
import 'package:global_reparaturservice/view/widgets/custom_text_form_field.dart';
import 'package:global_reparaturservice/view_model/update_password_view_model.dart';
import '../../../../core/providers/bottom_navigation_menu.dart';
import '../../../../models/response_state.dart';
import '../../../../models/user.dart';
import '../../../../view_model/logout_view_model.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/loading_dialog.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/version_widget.dart';
import '../../sign_in.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(logoutViewModelProvider, (previous, next) {
      next.whenOrNull(
        loading: (){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const LoadingDialog(),
          );
        },
        success: (user) {

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const SignIn()), (Route<dynamic> route) => false);

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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const GradientBackgroundWidget(),
          Column(
            children: [
              const CustomMenuScreenAppBar(),
              SingleChildScrollView(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          ref.context.setLocale(context.locale.languageCode == 'en' ? const Locale('de') : const Locale('en'));
                        },
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        elevation: .5,
                        color: Colors.white,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              leading: Image.asset(
                                'assets/images/translate.png',
                                height: 30,
                              ),
                              title: AutoSizeText(
                                context.locale.languageCode == 'en' ? 'deutsch'.tr() : 'english'.tr(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatePassword()));
                        },
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        elevation: .5,
                        color: Colors.white,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              leading: Icon(Icons.lock , color: Colors.grey.shade700,),
                              title: AutoSizeText(
                                'Update Password'.tr(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        elevation: .5,
                        color: Colors.white,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              leading: Image.asset(
                                'assets/images/about.png',
                                height: 30,
                              ),
                              title: AutoSizeText(
                                'about_app'.tr(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        onPressed: () {
                          ref.read(logoutViewModelProvider.notifier).logout();
                        },
                        text: 'logout'.tr(),
                        textColor: Colors.white,
                        bgColor: Theme.of(context).primaryColor,
                      ),
                      const VersionWidget()
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
