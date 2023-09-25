import 'package:flutter/material.dart';

import '../../widgets/custom_menu_screens_app_bar.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomMenuScreenAppBar(),
          Expanded(
            child: Container(
              // height: 100,
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}