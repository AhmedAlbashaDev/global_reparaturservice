import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/globals.dart';
import '../../../../models/response_state.dart';
import '../../../../models/user.dart';
import '../../../../view_model/users/technicains/add_new_technician_view_model.dart';
import '../../../../view_model/users/technicains/delete_technician_view_model.dart';
import '../../../../view_model/users/get_users_view_model.dart';
import '../../../../view_model/users/technicains/update_technician_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/loading_dialog.dart';

class AddNewTechnicianScreen extends ConsumerStatefulWidget {
  const AddNewTechnicianScreen({this.isUpdate = false, this.userModel , super.key});

  final bool isUpdate;
  final UserModel? userModel;

  @override
  ConsumerState createState() => _State(isUpdate: isUpdate , userModel: userModel);
}

class _State extends ConsumerState<AddNewTechnicianScreen> {

  _State({required this.isUpdate , this.userModel});

  final bool isUpdate;
  final UserModel? userModel;

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController address;
  late TextEditingController zone;
  late TextEditingController additional;

  static final GlobalKey<FormState> _addTechnicianFormKey =
  GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    name = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    address = TextEditingController();
    zone = TextEditingController();
    additional = TextEditingController();

    if(isUpdate){
      name.text = userModel?.name ?? '';
      email.text = userModel?.email ?? '';
      phone.text = userModel?.phone ?? '';
      address.text = userModel?.address ?? '';
      zone.text = userModel?.zoneArea ?? '';
      additional.text =  '';
    }

  }

  @override
  void dispose() {

    name.dispose();
    email.dispose();
    phone.dispose();
    address.dispose();
    zone.dispose();
    additional.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(usersAddNewTechnicianViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            data: (user) {

              // final snackBar = SnackBar(
              //   backgroundColor: Colors.transparent,
              //   behavior: SnackBarBehavior.floating,
              //   padding: EdgeInsets.zero,
              //   content: CustomSnakeBarContent(
              //     icon: Icon(
              //       Icons.info,
              //       color: Theme.of(context).primaryColor,
              //       size: 25,
              //     ),
              //     message: 'Successfully created'.tr(),
              //     bgColor: Colors.grey.shade400,
              //     borderColor: Colors.green,
              //   ),
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Navigator.pop(context , 'update');
            },
            error: (error) {

              final snackBar = SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                showCloseIcon: true,
                behavior: SnackBarBehavior.floating,
                padding: EdgeInsets.zero,
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

    ref.listen<ResponseState<UserModel>>(usersUpdateTechnicianViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            data: (user) {

              // final snackBar = SnackBar(
              //   backgroundColor: Colors.transparent,
              //   behavior: SnackBarBehavior.floating,
              //   padding: EdgeInsets.zero,
              //   content: CustomSnakeBarContent(
              //     icon: Icon(
              //       Icons.info,
              //       color: Theme.of(context).primaryColor,
              //       size: 25,
              //     ),
              //     message: 'Successfully update'.tr(),
              //     bgColor: Colors.grey.shade400,
              //     borderColor: Colors.green,
              //   ),
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Navigator.pop(context , 'update');
            },
            error: (error) {

              final snackBar = SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                showCloseIcon: true,
                behavior: SnackBarBehavior.floating,
                padding: EdgeInsets.zero,
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

    ref.listen<ResponseState<UserModel>>(usersDeleteTechnicianViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            data: (user) {

              // final snackBar = SnackBar(
              //   backgroundColor: Colors.transparent,
              //   behavior: SnackBarBehavior.floating,
              //   padding: EdgeInsets.zero,
              //   content: CustomSnakeBarContent(
              //     icon: Icon(
              //       Icons.info,
              //       color: Theme.of(context).primaryColor,
              //       size: 25,
              //     ),
              //     message: 'Successfully deleted'.tr(),
              //     bgColor: Colors.grey.shade400,
              //     borderColor: Colors.green,
              //   ),
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Navigator.pop(context , 'update');
            },
            error: (error) {

              final snackBar = SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                showCloseIcon: true,
                behavior: SnackBarBehavior.floating,
                padding: EdgeInsets.zero,
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
                    title: isUpdate == false ? 'add_new_technician'.tr() : 'update_technician',
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Form(
                      key: _addTechnicianFormKey,
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
                            label: 'technician_name'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: email,
                            height: 85,
                            validator: (String? text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              } else if (!isValidEmail(text: text)) {
                                return 'please_enter_valid_email'.tr();
                              }
                              return null;
                            },
                            hint: 'please_enter_real_email_you_will_get_password_in_it'.tr(),
                            label: 'email'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: phone,
                            textInputType: TextInputType.phone,
                            readOnly: isUpdate,
                            maxLength: 12,
                            height: 60,
                            validator: (String? text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              }
                              else if (text != null && text.length < 12) {
                                return 'Phone must be 12 number minimum'.tr();
                              }
                              return null;
                            },
                            label: 'phone_no'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: address,
                            validator: (text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'address'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: zone,
                            validator: (text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'zone_area'.tr(),
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // CustomTextFormField(
                          //   controller: additional,
                          //   validator: (text) {},
                          //   label: 'additional_info'.tr(),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          if(isUpdate)
                            Column(
                              children: [
                                ref.watch(usersUpdateTechnicianViewModelProvider).maybeWhen(
                                    loading: () => Center(
                                      child: Lottie.asset(
                                          'assets/images/global_loader.json',
                                          height: 50
                                      ),
                                    ),
                                    orElse: (){
                                      return CustomButton(
                                          onPressed: () {
                                            if (_addTechnicianFormKey.currentState
                                                ?.validate() ??
                                                false) {
                                              ref
                                                  .read(usersUpdateTechnicianViewModelProvider
                                                  .notifier)
                                                  .update(
                                                  endPoint: 'drivers/${userModel?.id}',
                                                  name: name.text,
                                                  email: email.text,
                                                  phone: phone.text,
                                                  address: address.text,
                                                  zoneArea: zone.text,
                                                  additional: additional.text);
                                            }
                                          },
                                          text: 'update_technician'.tr(),
                                          textColor: Colors.white,
                                          bgColor: Theme.of(context).primaryColor);
                                    }
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ref.watch(usersDeleteTechnicianViewModelProvider).maybeWhen(
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
                                                                  .read(usersDeleteTechnicianViewModelProvider
                                                                  .notifier)
                                                                  .delete(endPoint: 'drivers/${userModel?.id}',);
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
                                          text: 'delete_technician'.tr(),
                                          textColor: Colors.white,
                                          bgColor: Colors.red);
                                    }
                                ),
                              ],
                            )
                          else
                            ref.watch(usersAddNewTechnicianViewModelProvider).maybeWhen(
                                loading: () => Center(
                                  child: Lottie.asset(
                                      'assets/images/global_loader.json',
                                      height: 50
                                  ),
                                ),
                                orElse: (){
                                  return CustomButton(
                                      onPressed: () {
                                        if (_addTechnicianFormKey.currentState
                                            ?.validate() ??
                                            false) {
                                          ref
                                              .read(usersAddNewTechnicianViewModelProvider
                                              .notifier)
                                              .create(
                                              endPoint: 'drivers',
                                              name: name.text,
                                              email: email.text,
                                              phoneNo: phone.text,
                                              address: address.text,
                                              zoneArea: zone.text,
                                              additional: additional.text);
                                        }
                                      },
                                      text: 'add_new_technician'.tr(),
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
