import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/view_model/users/customers/add_new_cutomer_view_model.dart';
import 'package:global_reparaturservice/view_model/users/customers/update_customer_view_model.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/globals.dart';
import '../../../../models/response_state.dart';
import '../../../../models/user.dart';
import '../../../../view_model/users/customers/delete_customer_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/loading_dialog.dart';

class AddNewCustomerScreen extends ConsumerStatefulWidget {
  const AddNewCustomerScreen({this.isUpdate = false, this.userModel , super.key});

  final bool isUpdate;
  final UserModel? userModel;

  @override
  ConsumerState createState() => _State(isUpdate: isUpdate , userModel: userModel);
}

class _State extends ConsumerState<AddNewCustomerScreen> {

  _State({required this.isUpdate , this.userModel});

  final bool isUpdate;
  final UserModel? userModel;

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController address;
  late TextEditingController postalCode;
  late TextEditingController city;
  late TextEditingController zone;
  late TextEditingController additional;

  static final GlobalKey<FormState> _addCustomerFormKey =
      GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    name = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    address = TextEditingController();
    postalCode = TextEditingController();
    city = TextEditingController();
    zone = TextEditingController();
    additional = TextEditingController();

    if(isUpdate){
      name.text = userModel?.name ?? '';
      email.text = userModel?.email ?? '';
      phone.text = userModel?.phone ?? '';
      address.text = userModel?.address ?? '';
      postalCode.text = userModel?.postalCode ?? '';
      city.text = userModel?.city ?? '';
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
    postalCode.dispose();
    city.dispose();
    zone.dispose();
    additional.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<UserModel>>(usersAddNewCustomerViewModelProvider,
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

    ref.listen<ResponseState<UserModel>>(usersUpdateCustomerViewModelProvider,
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

    ref.listen<ResponseState<UserModel>>(usersDeleteCustomerViewModelProvider,
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
                    title: isUpdate == false ? 'add_new_customer'.tr() : 'update_customer',

                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Form(
                      key: _addCustomerFormKey,
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
                            label: 'customer_name'.tr(),
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
                            maxLength: 12,
                            height: 60,
                            readOnly: isUpdate,
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
                            validator: (String? text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'address'.tr(),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: postalCode,
                                  validator: (text) {
                                    if(text?.isEmpty ?? true){
                                      return 'this_filed_required'.tr();
                                    }
                                    return null;
                                  },
                                  textInputType: TextInputType.number,
                                  label: 'Postal Code'.tr(),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: city,
                                  validator: (text) {
                                    return null;
                                  },
                                  label: 'City'.tr(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          CustomTextFormField(
                            controller: zone,
                            validator: (String? text) {
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
                          //   validator: (String? text) {},
                          //   label: 'additional_info'.tr(),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          if(isUpdate)
                            Column(
                              children: [
                                ref.watch(usersUpdateCustomerViewModelProvider).maybeWhen(
                                    loading: () => Center(
                                      child: Lottie.asset(
                                          'assets/images/global_loader.json',
                                          height: 50
                                      ),
                                    ),
                                    orElse: (){
                                      return CustomButton(
                                          onPressed: () {
                                            if (_addCustomerFormKey.currentState
                                                ?.validate() ??
                                                false) {
                                              ref
                                                  .read(usersUpdateCustomerViewModelProvider
                                                  .notifier)
                                                  .update(
                                                  endPoint: 'customers/${userModel?.id}',
                                                  name: name.text,
                                                  email: email.text,
                                                  phone: phone.text,
                                                  address: address.text,
                                                  zoneArea: zone.text,
                                                  additional: additional.text);
                                            }
                                          },
                                          text: 'update_customer'.tr(),
                                          textColor: Colors.white,
                                          bgColor: Theme.of(context).primaryColor);
                                    }
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ref.watch(usersDeleteCustomerViewModelProvider).maybeWhen(
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
                                                                  .read(usersDeleteCustomerViewModelProvider
                                                                  .notifier)
                                                                  .delete(endPoint: 'customers/${userModel?.id}',);
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
                                          text: 'delete_customer'.tr(),
                                          textColor: Colors.white,
                                          bgColor: Colors.red);
                                    }
                                ),
                              ],
                            )
                          else
                            ref.watch(usersAddNewCustomerViewModelProvider).maybeWhen(
                                loading: () => Center(
                                  child: Lottie.asset(
                                      'assets/images/global_loader.json',
                                      height: 50
                                  ),
                                ),
                                orElse: (){
                                  return CustomButton(
                                      onPressed: () {
                                        if (_addCustomerFormKey.currentState
                                            ?.validate() ??
                                            false) {
                                          ref
                                              .read(usersAddNewCustomerViewModelProvider
                                              .notifier)
                                              .create(
                                              endPoint: 'customers',
                                              name: name.text,
                                              email: email.text,
                                              phoneNo: phone.text,
                                              address: address.text,
                                              postalCode: postalCode.text,
                                              city: city.text,
                                              zoneArea: zone.text,
                                              additional: additional.text);
                                        }
                                      },
                                      text: 'add_new_customer'.tr(),
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
