import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/../../core/providers/bottom_navigation_menu.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/version_widget.dart';
import '../../sign_in.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackgroundWidget(),
          Column(
            children: [
              const CustomMenuScreenAppBar(),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                              onPressed: () {
                                ref.context.setLocale(context.locale.languageCode == 'en' ? Locale('de') : Locale('en'));
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
                            SizedBox(
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
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          CustomButton(
                            onPressed: () {
                              ref.read(bottomNavigationMenuProvider.notifier).state = 0;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                            },
                            text: 'logout'.tr(),
                            textColor: Colors.white,
                            bgColor: Theme.of(context).primaryColor,
                          ),
                          VersionWidget()
                        ],
                      ),
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
