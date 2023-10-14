import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/globals.dart';
import '../../../../models/response_state.dart';
import '../../../../models/user.dart';
import '../../../../view_model/users/add_new_technician_view_model.dart';
import '../../../../view_model/users/delete_technician_view_model.dart';
import '../../../../view_model/users/get_users_view_model.dart';
import '../../../../view_model/users/update_technician_view_model.dart';
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
  late TextEditingController password;
  late TextEditingController additional;

  static final GlobalKey<FormState> _addTechnicianFormKey =
  GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    address = TextEditingController();
    zone = TextEditingController();
    password = TextEditingController();
    additional = TextEditingController();

    if(isUpdate){
      name.text = userModel?.name ?? '';
      email.text = userModel?.email ?? '';
      phone.text = userModel?.phone ?? '';
      address.text = userModel?.address ?? '';
      zone.text = userModel?.zoneArea ?? '';
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
    phone.dispose();
    address.dispose();
    zone.dispose();
    password.dispose();
    additional.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(usersAddNewTechnicianViewModelProvider,
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
                  .read(usersTechniciansViewModelProvider.notifier)
                  .loadAll(endPoint: 'drivers');

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

    ref.listen<ResponseState<UserModel>>(usersUpdateTechnicianViewModelProvider,
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
                  .loadAll(endPoint: 'drivers');

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

    ref.listen<ResponseState<UserModel>>(usersDeleteTechnicianViewModelProvider,
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
                  .read(usersTechniciansViewModelProvider.notifier)
                  .loadAll(endPoint: 'drivers');

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
                    title: 'add_new_technician'.tr(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Form(
                      key: _addTechnicianFormKey,
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
                            controller: phone,
                            textInputType: TextInputType.phone,
                            readOnly: isUpdate,
                            validator: (String? text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              }
                              else if ((text?.length ?? 0) < 9) {
                                return 'phone_number_length_required'.tr();
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
                                            password: password.text,
                                            address: address.text,
                                            zoneArea: zone.text,
                                            additional: additional.text);
                                      }
                                    },
                                    text: 'update_technician'.tr(),
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
                                    bgColor: Colors.red),
                              ],
                            )
                          else
                            CustomButton(
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
                                        password: password.text,
                                        phoneNo: phone.text,
                                        address: address.text,
                                        zoneArea: zone.text,
                                        additional: additional.text);
                                  }
                                },
                                text: 'add_new_technician'.tr(),
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
