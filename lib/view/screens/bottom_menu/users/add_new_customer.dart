import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/view_model/users/customers/add_new_cutomer_view_model.dart';
import 'package:global_reparaturservice/view_model/users/customers/update_customer_view_model.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/globals.dart';
import '../../../../models/response_state.dart';
import '../../../../models/user.dart';
import '../../../../view_model/users/customers/toggle_customer_status_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/loading_dialog.dart';


final selectedAddressToNewCustomer =
StateProvider.autoDispose<Map<String , dynamic>?>((ref) => null);

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

  double? lat;
  double? lng;

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
      postalCode.text = userModel?.postalCode.toString() ?? '';
      city.text = userModel?.city ?? '';
      zone.text = userModel?.zoneArea ?? '';
      additional.text =  '';
      lat = userModel?.lat;
      lat = userModel?.lng;
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

    ref.listen<ResponseState<UserModel>>(usersToggleCustomerStatusViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            data: (user) {

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


    if(ref.watch(selectedAddressToNewCustomer) != null){
      address.text = ref.read(selectedAddressToNewCustomer)?['address'] ?? '';
      postalCode.text = ref.read(selectedAddressToNewCustomer)?['postal_code'] ?? '';
      city.text = ref.read(selectedAddressToNewCustomer)?['city'] ?? '';
      zone.text = ref.read(selectedAddressToNewCustomer)?['zone_area'] ?? '';
      lat = ref.read(selectedAddressToNewCustomer)?['lat'];
      lng = ref.read(selectedAddressToNewCustomer)?['lng'];
      Future.microtask(() => ref.read(selectedAddressToNewCustomer.notifier).state = null);
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(
                    title: isUpdate == false ? 'add_new_customer'.tr() : 'update_customer'.tr(),

                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Form(
                      key: _addCustomerFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          const SizedBox(height: 10,),
                          if(isUpdate)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: userModel?.isDisabled ?? false ? Colors.red : Colors.green,
                                      ),
                                      const SizedBox(width: 10,),
                                      AutoSizeText(
                                        userModel?.isDisabled ?? false ? 'Disabled'.tr() : 'Active'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15,),
                              ],
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
                            height: 80,
                            validator: (String? text) {
                              if (text?.isEmpty ?? true) {
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            readOnly: true,
                            onTap: () async {
                              Prediction? prediction =
                              await PlacesAutocomplete.show(
                                context: context,
                                apiKey: kGoogleApiKey,
                                onError: (error) {},
                                mode: Mode.fullscreen,
                                language: "de",
                                sessionToken: DateTime.now().timeZoneName,
                                types: [],
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                strictbounds: false,
                                components: [Component(Component.country, "de")],
                              );

                              if (prediction != null) {

                                GoogleMapsPlaces places =
                                GoogleMapsPlaces(apiKey: kGoogleApiKey);
                                PlacesDetailsResponse? detail =
                                await places.getDetailsByPlaceId(
                                    prediction.placeId ?? '');

                                Map<String , dynamic> data = {};

                                for (var element in detail.result.addressComponents) {
                                  if(element.types[0] == 'postal_code'){
                                    data['postal_code'] = element.longName;
                                  }
                                  if(element.types[0] == 'administrative_area_level_1'){
                                    data['city'] = element.longName;
                                  }
                                  if(element.types[0] == 'administrative_area_level_3' || element.types[0] == 'administrative_area_level_2'){
                                    data['zone_area'] = element.longName;
                                  }
                                }

                                data['address'] = detail.result.formattedAddress;
                                data['lat'] = detail.result.geometry?.location.lat;
                                data['lng'] = detail.result.geometry?.location.lng;

                                ref
                                    .read(selectedAddressToNewCustomer.notifier)
                                    .state = data;
                              }
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
                                    if (text?.isEmpty ?? true) {
                                      return 'this_filed_required'.tr();
                                    }
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
                            validator: (String? text) {},
                            label: 'zone_area'.tr(),
                          ),
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

                                              print('postal code text field ${postalCode.text}');
                                              ref
                                                  .read(usersUpdateCustomerViewModelProvider
                                                  .notifier)
                                                  .update(
                                                  endPoint: 'customers/${userModel?.id}',
                                                  name: name.text,
                                                  email: email.text,
                                                  phone: phone.text,
                                                  lat: lat,
                                                  lng: lng,
                                                  postalCode: postalCode.text,
                                                  city: city.text,
                                                  zoneArea: zone.text,
                                                  address: address.text,
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
                                ref.watch(usersToggleCustomerStatusViewModelProvider).maybeWhen(
                                    loading: () => Center(
                                      child: Lottie.asset(
                                          'assets/images/global_loader.json',
                                          height: 50
                                      ),
                                    ),
                                    orElse: (){
                                      return CustomButton(
                                          onPressed: () {
                                            if(userModel?.isDisabled ?? false){
                                              ref
                                                  .read(usersToggleCustomerStatusViewModelProvider
                                                  .notifier)
                                                  .enable(endPoint: 'customers/active/${userModel?.id}',);
                                            }
                                            else{
                                              AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.question,
                                                  animType: AnimType.rightSlide,
                                                  title: 'Disable Customer'.tr(),
                                                  desc: 'Are you sure you want to disable this customer\n All orders without route for this customer will not be able to add to route'.tr(),
                                                  autoDismiss: false,
                                                  dialogBackgroundColor: Colors.white,
                                                  btnCancel: CustomButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    radius: 10,
                                                    text: 'No'.tr(),
                                                    textColor: Colors.white,
                                                    bgColor: const Color(0xffd63d46),
                                                    height: 40,
                                                  ),
                                                  btnOk: CustomButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      ref
                                                          .read(usersToggleCustomerStatusViewModelProvider
                                                          .notifier)
                                                          .disable(endPoint: 'customers/${userModel?.id}',);
                                                    },
                                                    radius: 10,
                                                    text: 'Yes'.tr(),
                                                    textColor: Colors.white,
                                                    bgColor: Theme.of(context).primaryColor,
                                                    height: 40,
                                                  ),
                                                  onDismissCallback: (dismiss) {})
                                                  .show();
                                            }
                                          },
                                          text: userModel?.isDisabled ?? false ? 'activate_customer'.tr() : 'disable_customer'.tr(),
                                          textColor: Colors.white,
                                          bgColor: userModel?.isDisabled ?? false ? Theme.of(context).primaryColor : Colors.red);
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
                                              lat: lat,
                                              lng: lng,
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
