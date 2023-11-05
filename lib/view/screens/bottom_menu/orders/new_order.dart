import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:global_reparaturservice/core/providers/bottom_navigation_menu.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/view_model/order_view_model.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/globals.dart';
import '../../../../models/response_state.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custsomer_card_new_order.dart';
import '../../../widgets/gradient_background.dart';
import 'select_or_add_customer.dart';

// final selectedAddressToNewOrder =
//     StateProvider<PlacesDetailsResponse?>((ref) => null);

final selectedAddressToNewOrder =
StateProvider<Map<String , dynamic>?>((ref) => null);

final newOrderTabsSelectedProvider = StateProvider<int>((ref) => 0);


class NewOrderScreen extends ConsumerStatefulWidget {
  const NewOrderScreen({super.key});

  @override
  ConsumerState createState() => _State();
}

class _State extends ConsumerState<NewOrderScreen> with TickerProviderStateMixin {


  late TextEditingController referenceNumber;
  late TextEditingController maintenanceDeviceController;
  late TextEditingController brand;
  late TextEditingController customerPhone;
  late TextEditingController orderPhone;
  late TextEditingController description;
  late TextEditingController address;
  late TextEditingController postalCode;
  late TextEditingController city;
  late TextEditingController zone;
  late TextEditingController floorNumber;
  late TextEditingController apartmentNumber;
  late TextEditingController additionalInfo;

  TabController? tabController;


  double? lat;
  double? lng;

  final GlobalKey<FormState> _newOrderFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dropOffFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(newOrderTabsSelectedProvider.notifier).state = 0;
      ref.read(selectedAddressToNewOrder.notifier).state = null;
      ref.read(selectedUserToNewOrder.notifier).state = null;
    });

    referenceNumber = TextEditingController();
    maintenanceDeviceController = TextEditingController();
    brand = TextEditingController();
    customerPhone = TextEditingController();
    orderPhone = TextEditingController();
    description = TextEditingController();
    address = TextEditingController();
    postalCode = TextEditingController();
    city = TextEditingController();
    zone = TextEditingController();
    floorNumber = TextEditingController();
    apartmentNumber = TextEditingController();
    additionalInfo = TextEditingController();

    tabController = TabController(length: 2, vsync: this);

  }

  @override
  void dispose() {
    referenceNumber.dispose();
    maintenanceDeviceController.dispose();
    brand.dispose();
    customerPhone.dispose();
    orderPhone.dispose();
    description.dispose();
    address.dispose();
    postalCode.dispose();
    city.dispose();
    zone.dispose();
    floorNumber.dispose();
    apartmentNumber.dispose();
    additionalInfo.dispose();
    tabController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<OrderModel>>(orderViewModelProvider, (previous, next) {
      next.whenOrNull(
        success: (order) {

          if(order?['with_route'] == true){
            Navigator.pop(context , 'update');
            ref.read(bottomNavigationMenuProvider.notifier).state = 0;
          }
          else{
            Navigator.pop(context , 'update');
          }

        },
        error: (error) {

          if(ModalRoute.of(context)?.isCurrent != true){
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

    address.text          = ref.watch(selectedAddressToNewOrder)?['address'] ?? ( ref.watch(selectedUserToNewOrder)?.address ?? '');
    customerPhone.text    = ref.watch(selectedUserToNewOrder)?.phone ?? '';
    postalCode.text       = '${ref.watch(selectedAddressToNewOrder)?['postal_code'] ?? ( ref.watch(selectedUserToNewOrder)?.postalCode ?? '')}';
    city.text             = ref.watch(selectedAddressToNewOrder)?['city'] ?? ( ref.watch(selectedUserToNewOrder)?.city ?? '');
    zone.text             = ref.watch(selectedAddressToNewOrder)?['zone_area'] ?? ( ref.watch(selectedUserToNewOrder)?.zoneArea ?? '');


    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: 'new_order'.tr(),
                ),
                ref.watch(orderViewModelProvider).maybeWhen(
                  loading: () => Expanded(
                    child: Center(
                      child: Lottie.asset(
                          'assets/images/global_loader.json',
                          height: 50
                      ),
                    ),
                  ),
                  orElse: (){
                    return Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              Container(
                                height: 45,
                                width: screenWidth * 95,
                                padding:  const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Row(
                                  // controller: tabController,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap :(){
                                          ref.read(newOrderTabsSelectedProvider.notifier).state = 0;
                                          tabController?.animateTo(0);
                                        },
                                        child: Container(
                                          decoration: ref.watch(newOrderTabsSelectedProvider) == 0 ?  BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(20)
                                          ) : null,
                                          child: Center(
                                            child: AutoSizeText(
                                              'Pick-Up Or On-Site'.tr(),
                                              style: ref.watch(newOrderTabsSelectedProvider) == 0 ?  const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ) :  TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap :(){
                                          ref.read(newOrderTabsSelectedProvider.notifier).state = 1;
                                          tabController?.animateTo(1);
                                        },
                                        child: Container(
                                          decoration: ref.watch(newOrderTabsSelectedProvider) == 1 ?  BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(20)
                                          ) : null,
                                          child: Center(
                                            child: AutoSizeText(
                                              'Drop-Off'.tr(),
                                              style: ref.watch(newOrderTabsSelectedProvider) == 1 ?  const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ) :  TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics:  const NeverScrollableScrollPhysics(),
                                  controller: tabController,
                                  children: [
                                    SingleChildScrollView(
                                      child: Form(
                                        key: _newOrderFormKey,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomerCardNewOrder(
                                              empty: ref.read(selectedUserToNewOrder.notifier).state ==
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
                                              controller: customerPhone,
                                              readOnly: true,
                                              textInputType: TextInputType.number,
                                              validator: (String? text) {
                                                if(text?.isEmpty ?? true){
                                                  return 'this_filed_required'.tr();
                                                }
                                                else if(text != null && text.length < 12){
                                                  return 'Phone must be 12 number minimum'.tr();
                                                }
                                                return null;
                                              },
                                              maxLength: 12,
                                              height: 60,
                                              hint: 'customer_phone'.tr(),
                                              label: 'customer_phone'.tr(),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomTextFormField(
                                              controller: orderPhone,
                                              textInputType: TextInputType.number,
                                              validator: (String? text) {
                                                if((text != null && text.isNotEmpty) && text.length < 12){
                                                  return 'Phone must be 12 number minimum'.tr();
                                                }
                                                return null;
                                              },
                                              maxLength: 12,
                                              height: 70,

                                              hint: 'Optional'.tr(),
                                              label: 'order_phone'.tr(),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Theme.of(context).primaryColor,
                                                  width: .5,
                                                ),
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              padding: const EdgeInsets.all(5),
                                              child: Column(
                                                children: [
                                                  CustomTextFormField(
                                                    controller: address,
                                                    height: 80,
                                                    validator: (text) {
                                                      if(text?.isEmpty ?? true){
                                                        return 'this_filed_required'.tr();
                                                      }
                                                      return null;
                                                    },
                                                    readOnly: true,
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
                                                    height: 5,
                                                  ),
                                                  CustomButton(onPressed: () async {
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

                                                      // print('Location name ${prediction.description}');
                                                      // print('detail.result.formattedAddress name ${detail.result.formattedAddress}');

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
                                                          .read(selectedAddressToNewOrder.notifier)
                                                          .state = data;
                                                    }
                                                  }, text: 'Update Address'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 5,
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
                                                    ref.read(orderViewModelProvider.notifier).create(
                                                        maintenanceDevice: maintenanceDeviceController.text, brand: brand.text,
                                                        description: description.text, address: address.text, floorNumber: floorNumber.text,
                                                        apartmentNumber: apartmentNumber.text, additionalInfo: additionalInfo.text,
                                                        customerId: ref.read(selectedUserToNewOrder)?.id,
                                                        lat: ref.read(selectedAddressToNewOrder)?['lat'],
                                                        lng: ref.read(selectedAddressToNewOrder)?['lng'],
                                                        postalCode: postalCode.text,
                                                        city: city.text,
                                                        zone:  zone.text,
                                                        phone: orderPhone.text
                                                    );
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
                                    ),
                                    SingleChildScrollView(
                                      child: Form(
                                        key: _dropOffFormKey,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            AutoSizeText(
                                              'Enter the reference number for the pickup order below and place a drop-off order connected with the pick-up order'.tr(),
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomTextFormField(
                                              controller: referenceNumber,
                                              validator: (text) {
                                                if(text?.isEmpty ?? true){
                                                  return 'this_filed_required'.tr();
                                                }
                                                return null;
                                              },
                                              label: 'Reference number'.tr(),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomButton(
                                                onPressed: () {
                                                  if(_dropOffFormKey.currentState?.validate() ?? false){
                                                    ref.read(orderViewModelProvider.notifier).dropOffOrder(referenceNumber: referenceNumber.text, withRoute: false);
                                                  }
                                                },
                                                text: 'place_an_order'.tr(),
                                                textColor: Colors.white,
                                                bgColor: Theme.of(context).primaryColor),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomButton(
                                                onPressed: () {
                                                  if(_dropOffFormKey.currentState?.validate() ?? false){
                                                    ref.read(orderViewModelProvider.notifier).dropOffOrder(referenceNumber: referenceNumber.text, withRoute: true);
                                                  }
                                                },
                                                text: 'Place an order with new route'.tr(),
                                                textColor: Colors.white,
                                                bgColor: Theme.of(context).primaryColor),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                    );
                  }
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
