import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/user.dart';

import '../../view_model/users/get_users_view_model.dart';
import '../screens/bottom_menu/users/add_new_customer.dart';

class CustomerCard extends ConsumerWidget {
  const CustomerCard({super.key , this.userModel ,required this.onPressed});

  final UserModel? userModel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        margin: const EdgeInsets.all(5),
        child: MaterialButton(
          onPressed: (){},
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          clipBehavior: Clip.antiAlias,
          elevation: .5,
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AutoSizeText(
                            (userModel!.name ?? userModel!.companyName) ?? '',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5,),
                          AutoSizeText(
                            '${userModel!.phone}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5,),
                          if(userModel!.email?.isNotEmpty ?? false)
                          Column(
                            children: [
                              AutoSizeText(
                                userModel!.email ?? '',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5,),
                            ],
                          ),
                          if((userModel!.address?.isNotEmpty ?? false) || (userModel!.city?.isNotEmpty ?? false) || (userModel!.postalCode != null))
                          Column(
                            children: [
                              AutoSizeText(
                                '${userModel?.address ?? ''} - ${userModel?.city ?? ''} - ${userModel?.postalCode ?? ''}',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5,),
                            ],
                          ),
                          if(userModel?.isDisabled !=  null)
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: userModel!.isDisabled ?? false ? Colors.red : Colors.green,
                              ),
                              const SizedBox(width: 10,),
                              AutoSizeText(
                                userModel!.isDisabled ?? false ? 'Disabled'.tr() : 'Active'.tr(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onPressed,
                      icon: Image.asset('assets/images/edit.png' , height: 20,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
