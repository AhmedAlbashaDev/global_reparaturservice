import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaginationFooter extends StatelessWidget {
  const PaginationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (context, mode) {
        Widget body;

        if (mode == LoadStatus.idle) {
          body = Text("pull_up_to_load".tr());
        } else if (mode == LoadStatus.loading) {
          body = Lottie.asset(
              'assets/images/global_loader.json',
              height: 50);
        } else if (mode == LoadStatus.failed) {
          body = Text("load_failed".tr());
        } else if (mode == LoadStatus.canLoading) {
          body = Text("release_to_load_more".tr());
        } else {
          body = Text("no_more_data".tr());
        }

        return SizedBox(
          height: 60.0,
          child: Center(child: body),
        );
      },
    );
  }
}
