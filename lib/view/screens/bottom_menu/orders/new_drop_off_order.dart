import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/view/widgets/custom_text_form_field.dart';
import 'package:global_reparaturservice/view_model/guarantees_view_model.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/providers/bottom_navigation_menu.dart';
import '../../../../core/providers/selected_machines_to_order.dart';
import '../../../../models/response_state.dart';
import '../../../../view_model/devices_view_model.dart';
import '../../../../view_model/order_view_model.dart';
import '../../../widgets/available_times.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/gradient_background.dart';
import 'new_order.dart';

final dropOffOrderModeProvider = StateProvider<int?>((ref) => 1);
final guaranteesTypeProvider = StateProvider<int>((ref) => 1);


class NewDropOffOrder extends ConsumerStatefulWidget {
  final OrderModel orderModel;
  const NewDropOffOrder({super.key ,required this.orderModel});

  @override
  ConsumerState createState() => _NewDropOffOrderState(orderModel);
}

class _NewDropOffOrderState extends ConsumerState<NewDropOffOrder> {
  final OrderModel orderModel;
  _NewDropOffOrderState(this.orderModel);

  static late TextEditingController firma;
  static late TextEditingController name;
  static late TextEditingController address;
  static late TextEditingController postalCode;
  static late TextEditingController partOfBuilding;
  static late TextEditingController telephone;



  static late TextEditingController information;

  @override
  void initState() {

    firma = TextEditingController();
    name = TextEditingController();
    address = TextEditingController();
    postalCode = TextEditingController();
    partOfBuilding = TextEditingController();
    telephone = TextEditingController();
    information = TextEditingController(text: orderModel.information);

    Future.microtask(() {

      ref.read(isCustomDate.notifier).state = false;
      ref.read(selectedVisitDateToNewOrder.notifier).state = null;
      ref.read(selectedVisitToNewOrder.notifier).state = null;

      ref.read(getDevicesViewModelProvider.notifier).getDevices();
      ref.read(getGuaranteesViewModelProvider.notifier).getGuarantees();
      ref.read(selectedMachinesProvider).clear();
      orderModel.devices?.forEach((element) {
        ref.read(selectedMachinesProvider.notifier).addMachine(machineId: element.id);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    firma.dispose();
    name.dispose();
    address.dispose();
    postalCode.dispose();
    partOfBuilding.dispose();
    telephone.dispose();
    information.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<OrderModel>>(orderViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            success: (order) {
              if (order?['with_route'] == true) {
                Navigator.pop(context, 'update');
                Navigator.pop(context, 'update');
                ref.read(bottomNavigationMenuProvider.notifier).state = 0;
              } else {
                Navigator.pop(context, 'update');
                Navigator.pop(context, 'update');
              }
            },
            error: (error) {
              if (ModalRoute.of(context)?.isCurrent != true) {
                Navigator.pop(context);
              }

              ref.read(selectedVisitDateToNewOrder.notifier).state = null;
              ref.read(selectedVisitToNewOrder.notifier).state = null;

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
            Column(
              children: [
                CustomAppBar(
                  title:'New Drop-Off Order'.tr() ,
                ),
                ref.watch(orderViewModelProvider).maybeWhen(
                    loading: () => Expanded(
                      child: Center(
                        child: Lottie.asset(
                            'assets/images/global_loader.json',
                            height: 50),
                      ),
                    ),
                    orElse: () {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 4),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      border: Border.all(
                                          color:
                                          const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Pick-Up Order reference'.tr(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      AutoSizeText(
                                        orderModel.referenceNo,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Order Type'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RadioListTile(
                                                value: 1,
                                                contentPadding: EdgeInsets.zero,
                                                groupValue: ref.watch(
                                                    dropOffOrderModeProvider) ??
                                                    1,
                                                onChanged: (value) {
                                                  ref
                                                      .read(dropOffOrderModeProvider
                                                      .notifier)
                                                      .state = value ?? 1;
                                                },
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                title: AutoSizeText(
                                                  'Reparatur'.tr(),
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                )),
                                          ),
                                          Expanded(
                                            child: RadioListTile(
                                                value: 2,
                                                groupValue:
                                                ref.watch(dropOffOrderModeProvider),
                                                contentPadding: EdgeInsets.zero,
                                                onChanged: (value) {
                                                  // ref
                                                  //     .read(dropOffOrderModeProvider
                                                  //     .notifier)
                                                  //     .state = value ?? 2;
                                                },
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                title: AutoSizeText(
                                                  'Verkauf'.tr(),
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: RadioListTile(
                                            value: 3,
                                            groupValue:
                                            ref.watch(dropOffOrderModeProvider),
                                            contentPadding: EdgeInsets.zero,
                                            onChanged: (value) {
                                              // ref
                                              //     .read(dropOffOrderModeProvider
                                              //     .notifier)
                                              //     .state = value ?? 3;
                                            },
                                            activeColor: Theme.of(context)
                                                .primaryColor,
                                            title: AutoSizeText(
                                              'Ankauf'.tr(),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'maintenance_device'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                        orderModel.maintenanceDevice,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'brand'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                        orderModel.brand,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Rg. Empf.'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: AutoSizeText(
                                              'Firma',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            ':  ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: AutoSizeText(
                                              orderModel.customer.companyName ?? 'N/A',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: AutoSizeText(
                                              'Name',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            ':  ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: AutoSizeText(
                                              orderModel.customer.name ?? 'N/A',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: AutoSizeText(
                                              'Adresse',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            ':  ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: AutoSizeText(
                                              orderModel.customer.address ?? 'N/A',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: AutoSizeText(
                                              'Plz',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            ':  ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: AutoSizeText(
                                              '${orderModel.customer.postalCode ?? 'N/A'}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: AutoSizeText(
                                              'Gebäudeteil',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            ':  ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: AutoSizeText(
                                              orderModel.customer.partOfBuilding ?? 'N/A',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: AutoSizeText(
                                              'Mobile',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            ':  ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: AutoSizeText(
                                              orderModel.customer.phone ?? 'N/A',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: AutoSizeText(
                                              'Telefon',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            ':  ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: AutoSizeText(
                                              orderModel.customer.telephone ?? 'N/A',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Leist. Adresse'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(label: 'Firma', validator: (text){},height: 55,controller: firma,),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(label: 'Name', validator: (text){},height: 55,controller: name,),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(label: 'Adresse', validator: (text){},height: 55,controller: address,),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(label: 'Plz', validator: (text){},height: 55,controller: postalCode,textInputType: TextInputType.number,),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(label: 'Gebäudeteil', validator: (text){},height: 55,controller: partOfBuilding,),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(label: 'Telefon', validator: (text){},height: 55,controller: telephone,),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Machines'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ref
                                          .watch(getDevicesViewModelProvider)
                                          .maybeWhen(
                                        loading: () {
                                          return Center(
                                              child: Lottie.asset(
                                                  'assets/images/global_loader.json',
                                                  height: 50));
                                        },
                                        data: (devices) {
                                          return GridView.builder(
                                              gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 5 / 1.5),
                                              itemCount: devices.length,
                                              shrinkWrap: true,
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final device = devices[index];
                                                return CheckboxListTile(
                                                    value: ref
                                                        .watch(
                                                        selectedMachinesProvider)
                                                        .contains(device.id),
                                                    contentPadding: EdgeInsets.zero,
                                                    controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                    onChanged: (value) {
                                                      // if(orderModel.status < 3){
                                                      //   if (!ref.watch(selectedMachinesProvider).contains(device.id)) {
                                                      //     ref
                                                      //         .read(
                                                      //         selectedMachinesProvider
                                                      //             .notifier)
                                                      //         .addMachine(
                                                      //         machineId: device.id);
                                                      //   }
                                                      //   else {
                                                      //     ref
                                                      //         .read(
                                                      //         selectedMachinesProvider
                                                      //             .notifier)
                                                      //         .removeMachine(
                                                      //         machineId: device.id);
                                                      //   }
                                                      // }
                                                    },
                                                    activeColor: Theme.of(context)
                                                        .primaryColor,
                                                    title: AutoSizeText(
                                                      device.name,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ));
                                              });
                                        },
                                        orElse: () {
                                          return Container();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Artikelbeschreibung (An- & Verkauf )'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      CustomTextFormField(label: 'Artikelbeschreibung (An- & Verkauf )', validator: (text){},height: 150,controller: information,),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Garantie'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ref
                                          .watch(getGuaranteesViewModelProvider)
                                          .maybeWhen(
                                        loading: () {
                                          return Center(
                                              child: Lottie.asset(
                                                  'assets/images/global_loader.json',
                                                  height: 50));
                                        },
                                        data: (guarantees) {
                                          return ListView.builder(
                                              itemCount: guarantees.length,
                                              shrinkWrap: true,
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final guarantee = guarantees[index];
                                                return RadioListTile(
                                                    value: guarantee.id,
                                                    contentPadding: EdgeInsets.zero,
                                                    groupValue: ref.watch(
                                                        guaranteesTypeProvider) ??
                                                        1,
                                                    onChanged: (value) {
                                                      ref
                                                          .read(guaranteesTypeProvider
                                                          .notifier)
                                                          .state = value ?? 1;
                                                    },
                                                    activeColor: Theme.of(context)
                                                        .primaryColor,
                                                    title: AutoSizeText(
                                                      guarantee.name,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ));
                                              });
                                        },
                                        orElse: () {
                                          return Container();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Services'.tr(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        children: [
                                          Table(
                                            border: TableBorder.all(),
                                            columnWidths: const {
                                              0: FlexColumnWidth(2.8),
                                              1: FlexColumnWidth(1.3),
                                              2: FlexColumnWidth(1.5),
                                            },
                                            children: [
                                              TableRow(
                                                children: <Widget>[
                                                  TableCell(
                                                    verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .top,
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.all(10),
                                                      child: AutoSizeText(
                                                        'Service'.tr(),
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                .primaryColor,
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            overflow: TextOverflow
                                                                .ellipsis),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .top,
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.all(10),
                                                      child: AutoSizeText(
                                                        'Anzahl'.tr(),
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                .primaryColor,
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            overflow: TextOverflow
                                                                .ellipsis),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .top,
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.all(10),
                                                      child: AutoSizeText(
                                                        'Endpreis'.tr(),
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                .primaryColor,
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            overflow: TextOverflow
                                                                .ellipsis),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Table(
                                            border: TableBorder.all(),
                                            columnWidths: const {
                                              0: FlexColumnWidth(2.8),
                                              1: FlexColumnWidth(1.3),
                                              2: FlexColumnWidth(1.5),
                                            },
                                            children: orderModel.items?.map((e) {
                                              return TableRow(
                                                children: <Widget>[
                                                  TableCell(
                                                    verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .top,
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          10),
                                                      child: AutoSizeText(
                                                        e.title,
                                                        style: TextStyle(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .top,
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          10),
                                                      child: AutoSizeText(
                                                        '${e.quantity}',
                                                        style: TextStyle(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .top,
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          10),
                                                      child: AutoSizeText(
                                                        '${e.price}',
                                                        style: TextStyle(
                                                            color:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            overflow: TextOverflow
                                                                .ellipsis),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList() ??
                                                [],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                      Border.all(color: const Color(0xffDCDCDC))),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AutoSizeText(
                                              '${'Netto Gesamt'.tr()} : ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: AutoSizeText(
                                              '${orderModel.subtotal ?? 0}',
                                              style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AutoSizeText(
                                              '${'19% MwSt.'.tr()} : ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: AutoSizeText(
                                              '${orderModel.vat ?? 0}',
                                              style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AutoSizeText(
                                              '${'*Endbetrag'.tr()} : ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: AutoSizeText(
                                              '${orderModel.total ?? 0}',
                                              style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                const AvailableTimesWidget(),
                                const SizedBox(height: 10,),
                                if (ref.watch(selectedVisitToNewOrder) != null)
                                CustomButton(onPressed: (){
                                  ref.read(orderViewModelProvider.notifier).dropOffOrder(referenceNumber: orderModel.referenceNo, withRoute: false, visitTime: ref.watch(selectedVisitToNewOrder), guaranteeId: ref.watch(guaranteesTypeProvider), companyName: firma.text, name: name.text, address: address.text, postalCode: postalCode.text, partOfBuilding: partOfBuilding.text, phone: telephone.text , information: information.text);
                                }, text: 'Drop-Off Order'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                                const SizedBox(height: 10,),
                                if (ref.watch(selectedVisitToNewOrder) != null)
                                CustomButton(onPressed: (){
                                  ref.read(orderViewModelProvider.notifier).dropOffOrder(referenceNumber: orderModel.referenceNo, withRoute: true, visitTime: ref.watch(selectedVisitToNewOrder), guaranteeId: ref.watch(guaranteesTypeProvider), companyName: firma.text, name: name.text, address: address.text, postalCode: postalCode.text, partOfBuilding: partOfBuilding.text, phone: telephone.text , information: information.text);
                                }, text: 'Drop-Off Order With Route'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                                const SizedBox(height: 10,),
                              ],
                            )
                          ),
                        ),
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
