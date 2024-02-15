import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/providers/added_items_to_order.dart';
import '../../../../core/providers/select_files_to_upload.dart';
import '../../../../core/providers/selected_machines_to_order.dart';
import '../../../../models/order.dart';
import '../../../../models/response_state.dart';
import '../../../../view_model/devices_view_model.dart';
import '../../../../view_model/guarantees_view_model.dart';
import '../../../../view_model/load_one_order_view_model.dart';
import '../../../../view_model/order_view_model.dart';
import '../../../../view_model/questions_view_model.dart';
import '../../../../view_model/route_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/gradient_background.dart';
import 'new_drop_off_order.dart';
import 'order_details_technician.dart';

class DropOddOrderDetailsTechnician extends ConsumerStatefulWidget {

  final int orderId;
  final int routeId;

  const DropOddOrderDetailsTechnician({super.key ,required this.orderId,required this.routeId});

  @override
  ConsumerState createState() => _DropOddOrderDetailsTechnicianState(orderId: orderId,routeId: routeId);
}

class _DropOddOrderDetailsTechnicianState extends ConsumerState<DropOddOrderDetailsTechnician> {

  OrderModel? globalOrderModel;

  final int orderId;
  final int routeId;

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  static late TextEditingController report;

  _DropOddOrderDetailsTechnicianState({required this.orderId, required this.routeId});

  @override
  void initState() {

    report = TextEditingController();

    Future.microtask(() {
      ref.read(loadOrderViewModelProvider.notifier).loadOne(orderId: orderId);
      ref.read(getDevicesViewModelProvider.notifier).getDevices();
      ref.read(selectedMachinesProvider).clear();
      ref.read(orderPaymentModeProvider.notifier).state = 1;
    });
    super.initState();
  }

  @override
  void dispose() {
    report.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<OrderModel>>(orderViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            success: (order) {
              if (order?['send_invoice'] == true) {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.rightSlide,
                    title: 'Invoice'.tr(),
                    desc: 'Successfully send Invoice to customer'.tr(),
                    autoDismiss: false,
                    dialogBackgroundColor: Colors.white,
                    btnOk: CustomButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      radius: 10,
                      text: 'Ok'.tr(),
                      textColor: Colors.white,
                      bgColor: Theme.of(context).primaryColor,
                      height: 40,
                    ),
                    onDismissCallback: (dismiss) {})
                    .show();
              } else if (order?['finish_drop_off_order'] == true) {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.rightSlide,
                    title: 'Order'.tr(),
                    desc:
                    'Successfully finished this order \n Check other orders'
                        .tr(),
                    autoDismiss: false,
                    dialogBackgroundColor: Colors.white,
                    btnOk: CustomButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(selectedFilesToUpload).clear();
                        ref
                            .read(routeViewModelProvider.notifier)
                            .loadOne(routeId: routeId);
                        Navigator.of(context).pop();
                      },
                      radius: 10,
                      text: 'Ok'.tr(),
                      textColor: Colors.white,
                      bgColor: Theme.of(context).primaryColor,
                      height: 40,
                    ),
                    onDismissCallback: (dismiss) {})
                    .show();
              } else if (order?['update_order'] == true) {
                ref.read(addedItemsToOrderProvider).clear();
                ref.read(loadOrderViewModelProvider.notifier).loadOne(orderId: orderId);
              } else {
                ref.read(selectedFilesToUpload).clear();
                ref
                    .read(loadOrderViewModelProvider.notifier)
                    .loadOne(orderId: orderId);
              }
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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title:'Drop-Off Order'.tr() ,
                ),
                ref.watch(loadOrderViewModelProvider).maybeWhen(
                  loading: () => Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/images/global_loader.json',
                            height: 50),
                      ],
                    ),
                  ),
                  data: (orderModel) {

                    if (_refreshController.isRefresh) {
                      _refreshController.refreshCompleted();
                    }

                    Future.microtask((){
                      orderModel.devices?.forEach((element) {
                        ref.read(selectedMachinesProvider.notifier).addMachine(machineId: element.id);
                      });
                    });

                    globalOrderModel = orderModel;

                    return DropOffOrderTechnicianView(
                        orderModel: globalOrderModel!,
                        report: report,
                    );
                  },
                  success: (data) {
                    return DropOffOrderTechnicianView(
                        orderModel: globalOrderModel!,
                        report: report,
                    );
                  },
                  error: (error) => CustomError(
                    message: error.errorMessage ?? '',
                    onRetry: () {
                      ref
                          .read(loadOrderViewModelProvider.notifier)
                          .loadOne(orderId: orderId);
                    },
                  ),
                  orElse: () => Center(
                    child: CustomError(
                      message: 'unknown_error_please_try_again'.tr(),
                      onRetry: () {
                        ref
                            .read(loadOrderViewModelProvider.notifier)
                            .loadOne(orderId: orderId);
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DropOffOrderTechnicianView extends ConsumerWidget {
  final OrderModel orderModel;
  final TextEditingController report;
  const DropOffOrderTechnicianView({super.key ,required this.orderModel , required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(orderViewModelProvider).maybeWhen(
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
                              'Visit Time'.tr(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context)
                                    .primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            AutoSizeText(
                              Jiffy.parse(orderModel.visitTime ?? '').format(pattern: 'dd.MM.yyyy : HH:mm'),
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
                                      groupValue:1,
                                      onChanged: (value) {},
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
                                      groupValue: 1,
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
                                  groupValue: 1,
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
                                    (orderModel.customer.name ?? orderModel.customer.companyName) ?? '',
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
                                    orderModel.deliveryAddress!.companyName ?? 'N/A',
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
                                    orderModel.deliveryAddress?.name ?? 'N/A',
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
                                    orderModel.deliveryAddress?.address ?? 'N/A',
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
                                    '${orderModel.deliveryAddress?.postalCode ?? 'N/A'}',
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
                                    orderModel.deliveryAddress?.partOfBuilding ?? 'N/A',
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
                                    orderModel.deliveryAddress?.phone ?? 'N/A',
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
                                    orderModel.deliveryAddress?.telephone ?? 'N/A',
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
                              'maintenance_device'.tr(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            AutoSizeText(
                              orderModel.maintenanceDevice,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
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
                                          onChanged: (value) {},
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
                              height: 10,
                            ),
                            AutoSizeText(
                              orderModel.information ?? 'N/A',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
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
                              'Garantie'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AutoSizeText(
                                orderModel.guarantee?.name ?? 'N/A',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                    '${orderModel.subtotal ?? 0} €',
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
                                    '${orderModel.vat ?? 0} €',
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
                                    '${orderModel.total ?? 0} €',
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
                              'Paid Amount'.tr(),//€
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10,),
                            AutoSizeText(
                              '${orderModel.paidAmount ?? '0.0'} €',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,),),],),),
                      const SizedBox(height: 10,),
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
                              'Due Amount'.tr(),//€
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10,),
                            AutoSizeText(
                              '${((orderModel.total ?? 0) - (orderModel.paidAmount ?? 0)).toStringAsFixed(2)} €',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,),),],),),
                      const SizedBox(height: 10,),
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
                            CheckboxListTile(
                                value: ref.watch(isAmountReceived) ?? false,
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  if(orderModel.status != 4){
                                    if (!(ref.watch(isAmountReceived) ?? false)) {
                                      ref
                                          .read(isAmountReceived.notifier)
                                          .state = value ?? true;
                                    }
                                    else {
                                      ref
                                          .read(isAmountReceived.notifier)
                                          .state = value ?? false;
                                    }
                                  }
                                },
                                activeColor: Theme.of(context).primaryColor,
                                title: AutoSizeText(
                                  'Betrag dankend erhalten',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            CheckboxListTile(
                                value:
                                ref.watch(isCustomerConfirm) ?? false,
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  if(orderModel.status != 4){
                                    if (!(ref.watch(isCustomerConfirm) ?? false)) {
                                      ref
                                          .read(isCustomerConfirm.notifier)
                                          .state = value ?? true;
                                    }
                                    else {
                                      ref
                                          .read(isCustomerConfirm.notifier)
                                          .state = value ?? false;
                                    }
                                  }
                                },
                                activeColor: Theme.of(context).primaryColor,
                                title: AutoSizeText(
                                  'Ware in einwandfreiem Zustand erhalten. Richtigkeit aller Angaben. Vom einwandfreien Funktionieren des Gerätes habe ich mich überzeugt',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
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
                              'Order Payment Type'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10,),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile(
                                          value: 1,
                                          contentPadding: EdgeInsets.zero,
                                          groupValue: ref.watch(
                                              orderPaymentModeProvider) ??
                                              1,
                                          onChanged: (value) {
                                            if(orderModel.status != 4){
                                              ref
                                                  .read(orderPaymentModeProvider
                                                  .notifier)
                                                  .state = value ?? 1;
                                            }
                                          },
                                          activeColor: Theme.of(context)
                                              .primaryColor,
                                          title: AutoSizeText(
                                            'Bar'.tr(),
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
                                          contentPadding: EdgeInsets.zero,
                                          groupValue:
                                          ref.watch(orderPaymentModeProvider),
                                          onChanged: (value) {
                                            if(orderModel.status != 4){
                                              ref
                                                  .read(orderPaymentModeProvider
                                                  .notifier)
                                                  .state = value ?? 2;
                                            }
                                          },
                                          activeColor: Theme.of(context)
                                              .primaryColor,
                                          title: AutoSizeText(
                                            'EC'.tr(),
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
                                      flex: 2,
                                      child: RadioListTile(
                                          value: 3,
                                          contentPadding: EdgeInsets.zero,
                                          groupValue:
                                          ref.watch(orderPaymentModeProvider),
                                          onChanged: (value) {
                                            if(orderModel.status != 4){
                                              ref
                                                  .read(orderPaymentModeProvider
                                                  .notifier)
                                                  .state = value ?? 3;
                                            }
                                          },
                                          activeColor: Theme.of(context)
                                              .primaryColor,
                                          title: AutoSizeText(
                                            'Überweisung'.tr(),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      CustomTextFormField(
                        label: 'order_report'.tr(),
                        controller: report,
                        height: 60,
                        readOnly: orderModel.status > 2,
                        validator: (text) {},
                      ),
                      const SizedBox(height: 10,),
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
                              'order_status'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10,),
                            AutoSizeText(
                              orderModel.statusName ?? '',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,),),],),),
                      const SizedBox(height: 10,),
                      if(orderModel.status != 4)
                      CustomButton(onPressed: (){
                        if(ref.watch(orderPaymentModeProvider) != 0){
                          ref.read(orderViewModelProvider.notifier).updatePayment(orderId: orderModel.id, paymentWay: ref.read(orderPaymentModeProvider) ?? 1, report: report.text, isDropOff: true);
                        }
                        else{
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error'.tr(),
                              desc: 'Please select payment type'.tr(),
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
                        }
                      }, text: 'Finish Drop Off Order', textColor: Colors.white, bgColor: Theme.of(context).primaryColor)
                    ],
                  )
              ),
            ),
          );
        });
  }
}

//::TODO Update PickUp Order in admin
