import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/globals.dart';
import '../../core/providers/user_provider.dart';

class CustomMenuScreenAppBar extends ConsumerWidget {
  const CustomMenuScreenAppBar({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {

    final user = ref.read(userProvider);

    return SizedBox(
      width: screenWidth * 100,
      // height: 90,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'welcome'.tr(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    AutoSizeText(
                      '${user?.name}',
                      style:  TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Image.asset('assets/images/logo.png' , height: 40,)
              ],
            ),
          ),
          const SizedBox(height: 5,),
          Image.asset('assets/images/bottom_bar_curve.png' ,)
        ],
      ),
    );
  }
}
