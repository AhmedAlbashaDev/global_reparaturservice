import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/globals.dart';
import '../../../../models/response_state.dart';
import '../../../../models/user.dart';
import '../../../../view_model/users/admins/add_new_Admin_view_model.dart';
import '../../../../view_model/users/admins/delete_admin_view_model.dart';
import '../../../../view_model/users/admins/update_Admin_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/gradient_background.dart';

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
    name.dispose();
    email.dispose();
    password.dispose();
    additional.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(usersAddNewAdminViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            data: (user) {

              Navigator.pop(context , 'update');
            },
            error: (error) {
              if (ModalRoute.of(context)?.isCurrent != true) {
                Navigator.pop(context);
              }

              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error'.tr(),
                  desc: error.errorMessage,
                  autoDismiss: false,
                  dialogBackgroundColor: Colors.white,
                  btnCancel: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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

    ref.listen<ResponseState<UserModel>>(usersUpdateAdminViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            data: (user) {

                  Navigator.pop(context , 'update');
            },
            error: (error) {

              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error'.tr(),
                  desc: error.errorMessage,
                  autoDismiss: false,
                  dialogBackgroundColor: Colors.white,
                  btnCancel: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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

    ref.listen<ResponseState<UserModel>>(usersDeleteAdminViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            data: (user) {

              Navigator.pop(context , 'update');

            },
            error: (error) {

              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error'.tr(),
                  desc: error.errorMessage,
                  autoDismiss: false,
                  dialogBackgroundColor: Colors.white,
                  btnCancel: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
            const GradientBackgroundWidget(),
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(
                    title: isUpdate == false ? 'add_new_admin'.tr() : 'update_admin'.tr(),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Form(
                      key: _addAdminFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            textInputType: TextInputType.emailAddress,
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
                            height: 20,
                          ),
                          // CustomTextFormField(
                          //   controller: additional,
                          //   validator: (text) {},
                          //   label: 'additional_info'.tr(),
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          if(isUpdate)
                            Column(
                              children: [
                                ref.watch(usersUpdateAdminViewModelProvider).maybeWhen(
                                    loading: () => Center(
                                      child: Lottie.asset(
                                          'assets/images/global_loader.json',
                                          height: 50
                                      ),
                                    ),
                                    orElse: (){
                                      return CustomButton(
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
                                          bgColor: Theme.of(context).primaryColor);
                                    }
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ref.watch(usersDeleteAdminViewModelProvider).maybeWhen(
                                    loading: () => Center(
                                      child: Lottie.asset(
                                          'assets/images/global_loader.json',
                                          height: 50
                                      ),
                                    ),
                                    orElse: (){
                                      return CustomButton(
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
                                          bgColor: Colors.red);
                                    }
                                ),
                              ],
                            )
                          else
                            ref.watch(usersAddNewAdminViewModelProvider).maybeWhen(
                                loading: () => Center(
                                  child: Lottie.asset(
                                      'assets/images/global_loader.json',
                                      height: 50
                                  ),
                                ),
                              orElse: (){
                                return CustomButton(
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
                                    bgColor: Theme.of(context).primaryColor);
                              }
                            ),
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
