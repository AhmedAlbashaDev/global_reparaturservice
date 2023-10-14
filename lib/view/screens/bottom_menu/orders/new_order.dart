import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/view_model/order_view_model.dart';
import 'package:global_reparaturservice/view_model/orders_view_model.dart';
import 'package:google_maps_webservice/places.dart';

import '../../../../core/globals.dart';
import '../../../../models/response_state.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custsomer_card_new_order.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/loading_dialog.dart';
import 'select_or_add_customer.dart';

final selectedAddressToNewOrder =
    StateProvider<PlacesDetailsResponse?>((ref) => null);

class NewOrderScreen extends ConsumerStatefulWidget {
  const NewOrderScreen({super.key});

  @override
  ConsumerState createState() => _State();
}

class _State extends ConsumerState<NewOrderScreen> {


  late TextEditingController maintenanceDeviceController;
  late TextEditingController brand;
  late TextEditingController phone;
  late TextEditingController description;
  late TextEditingController address;
  late TextEditingController floorNumber;
  late TextEditingController apartmentNumber;
  late TextEditingController additionalInfo;


  final GlobalKey<FormState> _newOrderFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      ref.read(selectedAddressToNewOrder.notifier).state = null;
      ref.read(selectedUserToNewOrder.notifier).state = null;
    });

    maintenanceDeviceController = TextEditingController();
    brand = TextEditingController();
    phone = TextEditingController();
    description = TextEditingController();
    address = TextEditingController();
    floorNumber = TextEditingController();
    apartmentNumber = TextEditingController();
    additionalInfo = TextEditingController();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    maintenanceDeviceController.dispose();
    brand.dispose();
    phone.dispose();
    description.dispose();
    address.dispose();
    floorNumber.dispose();
    apartmentNumber.dispose();
    additionalInfo.dispose();
  }


  @override
  Widget build(BuildContext context) {


    address.text = ref.watch(selectedAddressToNewOrder)?.result.formattedAddress ?? '';

    ref.listen<ResponseState<OrderModel>>(orderViewModelProvider, (previous, next) {
      next.whenOrNull(
        loading: (){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const LoadingDialog(),
          );
        },
        success: (order) {

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

          Navigator.pop(context);

          ref.read(ordersViewModelProvider.notifier).loadAll();

        },
        error: (error) {

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            content: CustomSnakeBarContent(
              icon: const Icon(Icons.error, color: Colors.red , size: 25,),
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
                    title: 'new_order'.tr(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    child: Form(
                      key: _newOrderFormKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomerCardNewOrder(
                            empty:
                                ref.read(selectedUserToNewOrder.notifier).state ==
                                        null
                                    ? true
                                    : false,
                            userModel: ref.watch(selectedUserToNewOrder),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: maintenanceDeviceController,
                            validator: (text) {
                              if(text?.isEmpty ?? true){
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'maintenance_device'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: brand,
                            validator: (text) {
                              if(text?.isEmpty ?? true){
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'brand'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: description,
                            height: 150,
                            maxLength: 150,
                            validator: (text) {
                              if(text?.isEmpty ?? true){
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'problem_summary'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: phone,
                            textInputType: TextInputType.number,//Messedamm, 14057 Berlin, Germany
                            validator: (text) {
                              if(text?.isEmpty ?? true){
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            label: 'phone'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
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
                                ref
                                    .read(selectedAddressToNewOrder.notifier)
                                    .state = detail;
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade400)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 20),
                                child: Row(
                                  children: [
                                    AutoSizeText(
                                      'auto_complete_address'.tr(),
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: address,
                            validator: (text) {
                              if(text?.isEmpty ?? true){
                                return 'this_filed_required'.tr();
                              }
                              return null;
                            },
                            readOnly: true,
                            label: 'address'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomTextFormField(
                                  controller: floorNumber,
                                  validator: (text) {
                                    if(text?.isEmpty ?? true){
                                      return 'this_filed_required'.tr();
                                    }
                                    return null;
                                  },
                                  textInputType: TextInputType.number,
                                  label: 'floor_number'.tr(),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 4,
                                child: CustomTextFormField(
                                  controller: apartmentNumber,
                                  validator: (text) {
                                    if(text?.isEmpty ?? true){
                                      return 'this_filed_required'.tr();
                                    }
                                    return null;
                                  },
                                  textInputType: TextInputType.number,
                                  label: 'apartment_number'.tr(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: additionalInfo,
                            height: 90,
                            validator: (text) {},
                            label: 'additional_info'.tr(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                              onPressed: () {
                                if(_newOrderFormKey.currentState?.validate() ?? false){
                                  ref.read(orderViewModelProvider.notifier).create(maintenanceDevice: maintenanceDeviceController.text, brand: brand.text, description: description.text, address: address.text, floorNumber: floorNumber.text, apartmentNumber: apartmentNumber.text, additionalInfo: additionalInfo.text, customerId: ref.read(selectedUserToNewOrder)?.id, lat: ref.read(selectedAddressToNewOrder)?.result.geometry?.location.lat, lng: ref.read(selectedAddressToNewOrder)?.result.geometry?.location.lng , phone: phone.text);
                                }
                              },
                              text: 'place_an_order'.tr(),
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
