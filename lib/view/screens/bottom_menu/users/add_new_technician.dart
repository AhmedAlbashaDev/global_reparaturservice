import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/globals.dart';
import '../../../../models/response_state.dart';
import '../../../../models/user.dart';
import '../../../../view_model/users/technicains/add_new_technician_view_model.dart';
import '../../../../view_model/users/technicains/delete_technician_view_model.dart';
import '../../../../view_model/users/technicains/update_technician_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/gradient_background.dart';

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
  late TextEditingController phone;
  late TextEditingController password;
  late TextEditingController address;
  late TextEditingController zone;
  late TextEditingController additional;

  static final GlobalKey<FormState> _addTechnicianFormKey =
  GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    name = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
    address = TextEditingController();
    zone = TextEditingController();
    additional = TextEditingController();

    if(isUpdate){
      name.text = userModel?.name ?? '';
      phone.text = userModel?.phone ?? '';
      address.text = userModel?.address ?? '';
      zone.text = userModel?.zoneArea ?? '';
      additional.text =  '';
    }

  }

  @override
  void dispose() {

    name.dispose();
    phone.dispose();
    password.dispose();
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
              // AwesomeDialog(
              //     context: context,
              //     dialogType: DialogType.info,
              //     animType: AnimType.rightSlide,
              //     title: 'Password'.tr(),
              //     desc: 'Account password sent to the technician email'.tr(),
              //     autoDismiss: false,
              //     dialogBackgroundColor: Colors.white,
              //     btnOk: CustomButton(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //         Navigator.pop(context , 'update');
              //       },
              //       radius: 10,
              //       text: 'Ok'.tr(),
              //       textColor: Colors.white,
              //       bgColor: Theme.of(context).primaryColor,
              //       height: 40,
              //     ),
              //     onDismissCallback: (dismiss) {})
              //     .show();
              Navigator.pop(context , 'update');
            },
            error: (error) {

              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
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

    ref.listen<ResponseState<UserModel>>(usersUpdateTechnicianViewModelProvider,
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

    ref.listen<ResponseState<UserModel>>(usersDeleteTechnicianViewModelProvider,
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
                            height: 15,
                          ),
                          CustomTextFormField(
                            controller: phone,
                            textInputType: TextInputType.phone,
                            readOnly: isUpdate,
                            maxLength: 12,
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
                            height: 15,
                          ),
                          CustomTextFormField(
                            controller: password,
                            validator: (text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'password'.tr(),
                          ),
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
                                              phoneNo: phone.text,
                                              password: password.text,
                                              address: '',
                                              zoneArea: '',
                                              additional: '');
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
