import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/globals.dart';
import '../../../../models/response_state.dart';
import '../../../../models/user.dart';
import '../../../../view_model/users/add_new_Admin_view_model.dart';
import '../../../../view_model/users/delete_admin_view_model.dart';
import '../../../../view_model/users/get_users_view_model.dart';
import '../../../../view_model/users/update_Admin_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/loading_dialog.dart';

class AddNewAdminScreen extends ConsumerStatefulWidget {
  const AddNewAdminScreen({this.isUpdate = false, this.userModel , super.key});

  final bool isUpdate;
  final UserModel? userModel;

  @override
  ConsumerState createState() => _State(isUpdate: isUpdate , userModel: userModel);
}

class _State extends ConsumerState<AddNewAdminScreen> {

  _State({required this.isUpdate , this.userModel});

  final bool isUpdate;
  final UserModel? userModel;

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController address;
  late TextEditingController zone;
  late TextEditingController password;
  late TextEditingController additional;

  static final GlobalKey<FormState> _addAdminFormKey =
  GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    additional = TextEditingController();

    if(isUpdate){
      name.text = userModel?.name ?? '';
      email.text = userModel?.email ?? '';
      password.text   =  '';
      additional.text =  '';
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
    additional.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(usersAddNewAdminViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            loading: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const LoadingDialog(),
              );
            },
            data: (user) {
              if (ModalRoute.of(context)?.isCurrent != true) {
                Navigator.pop(context);
              }

              ref
                  .read(usersAdminsViewModelProvider.notifier)
                  .loadAll(endPoint: 'admins');

              Navigator.pop(context);
            },
            error: (error) {
              if (ModalRoute.of(context)?.isCurrent != true) {
                Navigator.pop(context);
              }

              final snackBar = SnackBar(
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.floating,
                content: CustomSnakeBarContent(
                  icon: const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 25,
                  ),
                  message: error.errorMessage ?? '',
                  bgColor: Colors.grey.shade600,
                  borderColor: Colors.redAccent.shade200,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          );
        });

    ref.listen<ResponseState<UserModel>>(usersUpdateAdminViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            loading: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const LoadingDialog(),
              );
            },
            data: (user) {
              if (ModalRoute.of(context)?.isCurrent != true) {
                Navigator.pop(context);
              }

              ref
                  .read(usersCustomersViewModelProvider.notifier)
                  .loadAll(endPoint: 'admins');

              Navigator.pop(context);
            },
            error: (error) {
              if (ModalRoute.of(context)?.isCurrent != true) {
                Navigator.pop(context);
              }

              final snackBar = SnackBar(
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.floating,
                content: CustomSnakeBarContent(
                  icon: const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 25,
                  ),
                  message: error.errorMessage ?? '',
                  bgColor: Colors.grey.shade600,
                  borderColor: Colors.redAccent.shade200,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          );
        });

    ref.listen<ResponseState<UserModel>>(usersDeleteAdminViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            loading: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const LoadingDialog(),
              );
            },
            data: (user) {
              if (ModalRoute.of(context)?.isCurrent != true) {
                Navigator.pop(context);
              }

              ref
                  .read(usersAdminsViewModelProvider.notifier)
                  .loadAll(endPoint: 'admins');

              Navigator.pop(context);
            },
            error: (error) {
              if (ModalRoute.of(context)?.isCurrent != true) {
                Navigator.pop(context);
              }

              final snackBar = SnackBar(
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.floating,
                content: CustomSnakeBarContent(
                  icon: const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 25,
                  ),
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
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'add_new_admin'.tr(),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Form(
                      key: _addAdminFormKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: name,
                            validator: (String? text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'admin_name'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: email,
                            validator: (String? text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              } else if (!isValidEmail(text: text)) {
                                return 'please_enter_valid_email'.tr();
                              }
                              return null;
                            },
                            label: 'email'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: password,
                            validator: (text) {
                              if ((text?.isEmpty ?? true) && !isUpdate) {
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'password'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: additional,
                            validator: (text) {},
                            label: 'additional_info'.tr(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if(isUpdate)
                            Column(
                              children: [
                                CustomButton(
                                    onPressed: () {
                                      if (_addAdminFormKey.currentState
                                          ?.validate() ??
                                          false) {
                                        ref
                                            .read(usersUpdateAdminViewModelProvider.notifier).update(
                                            endPoint: 'admins/${userModel?.id}',
                                            name: name.text,
                                            email: email.text,
                                            password: password.text,
                                            additional: additional.text);
                                      }
                                    },
                                    text: 'update_admin'.tr(),
                                    textColor: Colors.white,
                                    bgColor: Theme.of(context).primaryColor),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => Center(
                                          child: Container(
                                            height: screenHeight * 20,
                                            width: screenWidth * 90,
                                            margin: const EdgeInsets.all(24),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12)
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Material(
                                                  child: AutoSizeText(
                                                    'are_you_sure_you_want_to_delete'.tr(),
                                                    style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    CustomButton(
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                      text: 'no'.tr(),
                                                      textColor: Theme.of(context).primaryColor,
                                                      bgColor: Colors.white,
                                                    ),
                                                    CustomButton(
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                        ref
                                                            .read(usersDeleteAdminViewModelProvider
                                                            .notifier)
                                                            .delete(endPoint: 'admins/${userModel?.id}',);
                                                      },
                                                      text: 'yes'.tr(),
                                                      textColor: Colors.white,
                                                      bgColor: Colors.red,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );

                                    },
                                    text: 'delete_admin'.tr(),
                                    textColor: Colors.white,
                                    bgColor: Colors.red),
                              ],
                            )
                          else
                            CustomButton(
                                onPressed: () {
                                  if (_addAdminFormKey.currentState
                                      ?.validate() ??
                                      false) {
                                    ref
                                        .read(usersAddNewAdminViewModelProvider
                                        .notifier)
                                        .create(
                                        endPoint: 'admins',
                                        name: name.text,
                                        email: email.text,
                                        password: password.text,
                                        additional: additional.text);
                                  }
                                },
                                text: 'add_new_admin'.tr(),
                                textColor: Colors.white,
                                bgColor: Theme.of(context).primaryColor),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
