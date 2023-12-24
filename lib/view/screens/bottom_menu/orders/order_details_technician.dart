import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/core/providers/added_items_to_order.dart';
import 'package:global_reparaturservice/core/providers/answered_questions_to_order.dart';
import 'package:global_reparaturservice/core/providers/request_sending_progress.dart';
import 'package:global_reparaturservice/core/providers/select_files_to_upload.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:global_reparaturservice/view/widgets/custom_text_form_field.dart';
import 'package:global_reparaturservice/view_model/devices_view_model.dart';
import 'package:global_reparaturservice/view_model/questions_view_model.dart';
import 'package:global_reparaturservice/view_model/route_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/providers/selected_machines_to_order.dart';
import '../../../../models/order.dart';
import '../../../../models/response_state.dart';
import '../../../../view_model/load_one_order_view_model.dart';
import '../../../../view_model/order_add_files_view_model.dart';
import '../../../../view_model/order_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custsomer_card_new_order.dart';
import '../../../widgets/gradient_background.dart';

final addedFiles = StateProvider<int>((ref) => 0);
final orderModeProvider = StateProvider<int?>((ref) => null);
final orderPaymentModeProvider = StateProvider<int?>((ref) => null);
final machineIsBrokenProvider = StateProvider<bool?>((ref) => null);
final customerAcceptOrderProvider = StateProvider<bool?>((ref) => null);
final technicianTakeMachineProvider = StateProvider<bool?>((ref) => null);
final isAmountReceived = StateProvider<bool?>((ref) => null);
final isCustomerConfirm = StateProvider<bool?>((ref) => null);

class OrderDetailsTechnician extends ConsumerStatefulWidget {
  const OrderDetailsTechnician(
      {super.key, required this.orderId, required this.routeId});

  final int orderId;
  final int routeId;

  @override
  ConsumerState createState() =>
      _OrderDetailsTechnicianState(orderId: orderId, routeId: routeId);
}

class _OrderDetailsTechnicianState
    extends ConsumerState<OrderDetailsTechnician> {
  _OrderDetailsTechnicianState({required this.orderId, required this.routeId});

  final int orderId;
  final int routeId;

  OrderModel? globalOrderModel;

  static late TextEditingController title;
  static late TextEditingController price;
  static late TextEditingController brand;
  static late TextEditingController information;
  static late TextEditingController quantity;
  static late TextEditingController paidAmount;
  static late TextEditingController maxMaintenancePrice;
  static late TextEditingController report;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      ref.read(selectedMachinesProvider).clear();
      ref.read(answeredQuestionsProvider).clear();

      ref.read(orderModeProvider.notifier).state = null;
      ref.read(orderPaymentModeProvider.notifier).state = null;
      ref.read(machineIsBrokenProvider.notifier).state = null;
      ref.read(customerAcceptOrderProvider.notifier).state = null;
      ref.read(technicianTakeMachineProvider.notifier).state = null;
      ref.read(isAmountReceived.notifier).state = null;
      ref.read(isCustomerConfirm.notifier).state = null;

      ref.read(loadOrderViewModelProvider.notifier).loadOne(orderId: orderId);
      ref.read(getDevicesViewModelProvider.notifier).getDevices();
      ref.read(getQuestionsViewModelProvider.notifier).getQuestions();
      ref.read(addedFiles.notifier).state = 0;

      title = TextEditingController();
      price = TextEditingController();
      brand = TextEditingController();
      information = TextEditingController();
      quantity = TextEditingController();
      paidAmount = TextEditingController();
      maxMaintenancePrice = TextEditingController();
      report = TextEditingController();
    });

  }

  @override
  void dispose() {
    title.dispose();
    price.dispose();
    brand.dispose();
    information.dispose();
    quantity.dispose();
    paidAmount.dispose();
    maxMaintenancePrice.dispose();
    report.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: 'order_details'.tr(),
                  onPop: () {
                    ref.read(addedItemsToOrderProvider).clear();
                    ref
                        .read(routeViewModelProvider.notifier)
                        .loadOne(routeId: routeId);
                    Navigator.pop(context);
                  },
                ),
                ref.watch(loadOrderViewModelProvider).maybeWhen(
                      loading: () => Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/images/global_loader.json',
                                height: 50),
                            if (ref.watch(sendingRequestProgress) > 0)
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    '${ref.watch(sendingRequestProgress)}%',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              )
                          ],
                        ),
                      ),
                      data: (orderModel) {
                        if (_refreshController.isRefresh) {
                          _refreshController.refreshCompleted();
                        }

                        globalOrderModel = orderModel;

                        if(brand.text.isEmpty){
                          brand.text = orderModel.brand;
                        }
                        if(information.text.isEmpty){
                          information.text = orderModel.information ?? '';
                        }

                        // if(paidAmount.text.isEmpty){
                        //   paidAmount.text = '${orderModel.paidAmount ?? '0.00'}';
                        // }

                        if(maxMaintenancePrice.text.isEmpty){
                          maxMaintenancePrice.text = '${orderModel.maxMaintenancePrice ?? 'N/A'}';
                        }

                        if(orderModel.status > 2){
                          report.text = '${orderModel.report}';
                        }

                        Future.microtask(() {

                          ref.read(orderModeProvider.notifier).state = orderModel.orderMode;

                          orderModel.devices?.forEach((element) {
                            ref.read(selectedMachinesProvider.notifier).addMachine(machineId: element.id);
                          });

                          if(orderModel.isPickup){
                            ref.read(isAmountReceived.notifier).state = orderModel.isAmountReceived;

                            ref.read(isCustomerConfirm.notifier).state = orderModel.isCustomerConfirm;
                          }

                          orderModel.questions?.forEach((element) {
                            ref.read(answeredQuestionsProvider.notifier).addQuestion(questionId: element.id);
                          });
                        });

                        return OrderDetailsTechnicianView(orderModel: orderModel, routeId: routeId, title: title, price: price, brand: brand, information: information, quantity: quantity, paidAmount: paidAmount, maxMaintenancePrice: maxMaintenancePrice , report: report,);
                      },
                      success: (data) {
                        return OrderDetailsTechnicianView(orderModel: globalOrderModel!, routeId: routeId, title: title, price: price, brand: brand, information: information, quantity: quantity, paidAmount: paidAmount, maxMaintenancePrice: maxMaintenancePrice , report: report,);
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

class OrderDetailsTechnicianView extends ConsumerWidget {

  final OrderModel orderModel;
  final int routeId;

  final TextEditingController title;
  final TextEditingController price;
  final TextEditingController brand;
  final TextEditingController information;
  final TextEditingController quantity;
  final TextEditingController paidAmount;
  final TextEditingController maxMaintenancePrice;
  final TextEditingController report;

  static final GlobalKey<FormState> _reportFormKey = GlobalKey<FormState>();

  final RefreshController refreshController =
  RefreshController(initialRefresh: false);

  OrderDetailsTechnicianView({super.key, required this.orderModel, required this.routeId, required this.title, required this.price, required this.brand, required this.information, required this.quantity, required this.paidAmount, required this.maxMaintenancePrice , required this.report});

  @override
  Widget build(BuildContext context , WidgetRef ref) {

    ref.listen<ResponseState<OrderModel>>(orderViewModelProvider,
            (previous, next) {
          next.whenOrNull(
            success: (order) {
              ref.read(addedItemsToOrderProvider).clear();
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
              }
              else if (order?['finish_pickup_order'] == true) {
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
              }
              else if (order?['update_order'] == true) {
                ref.read(loadOrderViewModelProvider.notifier).loadOne(orderId: orderModel.id);
              }
              else {
                ref.read(selectedFilesToUpload).clear();
                ref
                    .read(loadOrderViewModelProvider.notifier)
                    .loadOne(orderId: orderModel.id);
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

    ref.listen(orderFilesViewModelProvider, (previous, next) {
      next.whenOrNull(
        loading: (){
          AwesomeDialog(
              context: context,
              dialogType: DialogType.noHeader,
              animType: AnimType.rightSlide,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10,),
                    Lottie.asset('assets/images/global_loader.json',
                        height: 50),
                    const SizedBox(height: 10,),
                    if (ref.watch(sendingRequestProgress) > 0)
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            '${ref.watch(sendingRequestProgress)}%',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    const SizedBox(height: 10,),
                    CustomButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      radius: 10,
                      text: 'Close'.tr(),
                      textColor: Colors.white,
                      bgColor: const Color(0xffd63d46),
                      height: 40,
                    ),
                  ],
                ),
              ),
              autoDismiss: false,
              dialogBackgroundColor: Colors.white,
              onDismissCallback: (dismiss) {})
              .show();
        },
        data: (data){
          Navigator.of(context).pop();
          ref
              .read(loadOrderViewModelProvider.notifier)
              .loadOne(orderId: orderModel.id);
        },
        success: (data){
          Navigator.of(context).pop();
          ref
              .read(loadOrderViewModelProvider.notifier)
              .loadOne(orderId: orderModel.id);
        }

      );
    });

    return Expanded(
      child: SizedBox(
        width: screenWidth * 95,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: () async {
                ref
                    .read(loadOrderViewModelProvider.notifier)
                    .loadOne(orderId: orderModel.id);
              },
              child: ref.watch(orderViewModelProvider).maybeWhen(
                  loading: () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/images/global_loader.json',
                          height: 50),
                    ],
                  ),
                  orElse: () {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                borderRadius: BorderRadius.circular(8),
                                border:
                                Border.all(color: const Color(0xffDCDCDC))),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  'Order reference'.tr(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SelectionArea(
                                  child: AutoSizeText(
                                    orderModel.referenceNo,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15,
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
                          CustomerCardNewOrder(
                            userModel: orderModel.customer,
                            isOrderDetails: true,
                            isOnMap: true,
                            orderPhone: orderModel.orderPhoneNumber,
                            empty: false,
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
                                  'order_address'.tr(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                AutoSizeText(
                                  orderModel.address,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  color: Theme.of(context).primaryColor,
                                  height: 1,
                                  thickness: .5,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                AutoSizeText(
                                  'floor_number'.tr(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                AutoSizeText(
                                  '${orderModel.floorNumber ?? 'N/A'}',
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
                                  'order_status'.tr(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                AutoSizeText(
                                  orderModel.status != 3 ? orderModel.statusName : 'Finished'.tr(),
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
                                  'Order Type'.tr(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    RadioListTile(
                                        value: 1,
                                        contentPadding: EdgeInsets.zero,
                                        groupValue: ref.watch(
                                            orderModeProvider) ??
                                            1,
                                        onChanged: (value) {
                                          if(orderModel.status < 3){
                                            ref
                                                .read(orderModeProvider
                                                .notifier)
                                                .state = value ?? 1;
                                          }
                                        },
                                        activeColor: Theme.of(context)
                                            .primaryColor,
                                        title: AutoSizeText(
                                          'Reparaturauftrag'.tr(),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    RadioListTile(
                                        value: 2,
                                        groupValue:
                                        ref.watch(orderModeProvider),
                                        contentPadding: EdgeInsets.zero,
                                        onChanged: (value) {
                                          if(orderModel.status < 3){
                                            ref
                                                .read(orderModeProvider
                                                .notifier)
                                                .state = value ?? 2;
                                          }
                                        },
                                        activeColor: Theme.of(context)
                                            .primaryColor,
                                        title: AutoSizeText(
                                          'Rechnung'.tr(),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                    RadioListTile(
                                        value: 3,
                                        contentPadding: EdgeInsets.zero,
                                        groupValue:
                                        ref.watch(orderModeProvider),
                                        onChanged: (value) {
                                          if(orderModel.status < 3){
                                            ref
                                                .read(orderModeProvider
                                                .notifier)
                                                .state = value ?? 3;
                                          }
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
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    RadioListTile(
                                        value: 4,
                                        groupValue:
                                        ref.watch(orderModeProvider),
                                        contentPadding: EdgeInsets.zero,
                                        onChanged: (value) {
                                          if(orderModel.status < 3){
                                            ref
                                                .read(orderModeProvider
                                                .notifier)
                                                .state = value ?? 4;
                                          }
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
                          CustomTextFormField(
                            label: 'brand'.tr(),
                            controller: brand,
                            height: 60,
                            readOnly: orderModel.status > 2,
                            validator: (text) {},
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
                                                if(orderModel.status < 3){
                                                  if (!ref.watch(selectedMachinesProvider).contains(device.id)) {
                                                    ref
                                                        .read(
                                                        selectedMachinesProvider
                                                            .notifier)
                                                        .addMachine(
                                                        machineId: device.id);
                                                  }
                                                  else {
                                                    ref
                                                        .read(
                                                        selectedMachinesProvider
                                                            .notifier)
                                                        .removeMachine(
                                                        machineId: device.id);
                                                  }
                                                }
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
                          CustomTextFormField(
                            label: 'Information'.tr(),
                            controller: information,
                            height: 130,
                            readOnly: orderModel.status > 2,
                            validator: (text) {},
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
                                  'Items'.tr(),
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
                                        3: FlexColumnWidth(1.1),
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
                                                  'Warenbezeichnug'.tr(),
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
                                                  'Price'.tr(),
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
                                            if(orderModel.status < 3)
                                              TableCell(
                                                verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .top,
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(10),
// child: AutoSizeText(
//   'Price'.tr(),
//   style: TextStyle(
//       color: Theme.of(context).primaryColor,
//       fontSize: 15,
//       fontWeight: FontWeight.bold,
//       overflow: TextOverflow.ellipsis
//   ),
// ),
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
                                        3: FlexColumnWidth(1.1),
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
                                            if(orderModel.status < 3)
                                              TableCell(
                                                verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .top,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      ref
                                                          .read(
                                                          orderViewModelProvider
                                                              .notifier)
                                                          .deleteItem(
                                                          orderId:
                                                          orderModel
                                                              .id,
                                                          itemId: e.id);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              5)),
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 10),
                                                      child: const Icon(
                                                        Icons.delete_forever,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      }).toList() ??
                                          [],
                                    ),
                                    Table(
                                      border: TableBorder.all(),
                                      columnWidths: const {
                                        0: FlexColumnWidth(2.8),
                                        1: FlexColumnWidth(1.3),
                                        2: FlexColumnWidth(1.5),
                                        3: FlexColumnWidth(1.1),
                                      },
                                      children: ref
                                          .watch(addedItemsToOrderProvider)
                                          .map((e) {
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
                                            if(orderModel.status < 3)
                                              TableCell(
                                                verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .top,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      ref
                                                          .read(
                                                          addedItemsToOrderProvider
                                                              .notifier)
                                                          .removeItem(
                                                          item: e);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              5)),
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 10),
                                                      child: const Icon(
                                                        Icons.delete_forever,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      }).toList() ??
                                          [],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (orderModel.status < 3)
                                      CustomButton(
                                          onPressed: () {
                                            AwesomeDialog(
                                                context: context,
                                                dialogType:
                                                DialogType.noHeader,
                                                animType:
                                                AnimType.rightSlide,
                                                autoDismiss: false,
                                                dialogBackgroundColor:
                                                Colors.white,
                                                body: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6,
                                                      vertical: 12),
                                                  child:
                                                  SingleChildScrollView(
                                                    child: Form(
                                                      key: _reportFormKey,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              AutoSizeText(
                                                                'Add New Price'.tr(),
                                                                style: TextStyle(
                                                                    color: Theme.of(context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                    17,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    overflow:
                                                                    TextOverflow.ellipsis),
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  icon:
                                                                  Icon(
                                                                    Icons
                                                                        .close,
                                                                    size:
                                                                    30,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade800,
                                                                  ))
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          CustomTextFormField(
                                                              controller:
                                                              title,
                                                              label:
                                                              'Warenbezeichnug'
                                                                  .tr(),
                                                              height: 100,
                                                              validator:
                                                                  (text) {
                                                                if (text?.isEmpty ??
                                                                    true) {
                                                                  return 'this_filed_required'
                                                                      .tr();
                                                                }
                                                                return null;
                                                              }),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          CustomTextFormField(
                                                              controller:
                                                              quantity,
                                                              label: 'Anzahl'
                                                                  .tr(),
                                                              height: 60,
                                                              validator:
                                                                  (text) {
                                                                if (text?.isEmpty ??
                                                                    true) {
                                                                  return 'this_filed_required'
                                                                      .tr();
                                                                }
                                                                return null;
                                                              }),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          CustomTextFormField(
                                                              controller:
                                                              price,
                                                              textInputType:
                                                              TextInputType
                                                                  .number,
                                                              label:
                                                              'Price'
                                                                  .tr(),
                                                              height: 60,
                                                              validator:
                                                                  (text) {
                                                                if (text?.isEmpty ??
                                                                    true) {
                                                                  return 'this_filed_required'
                                                                      .tr();
                                                                }
                                                                return null;
                                                              }),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          CustomButton(
                                                              onPressed:
                                                                  () {
                                                                if (_reportFormKey
                                                                    .currentState
                                                                    ?.validate() ??
                                                                    false) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  // ref.read(orderViewModelProvider.notifier).addItems(orderId: orderModel.id, title: title.text, quantity: quantity.text, price: price.text);
                                                                  ref.read(addedItemsToOrderProvider.notifier).addItem(
                                                                      item: Item(
                                                                          title: title.text,
                                                                          quantity: int.parse(quantity.text),
                                                                          price: double.parse(price.text)
                                                                      ));
                                                                  title.clear();
                                                                  quantity.clear();
                                                                  price.clear();
                                                                }
                                                              },
                                                              text: "Add"
                                                                  .tr(),
                                                              radius: 10,
                                                              height: 50,
                                                              textColor:
                                                              Colors
                                                                  .white,
                                                              bgColor: Theme.of(
                                                                  context)
                                                                  .primaryColor)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onDismissCallback:
                                                    (dismiss) {})
                                                .show();
                                          },
                                          text: 'Add Price'.tr(),
                                          textColor: Colors.white,
                                          radius: 10,
                                          height: 45,
                                          bgColor:
                                          Theme.of(context).primaryColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: double.infinity,
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(8),
                          //       border:
                          //           Border.all(color: const Color(0xffDCDCDC))),
                          //   padding: const EdgeInsets.all(12),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //             child: AutoSizeText(
                          //               '${'Netto Gesamt'.tr()} : ',
                          //               style: TextStyle(
                          //                 fontSize: 13,
                          //                 color: Theme.of(context).primaryColor,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           ),
                          //           Expanded(
                          //             child: AutoSizeText(
                          //               '${orderModel.subtotal ?? 0}',
                          //               style: TextStyle(
                          //                 color: Theme.of(context).primaryColor,
                          //                 fontSize: 15,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //             child: AutoSizeText(
                          //               '${'19% MwSt.'.tr()} : ',
                          //               style: TextStyle(
                          //                 fontSize: 13,
                          //                 color: Theme.of(context).primaryColor,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           ),
                          //           Expanded(
                          //             child: AutoSizeText(
                          //               '${orderModel.vat ?? 0}',
                          //               style: TextStyle(
                          //                 color: Theme.of(context).primaryColor,
                          //                 fontSize: 15,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //             child: AutoSizeText(
                          //               '${'*Endbetrag'.tr()} : ',
                          //               style: TextStyle(
                          //                 fontSize: 13,
                          //                 color: Theme.of(context).primaryColor,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           ),
                          //           Expanded(
                          //             child: AutoSizeText(
                          //               '${orderModel.total ?? 0}',
                          //               style: TextStyle(
                          //                 color: Theme.of(context).primaryColor,
                          //                 fontSize: 15,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(height: 10,),
                          if(ref.watch(orderModeProvider) == 1)
                            Column(
                              children: [
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
                                        'Last updated paid amount €'.tr(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      AutoSizeText(
                                        '${orderModel.paidAmount ?? '0.0'} €',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                CustomTextFormField(
                                  controller: paidAmount,
                                  label: 'Anzahlung in Höhe von €'.tr(),
                                  validator: (text) {},
                                  height: 60,
                                  readOnly: orderModel.status > 2,
                                  textInputType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextFormField(
                                  controller: maxMaintenancePrice,
                                  label: 'Reparatur genehmigt bis €',
                                  validator: (text) {},
                                  height: 60,
                                  readOnly:  orderModel.status > 2,
                                  textInputType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
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
                                  'Order Payment Type'.tr(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    RadioListTile(
                                        value: 1,
                                        contentPadding: EdgeInsets.zero,
                                        groupValue: ref.watch(
                                            orderPaymentModeProvider) ??
                                            1,
                                        onChanged: (value) {
                                          if(orderModel.status < 3){
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
                                    RadioListTile(
                                        value: 2,
                                        contentPadding: EdgeInsets.zero,
                                        groupValue:
                                        ref.watch(orderPaymentModeProvider),
                                        onChanged: (value) {
                                          if(orderModel.status < 3){
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
                                    RadioListTile(
                                        value: 3,
                                        contentPadding: EdgeInsets.zero,
                                        groupValue:
                                        ref.watch(orderPaymentModeProvider),
                                        onChanged: (value) {
                                          if(orderModel.status < 3) {
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
                                        ))
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
                                const SizedBox(
                                  height: 10,
                                ),
                                ref
                                    .watch(getQuestionsViewModelProvider)
                                    .maybeWhen(
                                  loading: () {
                                    return Center(
                                        child: Lottie.asset(
                                            'assets/images/global_loader.json',
                                            height: 50));
                                  },
                                  data: (questions) {
                                    return ListView.builder(
                                        itemCount: questions.length,
                                        shrinkWrap: true,
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final question = questions[index];
                                          return CheckboxListTile(
                                              value: ref
                                                  .watch(
                                                  answeredQuestionsProvider)
                                                  .contains(question.id),
                                              contentPadding: EdgeInsets.zero,
                                              controlAffinity:
                                              ListTileControlAffinity
                                                  .leading,
                                              onChanged: (value) {
                                                if(orderModel.status < 3){
                                                  if (!ref.watch(answeredQuestionsProvider).contains(question.id)) {
                                                    ref
                                                        .read(
                                                        answeredQuestionsProvider
                                                            .notifier)
                                                        .addQuestion(
                                                        questionId:
                                                        question.id);
                                                  }
                                                  else {
                                                    ref
                                                        .read(
                                                        answeredQuestionsProvider
                                                            .notifier)
                                                        .removeQuestion(
                                                        questionId:
                                                        question.id);
                                                  }
                                                }
                                              },
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              title: AutoSizeText(
                                                question.name,
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
                                ),
                                CheckboxListTile(
                                    value: ref.watch(isAmountReceived) ?? false,
                                    contentPadding: EdgeInsets.zero,
                                    controlAffinity:
                                    ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      if(orderModel.status < 3){
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
                                      if(orderModel.status < 3){
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
                                borderRadius:
                                BorderRadius.circular(8),
                                border: Border.all(
                                    color: const Color(0xffDCDCDC))),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_rounded,
                                      color: Theme.of(context)
                                          .primaryColor,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    AutoSizeText(
                                      'Files'.tr(),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: orderModel.status > 2
                                          ? null
                                          : () {
                                        AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.noHeader,
                                            animType: AnimType.rightSlide,
                                            autoDismiss: false,
                                            dialogBackgroundColor: Colors.white,
                                            body: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 6 , vertical:12),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        AutoSizeText(
                                                          'Add Video From'.tr(),
                                                          style: TextStyle(
                                                              color: Theme.of(context).primaryColor,
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.bold,
                                                              overflow: TextOverflow.ellipsis
                                                          ),
                                                        ),
                                                        IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close , color: Colors.grey.shade800,size: 30,))
                                                      ],
                                                    ),
                                                    const SizedBox(height: 20,),
                                                    CustomButton(
                                                        height: 45,
                                                        onPressed: ()async{
                                                          Navigator.pop(context);
                                                          XFile? result =  await ImagePicker().pickVideo(source: ImageSource.camera);

                                                          if (result != null) {
                                                            int size = await result.length();
                                                            if (await result.length() > maxFileSize) {
                                                              final snackBar =
                                                              SnackBar(
                                                                backgroundColor:
                                                                Theme.of(context)
                                                                    .primaryColor,
                                                                showCloseIcon: true,
                                                                behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                                padding:
                                                                EdgeInsets.zero,
                                                                content:
                                                                CustomSnakeBarContent(
                                                                  icon: const Icon(
                                                                    Icons.error,
                                                                    color: Colors.red,
                                                                    size: 25,
                                                                  ),
                                                                  message:
                                                                  'File Size Must Be 10 MB Maximum'
                                                                      .tr(),
                                                                  bgColor: Colors
                                                                      .grey.shade600,
                                                                  borderColor: Colors
                                                                      .redAccent
                                                                      .shade200,
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(
                                                                  context)
                                                                  .showSnackBar(
                                                                  snackBar);
                                                            }
                                                            else {
                                                              if (ref.watch(addedFiles) < 4) {
                                                                ref
                                                                    .read(addedFiles
                                                                    .notifier)
                                                                    .state++;
                                                                ref.read(selectedFilesToUpload.notifier).addFiles(result);
                                                              }
                                                              else {
                                                                final snackBar =
                                                                SnackBar(
                                                                  backgroundColor:
                                                                  Theme.of(
                                                                      context)
                                                                      .primaryColor,
                                                                  showCloseIcon:
                                                                  true,
                                                                  behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                                  padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                                  content:
                                                                  CustomSnakeBarContent(
                                                                    icon:
                                                                    const Icon(
                                                                      Icons.error,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 25,
                                                                    ),
                                                                    message: 'files_maximum'.tr(),
                                                                    bgColor: Colors.grey.shade600,
                                                                    borderColor: Colors.redAccent.shade200,
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              }
                                                            }
                                                          }
                                                        },
                                                        text: 'Camera'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                                                    const SizedBox(height: 20,),
                                                    CustomButton(
                                                        height: 45,
                                                        onPressed: ()async{
                                                          Navigator.pop(context);
                                                          XFile? result =  await ImagePicker().pickVideo(source: ImageSource.gallery);

                                                          if (result != null) {
                                                            if (await result.length() > maxFileSize) {
                                                              final snackBar =
                                                              SnackBar(
                                                                backgroundColor:
                                                                Theme.of(context)
                                                                    .primaryColor,
                                                                showCloseIcon: true,
                                                                behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                                padding:
                                                                EdgeInsets.zero,
                                                                content:
                                                                CustomSnakeBarContent(
                                                                  icon: const Icon(
                                                                    Icons.error,
                                                                    color: Colors.red,
                                                                    size: 25,
                                                                  ),
                                                                  message:
                                                                  'File Size Must Be 10 MB Maximum'
                                                                      .tr(),
                                                                  bgColor: Colors
                                                                      .grey.shade600,
                                                                  borderColor: Colors
                                                                      .redAccent
                                                                      .shade200,
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(
                                                                  context)
                                                                  .showSnackBar(
                                                                  snackBar);
                                                            }
                                                            else {
                                                              if (ref.watch(addedFiles) < 4) {
                                                                ref
                                                                    .read(addedFiles
                                                                    .notifier)
                                                                    .state++;
                                                                ref.read(selectedFilesToUpload.notifier).addFiles(result);
                                                              }
                                                              else {
                                                                final snackBar =
                                                                SnackBar(
                                                                  backgroundColor:
                                                                  Theme.of(
                                                                      context)
                                                                      .primaryColor,
                                                                  showCloseIcon:
                                                                  true,
                                                                  behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                                  padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                                  content:
                                                                  CustomSnakeBarContent(
                                                                    icon:
                                                                    const Icon(
                                                                      Icons.error,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 25,
                                                                    ),
                                                                    message: 'files_maximum'.tr(),
                                                                    bgColor: Colors.grey.shade600,
                                                                    borderColor: Colors.redAccent.shade200,
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              }
                                                            }
                                                          }
                                                        }, text: 'Gallery'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                                                    const SizedBox(height: 20,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onDismissCallback: (dismiss) {})
                                            .show();
                                      },
                                      icon: Icon(
                                        Icons.video_call_rounded,
                                        color: Theme.of(context)
                                            .primaryColor,
                                        size: 35,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: orderModel.status > 2
                                          ? null
                                          : () {
                                        AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.noHeader,
                                            animType: AnimType.rightSlide,
                                            autoDismiss: false,
                                            dialogBackgroundColor: Colors.white,
                                            body: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 6 , vertical:12),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        AutoSizeText(
                                                          'Add Image From'.tr(),
                                                          style: TextStyle(
                                                              color: Theme.of(context).primaryColor,
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.bold,
                                                              overflow: TextOverflow.ellipsis
                                                          ),
                                                        ),
                                                        IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close , color: Colors.grey.shade800,size: 30,))
                                                      ],
                                                    ),
                                                    const SizedBox(height: 20,),
                                                    CustomButton(
                                                        height: 45,
                                                        onPressed: ()async{
                                                          Navigator.pop(context);
                                                          XFile? result =  await ImagePicker().pickImage(source: ImageSource.camera);

                                                          if (result != null) {
                                                            if (await result.length() > maxFileSize) {
                                                              final snackBar =
                                                              SnackBar(
                                                                backgroundColor:
                                                                Theme.of(context)
                                                                    .primaryColor,
                                                                showCloseIcon: true,
                                                                behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                                padding:
                                                                EdgeInsets.zero,
                                                                content:
                                                                CustomSnakeBarContent(
                                                                  icon: const Icon(
                                                                    Icons.error,
                                                                    color: Colors.red,
                                                                    size: 25,
                                                                  ),
                                                                  message:
                                                                  'File Size Must Be 10 MB Maximum'
                                                                      .tr(),
                                                                  bgColor: Colors
                                                                      .grey.shade600,
                                                                  borderColor: Colors
                                                                      .redAccent
                                                                      .shade200,
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(
                                                                  context)
                                                                  .showSnackBar(
                                                                  snackBar);
                                                            }
                                                            else {
                                                              if (ref.watch(addedFiles) < 4) {
                                                                ref
                                                                    .read(addedFiles
                                                                    .notifier)
                                                                    .state++;
                                                                ref.read(selectedFilesToUpload.notifier).addFiles(result);
                                                              }
                                                              else {
                                                                final snackBar =
                                                                SnackBar(
                                                                  backgroundColor:
                                                                  Theme.of(
                                                                      context)
                                                                      .primaryColor,
                                                                  showCloseIcon:
                                                                  true,
                                                                  behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                                  padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                                  content:
                                                                  CustomSnakeBarContent(
                                                                    icon:
                                                                    const Icon(
                                                                      Icons.error,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 25,
                                                                    ),
                                                                    message: 'files_maximum'.tr(),
                                                                    bgColor: Colors.grey.shade600,
                                                                    borderColor: Colors.redAccent.shade200,
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              }
                                                            }
                                                          }
                                                        }, text: 'Camera'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                                                    const SizedBox(height: 20,),
                                                    CustomButton(
                                                        height: 45,
                                                        onPressed: ()async{
                                                          Navigator.pop(context);
                                                          XFile? result =  await ImagePicker().pickImage(source: ImageSource.gallery);

                                                          if (result != null) {
                                                            if (await result.length() > maxFileSize) {
                                                              final snackBar =
                                                              SnackBar(
                                                                backgroundColor:
                                                                Theme.of(context)
                                                                    .primaryColor,
                                                                showCloseIcon: true,
                                                                behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                                padding:
                                                                EdgeInsets.zero,
                                                                content:
                                                                CustomSnakeBarContent(
                                                                  icon: const Icon(
                                                                    Icons.error,
                                                                    color: Colors.red,
                                                                    size: 25,
                                                                  ),
                                                                  message:
                                                                  'File Size Must Be 10 MB Maximum'
                                                                      .tr(),
                                                                  bgColor: Colors
                                                                      .grey.shade600,
                                                                  borderColor: Colors
                                                                      .redAccent
                                                                      .shade200,
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(
                                                                  context)
                                                                  .showSnackBar(
                                                                  snackBar);
                                                            }
                                                            else {
                                                              if (ref.watch(addedFiles) < 4) {
                                                                ref
                                                                    .read(addedFiles
                                                                    .notifier)
                                                                    .state++;
                                                                ref.read(selectedFilesToUpload.notifier).addFiles(result);
                                                              }
                                                              else {
                                                                final snackBar =
                                                                SnackBar(
                                                                  backgroundColor:
                                                                  Theme.of(
                                                                      context)
                                                                      .primaryColor,
                                                                  showCloseIcon:
                                                                  true,
                                                                  behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                                  padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                                  content:
                                                                  CustomSnakeBarContent(
                                                                    icon:
                                                                    const Icon(
                                                                      Icons.error,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 25,
                                                                    ),
                                                                    message: 'files_maximum'.tr(),
                                                                    bgColor: Colors.grey.shade600,
                                                                    borderColor: Colors.redAccent.shade200,
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              }
                                                            }
                                                          }
                                                        }, text: 'Gallery'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                                                    const SizedBox(height: 20,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onDismissCallback: (dismiss) {})
                                            .show();
                                      },
                                      icon: Icon(
                                        Icons.image,
                                        color: Theme.of(context)
                                            .primaryColor,
                                        size: 30,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ListView.builder(
                            itemCount: orderModel.files?.length,
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  margin: const EdgeInsets.all(1),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          '${orderModel.files?[index].fileName}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight.bold,
                                              overflow: TextOverflow
                                                  .ellipsis),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.question,
                                                    animType: AnimType.rightSlide,
                                                    title: 'Delete'.tr(),
                                                    desc: 'are_you_sure_you_want_to_delete'.tr(),
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
                                                        Navigator.pop(context);
                                                        ref.read(orderFilesViewModelProvider.notifier).deleteFile(
                                                            orderId: orderModel.id,
                                                            fileId: orderModel.files?[index].id);
                                                      },
                                                      radius: 10,
                                                      text: 'Yes'.tr(),
                                                      textColor: Colors.white,
                                                      bgColor: Theme.of(context).primaryColor,
                                                      height: 40,
                                                    ),
                                                    onDismissCallback: (dismiss) {})
                                                    .show();
                                              },
                                              icon: Icon(
                                                Icons.delete_rounded,
                                                color:
                                                Theme.of(context)
                                                    .primaryColor,
                                              )),
                                        ],
                                      )
                                    ],
                                  ));
                            },
                          ),
                          ListView.builder(
                            itemCount: ref
                                .watch(selectedFilesToUpload)
                                .length,
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  margin: const EdgeInsets.all(1),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          '${ref.read(selectedFilesToUpload)[index]?.name}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight.bold,
                                              overflow: TextOverflow
                                                  .ellipsis),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                ref.read(addedFiles.notifier).state--;
                                                ref.read(selectedFilesToUpload.notifier).removeFiles(ref.watch(selectedFilesToUpload)[index]);
                                              },
                                              icon: Icon(
                                                Icons.close_rounded,
                                                color:
                                                Theme.of(context)
                                                    .primaryColor,
                                              )),
                                        ],
                                      )
                                    ],
                                  ));
                            },
                          ),
                          if (ref.watch(selectedFilesToUpload).isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 40,
                                  width: screenWidth * 90,
                                  child: CustomButton(
                                    onPressed: () {
                                      ref
                                          .read(orderFilesViewModelProvider
                                          .notifier)
                                          .addFiles(
                                          orderId: orderModel.id,
                                          files: ref.read(
                                              selectedFilesToUpload));
                                    },
                                    text: 'upload'.tr(),
                                    textColor: Colors.white,
                                    bgColor: Theme.of(context)
                                        .primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 10,),
                          if(orderModel.status < 3)
                            CustomButton(
                                onPressed: () {
                                  ref
                                      .watch(orderViewModelProvider.notifier)
                                      .pickUpOrder(
                                      orderId: orderModel.id,
                                      type: ref.read(orderModeProvider) == 1 ? 1 : 2,
                                      brand: brand.text,
                                      orderMode: ref.read(orderModeProvider) ?? 1,
                                      information: information.text,
                                      devices: ref.watch(selectedMachinesProvider),
                                      questions: ref.watch(answeredQuestionsProvider),
                                      items: ref.watch(addedItemsToOrderProvider),
                                      maxMaintenancePrice: double.tryParse(maxMaintenancePrice.text),
                                      paidAmount: double.tryParse(paidAmount.text),
                                      paymentWay: ref.watch(orderPaymentModeProvider) ?? 1,
                                      isAmountReceived: ref.watch(isAmountReceived) ?? false,
                                      isCustomerConfirm: ref.watch(isCustomerConfirm) ?? false
                                  );
                                  paidAmount.clear();
                                },
                                text: 'Update Order'.tr(),
                                textColor: Colors.white,
                                bgColor: Theme.of(context).primaryColor),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                    onPressed: () async {
                                      Uri url = Uri.parse(orderModel.pdfLink);//order pdf file
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    text: 'Show file'.tr(),
                                    textColor: Colors.white,
                                    bgColor: Theme.of(context).primaryColor),
                              ),
                              if(false)
                                Expanded(
                                  child: CustomButton(
                                      onPressed: () {},
                                      text: 'Print file'.tr(),
                                      textColor: Colors.white,
                                      bgColor: Theme.of(context).primaryColor
                                  ),
                                )
                            ],
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
                          if(orderModel.isPickup && orderModel.status < 3)
                            CustomButton(
                                onPressed: () {
                                  if(ref.watch(orderModeProvider) == 1){
                                    ref.read(orderViewModelProvider.notifier).finishPickUpOrder(orderId: orderModel.id , report: report.text , orderMode: ref.read(orderModeProvider) ?? 1 , paymentWay: ref.watch(orderPaymentModeProvider) ?? 1,);
                                  }
                                  else{
                                    ref.read(orderViewModelProvider.notifier).updatePayment(orderId: orderModel.id,paymentWay: ref.watch(orderPaymentModeProvider) ?? 1, report: report.text , isDropOff: false);
                                  }
                                },
                                text: 'Finish Order'.tr(),
                                textColor: Colors.white,
                                bgColor: Theme.of(context).primaryColor
                            ),

                        ],
                      ),
                    );
                  })),
        ),
      ),
    );
  }
}

//::TODO Hide paid amount amd max price when order mode is nor pickup

// class OrderDetailsTechnicianViewOld extends ConsumerWidget {
//   OrderDetailsTechnicianViewOld({super.key ,required this.orderModel,required this.reportFormKey,required this.refreshController ,required this.amount,});
//
//   final OrderModel orderModel;
//
//   final TextEditingController title = TextEditingController();
//   final TextEditingController quantity = TextEditingController();
//   final TextEditingController price = TextEditingController();
//   final TextEditingController amount;
//
//   final GlobalKey<FormState> reportFormKey;
//
//   final RefreshController refreshController;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Expanded(
//       child: SizedBox(
//         width: screenWidth * 95,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SmartRefresher(
//             controller: refreshController,
//             enablePullDown: true,
//             enablePullUp: false,
//             onRefresh: () async {
//               ref
//                   .read(loadOrderViewModelProvider.notifier)
//                   .loadOne(orderId: orderModel.id);
//             },
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                         BorderRadius.circular(8),
//                         border: Border.all(
//                             color:
//                             const Color(0xffDCDCDC))),
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       mainAxisAlignment:
//                       MainAxisAlignment.start,
//                       crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                       children: [
//                         AutoSizeText(
//                           'Order reference'.tr(),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Theme.of(context)
//                                 .primaryColor,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         SelectionArea(
//                           child: AutoSizeText(
//                             orderModel.referenceNo,
//                             style: TextStyle(
//                               color: Theme.of(context)
//                                   .primaryColor,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   CustomerCardNewOrder(
//                     userModel: orderModel.customer,
//                     isOrderDetails: true,
//                     isOnMap: true,
//                     orderPhone: orderModel.orderPhoneNumber,
//                     empty: false,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                         BorderRadius.circular(8),
//                         border: Border.all(
//                             color: const Color(0xffDCDCDC))),
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       mainAxisAlignment:
//                       MainAxisAlignment.start,
//                       crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                       children: [
//                         AutoSizeText(
//                           'order_address'.tr(),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Theme.of(context)
//                                 .primaryColor,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         AutoSizeText(
//                           orderModel.address,
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .primaryColor,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                         BorderRadius.circular(8),
//                         border: Border.all(
//                             color: const Color(0xffDCDCDC))),
//                     padding: const EdgeInsets.all(12),
//                     child: Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment:
//                             MainAxisAlignment.start,
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             children: [
//                               AutoSizeText(
//                                 'floor_number'.tr(),
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Theme.of(context)
//                                       .primaryColor,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               AutoSizeText(
//                                 '${orderModel.floorNumber}',
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .primaryColor,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment:
//                             MainAxisAlignment.start,
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             children: [
//                               AutoSizeText(
//                                 'apartment_number'.tr(),
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Theme.of(context)
//                                       .primaryColor,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               AutoSizeText(
//                                 orderModel.apartmentNumber ??
//                                     'N/A',
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .primaryColor,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                         BorderRadius.circular(8),
//                         border: Border.all(
//                             color: const Color(0xffDCDCDC))),
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       mainAxisAlignment:
//                       MainAxisAlignment.start,
//                       crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                       children: [
//                         AutoSizeText(
//                           'order_status'.tr(),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Theme.of(context)
//                                 .primaryColor,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         AutoSizeText(
//                           orderModel.statusName,
//                           style: TextStyle(
//                             color: Theme.of(context)
//                                 .primaryColor,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                         BorderRadius.circular(8),
//                         border: Border.all(
//                             color: const Color(0xffDCDCDC))),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 8),
//                     child: Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.start,
//                           crossAxisAlignment:
//                           CrossAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.cloud_upload_rounded,
//                               color: Theme.of(context)
//                                   .primaryColor,
//                               size: 30,
//                             ),
//                             const SizedBox(
//                               width: 15,
//                             ),
//                             AutoSizeText(
//                               'Files'.tr(),
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .primaryColor,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             )
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               onPressed: orderModel.status == 3
//                                   ? null
//                                   : () {
//                                 AwesomeDialog(
//                                     context: context,
//                                     dialogType: DialogType.noHeader,
//                                     animType: AnimType.rightSlide,
//                                     autoDismiss: false,
//                                     dialogBackgroundColor: Colors.white,
//                                     body: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 6 , vertical:12),
//                                       child: SingleChildScrollView(
//                                         child: Form(
//                                           key: reportFormKey,
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   AutoSizeText(
//                                                     'Add Video From'.tr(),
//                                                     style: TextStyle(
//                                                         color: Theme.of(context).primaryColor,
//                                                         fontSize: 17,
//                                                         fontWeight: FontWeight.bold,
//                                                         overflow: TextOverflow.ellipsis
//                                                     ),
//                                                   ),
//                                                   IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close , color: Colors.grey.shade800,size: 30,))
//                                                 ],
//                                               ),
//                                               const SizedBox(height: 20,),
//                                               CustomButton(
//                                                   height: 45,
//                                                   onPressed: ()async{
//                                                     Navigator.pop(context);
//                                                     XFile? result =  await ImagePicker().pickVideo(source: ImageSource.camera);
//
//                                                     if (result != null) {
//                                                       int size = await result.length();
//                                                       if (await result.length() > maxFileSize) {
//                                                         final snackBar =
//                                                         SnackBar(
//                                                           backgroundColor:
//                                                           Theme.of(context)
//                                                               .primaryColor,
//                                                           showCloseIcon: true,
//                                                           behavior:
//                                                           SnackBarBehavior
//                                                               .floating,
//                                                           padding:
//                                                           EdgeInsets.zero,
//                                                           content:
//                                                           CustomSnakeBarContent(
//                                                             icon: const Icon(
//                                                               Icons.error,
//                                                               color: Colors.red,
//                                                               size: 25,
//                                                             ),
//                                                             message:
//                                                             'File Size Must Be 10 MB Maximum'
//                                                                 .tr(),
//                                                             bgColor: Colors
//                                                                 .grey.shade600,
//                                                             borderColor: Colors
//                                                                 .redAccent
//                                                                 .shade200,
//                                                           ),
//                                                         );
//                                                         ScaffoldMessenger.of(
//                                                             context)
//                                                             .showSnackBar(
//                                                             snackBar);
//                                                       }
//                                                       else {
//                                                         if (ref.watch(addedFiles) < 4) {
//                                                           ref
//                                                               .read(addedFiles
//                                                               .notifier)
//                                                               .state++;
//                                                           ref.read(selectedFilesToUpload.notifier).addFiles(result);
//                                                         }
//                                                         else {
//                                                           final snackBar =
//                                                           SnackBar(
//                                                             backgroundColor:
//                                                             Theme.of(
//                                                                 context)
//                                                                 .primaryColor,
//                                                             showCloseIcon:
//                                                             true,
//                                                             behavior:
//                                                             SnackBarBehavior
//                                                                 .floating,
//                                                             padding:
//                                                             EdgeInsets
//                                                                 .zero,
//                                                             content:
//                                                             CustomSnakeBarContent(
//                                                               icon:
//                                                               const Icon(
//                                                                 Icons.error,
//                                                                 color: Colors
//                                                                     .red,
//                                                                 size: 25,
//                                                               ),
//                                                               message: 'files_maximum'.tr(),
//                                                               bgColor: Colors.grey.shade600,
//                                                               borderColor: Colors.redAccent.shade200,
//                                                             ),
//                                                           );
//                                                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                                                         }
//                                                       }
//                                                     }
//                                                   },
//                                                   text: 'Camera'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
//                                               const SizedBox(height: 20,),
//                                               CustomButton(
//                                                   height: 45,
//                                                   onPressed: ()async{
//                                                     Navigator.pop(context);
//                                                     XFile? result =  await ImagePicker().pickVideo(source: ImageSource.gallery);
//
//                                                     if (result != null) {
//                                                       if (await result.length() > maxFileSize) {
//                                                         final snackBar =
//                                                         SnackBar(
//                                                           backgroundColor:
//                                                           Theme.of(context)
//                                                               .primaryColor,
//                                                           showCloseIcon: true,
//                                                           behavior:
//                                                           SnackBarBehavior
//                                                               .floating,
//                                                           padding:
//                                                           EdgeInsets.zero,
//                                                           content:
//                                                           CustomSnakeBarContent(
//                                                             icon: const Icon(
//                                                               Icons.error,
//                                                               color: Colors.red,
//                                                               size: 25,
//                                                             ),
//                                                             message:
//                                                             'File Size Must Be 10 MB Maximum'
//                                                                 .tr(),
//                                                             bgColor: Colors
//                                                                 .grey.shade600,
//                                                             borderColor: Colors
//                                                                 .redAccent
//                                                                 .shade200,
//                                                           ),
//                                                         );
//                                                         ScaffoldMessenger.of(
//                                                             context)
//                                                             .showSnackBar(
//                                                             snackBar);
//                                                       }
//                                                       else {
//                                                         if (ref.watch(addedFiles) < 4) {
//                                                           ref
//                                                               .read(addedFiles
//                                                               .notifier)
//                                                               .state++;
//                                                           ref.read(selectedFilesToUpload.notifier).addFiles(result);
//                                                         }
//                                                         else {
//                                                           final snackBar =
//                                                           SnackBar(
//                                                             backgroundColor:
//                                                             Theme.of(
//                                                                 context)
//                                                                 .primaryColor,
//                                                             showCloseIcon:
//                                                             true,
//                                                             behavior:
//                                                             SnackBarBehavior
//                                                                 .floating,
//                                                             padding:
//                                                             EdgeInsets
//                                                                 .zero,
//                                                             content:
//                                                             CustomSnakeBarContent(
//                                                               icon:
//                                                               const Icon(
//                                                                 Icons.error,
//                                                                 color: Colors
//                                                                     .red,
//                                                                 size: 25,
//                                                               ),
//                                                               message: 'files_maximum'.tr(),
//                                                               bgColor: Colors.grey.shade600,
//                                                               borderColor: Colors.redAccent.shade200,
//                                                             ),
//                                                           );
//                                                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                                                         }
//                                                       }
//                                                     }
//                                                   }, text: 'Gallery'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
//                                               const SizedBox(height: 20,),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     onDismissCallback: (dismiss) {})
//                                     .show();
//                               },
//                               icon: Icon(
//                                 Icons.video_call_rounded,
//                                 color: Theme.of(context)
//                                     .primaryColor,
//                                 size: 35,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: orderModel.status == 3
//                                   ? null
//                                   : () {
//                                 AwesomeDialog(
//                                     context: context,
//                                     dialogType: DialogType.noHeader,
//                                     animType: AnimType.rightSlide,
//                                     autoDismiss: false,
//                                     dialogBackgroundColor: Colors.white,
//                                     body: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 6 , vertical:12),
//                                       child: SingleChildScrollView(
//                                         child: Form(
//                                           key: reportFormKey,
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   AutoSizeText(
//                                                     'Add Image From'.tr(),
//                                                     style: TextStyle(
//                                                         color: Theme.of(context).primaryColor,
//                                                         fontSize: 17,
//                                                         fontWeight: FontWeight.bold,
//                                                         overflow: TextOverflow.ellipsis
//                                                     ),
//                                                   ),
//                                                   IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close , color: Colors.grey.shade800,size: 30,))
//                                                 ],
//                                               ),
//                                               const SizedBox(height: 20,),
//                                               CustomButton(
//                                                   height: 45,
//                                                   onPressed: ()async{
//                                                     Navigator.pop(context);
//                                                     XFile? result =  await ImagePicker().pickImage(source: ImageSource.camera);
//
//                                                     if (result != null) {
//                                                       if (await result.length() > maxFileSize) {
//                                                         final snackBar =
//                                                         SnackBar(
//                                                           backgroundColor:
//                                                           Theme.of(context)
//                                                               .primaryColor,
//                                                           showCloseIcon: true,
//                                                           behavior:
//                                                           SnackBarBehavior
//                                                               .floating,
//                                                           padding:
//                                                           EdgeInsets.zero,
//                                                           content:
//                                                           CustomSnakeBarContent(
//                                                             icon: const Icon(
//                                                               Icons.error,
//                                                               color: Colors.red,
//                                                               size: 25,
//                                                             ),
//                                                             message:
//                                                             'File Size Must Be 10 MB Maximum'
//                                                                 .tr(),
//                                                             bgColor: Colors
//                                                                 .grey.shade600,
//                                                             borderColor: Colors
//                                                                 .redAccent
//                                                                 .shade200,
//                                                           ),
//                                                         );
//                                                         ScaffoldMessenger.of(
//                                                             context)
//                                                             .showSnackBar(
//                                                             snackBar);
//                                                       }
//                                                       else {
//                                                         if (ref.watch(addedFiles) < 4) {
//                                                           ref
//                                                               .read(addedFiles
//                                                               .notifier)
//                                                               .state++;
//                                                           ref.read(selectedFilesToUpload.notifier).addFiles(result);
//                                                         }
//                                                         else {
//                                                           final snackBar =
//                                                           SnackBar(
//                                                             backgroundColor:
//                                                             Theme.of(
//                                                                 context)
//                                                                 .primaryColor,
//                                                             showCloseIcon:
//                                                             true,
//                                                             behavior:
//                                                             SnackBarBehavior
//                                                                 .floating,
//                                                             padding:
//                                                             EdgeInsets
//                                                                 .zero,
//                                                             content:
//                                                             CustomSnakeBarContent(
//                                                               icon:
//                                                               const Icon(
//                                                                 Icons.error,
//                                                                 color: Colors
//                                                                     .red,
//                                                                 size: 25,
//                                                               ),
//                                                               message: 'files_maximum'.tr(),
//                                                               bgColor: Colors.grey.shade600,
//                                                               borderColor: Colors.redAccent.shade200,
//                                                             ),
//                                                           );
//                                                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                                                         }
//                                                       }
//                                                     }
//                                                   }, text: 'Camera'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
//                                               const SizedBox(height: 20,),
//                                               CustomButton(
//                                                   height: 45,
//                                                   onPressed: ()async{
//                                                     Navigator.pop(context);
//                                                     XFile? result =  await ImagePicker().pickImage(source: ImageSource.gallery);
//
//                                                     if (result != null) {
//                                                       if (await result.length() > maxFileSize) {
//                                                         final snackBar =
//                                                         SnackBar(
//                                                           backgroundColor:
//                                                           Theme.of(context)
//                                                               .primaryColor,
//                                                           showCloseIcon: true,
//                                                           behavior:
//                                                           SnackBarBehavior
//                                                               .floating,
//                                                           padding:
//                                                           EdgeInsets.zero,
//                                                           content:
//                                                           CustomSnakeBarContent(
//                                                             icon: const Icon(
//                                                               Icons.error,
//                                                               color: Colors.red,
//                                                               size: 25,
//                                                             ),
//                                                             message:
//                                                             'File Size Must Be 10 MB Maximum'
//                                                                 .tr(),
//                                                             bgColor: Colors
//                                                                 .grey.shade600,
//                                                             borderColor: Colors
//                                                                 .redAccent
//                                                                 .shade200,
//                                                           ),
//                                                         );
//                                                         ScaffoldMessenger.of(
//                                                             context)
//                                                             .showSnackBar(
//                                                             snackBar);
//                                                       }
//                                                       else {
//                                                         if (ref.watch(addedFiles) < 4) {
//                                                           ref
//                                                               .read(addedFiles
//                                                               .notifier)
//                                                               .state++;
//                                                           ref.read(selectedFilesToUpload.notifier).addFiles(result);
//                                                         }
//                                                         else {
//                                                           final snackBar =
//                                                           SnackBar(
//                                                             backgroundColor:
//                                                             Theme.of(
//                                                                 context)
//                                                                 .primaryColor,
//                                                             showCloseIcon:
//                                                             true,
//                                                             behavior:
//                                                             SnackBarBehavior
//                                                                 .floating,
//                                                             padding:
//                                                             EdgeInsets
//                                                                 .zero,
//                                                             content:
//                                                             CustomSnakeBarContent(
//                                                               icon:
//                                                               const Icon(
//                                                                 Icons.error,
//                                                                 color: Colors
//                                                                     .red,
//                                                                 size: 25,
//                                                               ),
//                                                               message: 'files_maximum'.tr(),
//                                                               bgColor: Colors.grey.shade600,
//                                                               borderColor: Colors.redAccent.shade200,
//                                                             ),
//                                                           );
//                                                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                                                         }
//                                                       }
//                                                     }
//                                                   }, text: 'Gallery'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
//                                               const SizedBox(height: 20,),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     onDismissCallback: (dismiss) {})
//                                     .show();
//                               },
//                               icon: Icon(
//                                 Icons.image,
//                                 color: Theme.of(context)
//                                     .primaryColor,
//                                 size: 30,
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   ListView.builder(
//                     itemCount: orderModel.files?.length,
//                     shrinkWrap: true,
//                     physics:
//                     const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return Container(
//                           height: 40,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 5),
//                           margin: const EdgeInsets.all(1),
//                           child: Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment
//                                 .spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: AutoSizeText(
//                                   '${orderModel.files?[index].fileName}',
//                                   style: TextStyle(
//                                       color: Theme.of(context)
//                                           .primaryColor,
//                                       fontSize: 15,
//                                       fontWeight:
//                                       FontWeight.bold,
//                                       overflow: TextOverflow
//                                           .ellipsis),
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                       onPressed: () {
//                                         AwesomeDialog(
//                                             context: context,
//                                             dialogType: DialogType.question,
//                                             animType: AnimType.rightSlide,
//                                             title: 'Delete'.tr(),
//                                             desc: 'are_you_sure_you_want_to_delete'.tr(),
//                                             autoDismiss: false,
//                                             dialogBackgroundColor: Colors.white,
//                                             btnCancel: CustomButton(
//                                               onPressed: () {
//                                                 Navigator.of(context).pop();
//                                               },
//                                               radius: 10,
//                                               text: 'No'.tr(),
//                                               textColor: Colors.white,
//                                               bgColor: const Color(0xffd63d46),
//                                               height: 40,
//                                             ),
//                                             btnOk: CustomButton(
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                                 ref.read(orderViewModelProvider.notifier).deleteFile(
//                                                     id: orderModel.id,
//                                                     fileId: orderModel.files?[index].id);
//                                               },
//                                               radius: 10,
//                                               text: 'Yes'.tr(),
//                                               textColor: Colors.white,
//                                               bgColor: Theme.of(context).primaryColor,
//                                               height: 40,
//                                             ),
//                                             onDismissCallback: (dismiss) {})
//                                             .show();
//                                       },
//                                       icon: Icon(
//                                         Icons.delete_rounded,
//                                         color:
//                                         Theme.of(context)
//                                             .primaryColor,
//                                       )),
//                                 ],
//                               )
//                             ],
//                           ));
//                     },
//                   ),
//                   ListView.builder(
//                     itemCount: ref
//                         .watch(selectedFilesToUpload)
//                         .length,
//                     shrinkWrap: true,
//                     physics:
//                     const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return Container(
//                           height: 40,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 5),
//                           margin: const EdgeInsets.all(1),
//                           child: Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment
//                                 .spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: AutoSizeText(
//                                   '${ref.read(selectedFilesToUpload)[index]?.name}',
//                                   style: TextStyle(
//                                       color: Theme.of(context)
//                                           .primaryColor,
//                                       fontSize: 15,
//                                       fontWeight:
//                                       FontWeight.bold,
//                                       overflow: TextOverflow
//                                           .ellipsis),
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                       onPressed: () {
//                                         ref.read(addedFiles.notifier).state--;
//                                         ref.read(selectedFilesToUpload.notifier).removeFiles(ref.watch(selectedFilesToUpload)[index]);
//                                       },
//                                       icon: Icon(
//                                         Icons.close_rounded,
//                                         color:
//                                         Theme.of(context)
//                                             .primaryColor,
//                                       )),
//                                 ],
//                               )
//                             ],
//                           ));
//                     },
//                   ),
//                   if (ref.watch(selectedFilesToUpload).isNotEmpty)
//                     Column(
//                       children: [
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         SizedBox(
//                           height: 40,
//                           width: screenWidth * 70,
//                           child: CustomButton(
//                             onPressed: () {
//                               ref
//                                   .read(orderViewModelProvider
//                                   .notifier)
//                                   .addFiles(
//                                   id: orderModel.id,
//                                   files: ref.read(
//                                       selectedFilesToUpload));
//                             },
//                             text: 'upload'.tr(),
//                             textColor: Colors.white,
//                             bgColor: Theme.of(context)
//                                 .primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   const SizedBox(height: 5,),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                         BorderRadius.circular(8),
//                         border: Border.all(
//                             color: const Color(0xffDCDCDC))),
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       mainAxisAlignment:
//                       MainAxisAlignment.start,
//                       crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                       children: [
//                         AutoSizeText(
//                           'Order Type'.tr(),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Theme.of(context)
//                                 .primaryColor,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         AutoSizeText(
//                           orderModel.type == 1 ? 'Pick-Up'.tr() : (orderModel.type == 2 ? 'On-Site'.tr() : 'Drop-Off'.tr()),
//                           style: TextStyle(color: Theme.of(context).primaryColor,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   if(orderModel.type != 3 && !orderModel.isPaid)
//                     Column(
//                       children: [
//                         const SizedBox(height: 5,),
//                         //Order Type
//                         Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius:
//                               BorderRadius.circular(8),
//                               border: Border.all(
//                                   color:
//                                   const Color(0xffDCDCDC))),
//                           padding: const EdgeInsets.all(12),
//                           child: Column(
//                             mainAxisAlignment:
//                             MainAxisAlignment.start,
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             children: [
//                               AutoSizeText(
//                                 'Change Order Type'.tr(),
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Theme.of(context)
//                                       .primaryColor,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   RadioListTile(
//                                       value: 1,
//                                       groupValue: ref.watch(orderType),
//                                       onChanged: (value) {
//                                         if(orderModel.status != 3){
//                                           ref.read(orderType.notifier).state = value ?? 1;
//                                         }
//                                       },
//                                       activeColor: Theme.of(context).primaryColor,
//                                       title: AutoSizeText(
//                                         'Pick-Up'.tr(),
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       )
//                                   ),
//                                   RadioListTile(
//                                       value: 2,
//                                       groupValue: ref.watch(orderType),
//                                       onChanged: (value) {
//                                         if(orderModel.status != 3){
//                                           ref.read(orderType.notifier).state = value ?? 2;
//                                         }
//                                       },
//                                       activeColor: Theme.of(context).primaryColor,
//                                       title: AutoSizeText(
//                                         'On-Site'.tr(),
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .primaryColor,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       )
//                                   ),
//                                   const SizedBox(height: 5,),
//                                   SizedBox(
//                                     width: screenWidth * 70,
//                                     height: 45,
//                                     child: CustomButton(
//                                       onPressed: (){
//                                         AwesomeDialog(
//                                             context: context,
//                                             dialogType: DialogType.question,
//                                             animType: AnimType.rightSlide,
//                                             title: 'Order Type'.tr(),
//                                             desc: ref.watch(orderType) == 1
//                                                 ? 'Are you sure you want to update order type to be Pick-Up order'.tr()
//                                                 : 'Are you sure you want to update order type to be On-Site order you will need to complete payment process to finish this order'.tr(),
//                                             autoDismiss: false,
//                                             dialogBackgroundColor: Colors.white,
//                                             btnCancel: CustomButton(
//                                               onPressed: () {
//                                                 Navigator.of(context).pop();
//                                               },
//                                               radius: 10,
//                                               text: 'No'.tr(),
//                                               textColor: Colors.white,
//                                               bgColor: const Color(0xffd63d46),
//                                               height: 40,
//                                             ),
//                                             btnOk: CustomButton(
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                                 ref.read(orderViewModelProvider.notifier).updateOrderType(orderId: orderModel.id, type: ref.read(orderType));
//                                               },
//                                               radius: 10,
//                                               text: 'Yes'.tr(),
//                                               textColor: Colors.white,
//                                               bgColor: Theme.of(context).primaryColor,
//                                               height: 40,
//                                             ),
//                                             onDismissCallback: (dismiss) {})
//                                             .show();
//                                       },
//                                       text: 'Update Order Type'.tr(),
//                                       textColor: Colors.white,
//                                       bgColor: Theme.of(context).primaryColor,
//                                       radius: 10,
//                                     ),
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Column(
//                     children: [
//                       if((orderModel.items ?? []).isNotEmpty)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AutoSizeText(
//                               'Reports'.tr(),
//                               style: TextStyle(
//                                   color: Theme.of(context).primaryColor,
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold,
//                                   overflow: TextOverflow.ellipsis
//                               ),
//                             ),
//                             const SizedBox(height: 10,),
//                             Table(
//                               border: TableBorder.all(),
//                               children: [
//                                 TableRow(
//                                   children: <Widget>[
//                                     TableCell(
//                                       verticalAlignment: TableCellVerticalAlignment.top,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         color: Colors.grey[200],
//                                         child: AutoSizeText(
//                                           'Title'.tr(),
//                                           style: TextStyle(
//                                               color: Theme.of(context).primaryColor,
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold,
//                                               overflow: TextOverflow.ellipsis
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       verticalAlignment: TableCellVerticalAlignment.top,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         color: Colors.grey[200],
//                                         child: AutoSizeText(
//                                           'Description'.tr(),
//                                           style: TextStyle(
//                                               color: Theme.of(context).primaryColor,
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold,
//                                               overflow: TextOverflow.ellipsis
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       verticalAlignment: TableCellVerticalAlignment.top,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         color: Colors.grey[200],
//                                         child: AutoSizeText(
//                                           'Price'.tr(),
//                                           style: TextStyle(
//                                               color: Theme.of(context).primaryColor,
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold,
//                                               overflow: TextOverflow.ellipsis
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Table(
//                               border: TableBorder.all(),
//                               children: orderModel.items?.map((e) {
//                                 return TableRow(
//                                   children: <Widget>[
//                                     TableCell(
//                                       verticalAlignment: TableCellVerticalAlignment.top,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         child: AutoSizeText(
//                                           e.title,
//                                           style: TextStyle(
//                                             color: Theme.of(context).primaryColor,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       verticalAlignment: TableCellVerticalAlignment.top,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         child: AutoSizeText(
//                                           '${e.quantity}',
//                                           style: TextStyle(
//                                             color: Theme.of(context).primaryColor,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       verticalAlignment: TableCellVerticalAlignment.top,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         child: AutoSizeText(
//                                           '${e.price}',
//                                           style: TextStyle(
//                                               color: Theme.of(context).primaryColor,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               overflow: TextOverflow.ellipsis
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }).toList() ?? [],
//                             ),
//                             const SizedBox(height: 10,),
//                           ],
//                         ),
//                       if(orderModel.status != 3)
//                         CustomButton(
//                             onPressed: (){
//                               AwesomeDialog(
//                                   context: context,
//                                   dialogType: DialogType.noHeader,
//                                   animType: AnimType.rightSlide,
//                                   autoDismiss: false,
//                                   dialogBackgroundColor: Colors.white,
//                                   body: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 6 , vertical:12),
//                                     child: SingleChildScrollView(
//                                       child: Form(
//                                         key: reportFormKey,
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 AutoSizeText(
//                                                   'Add New Report'.tr(),
//                                                   style: TextStyle(
//                                                       color: Theme.of(context).primaryColor,
//                                                       fontSize: 17,
//                                                       fontWeight: FontWeight.bold,
//                                                       overflow: TextOverflow.ellipsis
//                                                   ),
//                                                 ),
//                                                 IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close , size: 30, color: Colors.grey.shade800,))
//                                               ],
//                                             ),
//                                             const SizedBox(height: 20,),
//                                             CustomTextFormField(
//                                                 controller: title,
//                                                 label: 'Title'.tr(),
//                                                 height: 60,
//                                                 validator: (text){
//                                                   if(text?.isEmpty ?? true){
//                                                     return 'this_filed_required'.tr();
//                                                   }
//                                                   return null;
//                                                 }),
//                                             const SizedBox(height: 10,),
//                                             CustomTextFormField(
//                                                 controller: quantity,
//                                                 label: 'Description'.tr(),
//                                                 height: 100,
//                                                 validator: (text){
//                                                   if(text?.isEmpty ?? true){
//                                                     return 'this_filed_required'.tr();
//                                                   }
//                                                   return null;
//                                                 }),
//                                             const SizedBox(height: 10,),
//                                             CustomTextFormField(
//                                                 controller: price,
//                                                 textInputType: TextInputType.number,
//                                                 label: 'Price'.tr(),
//                                                 height: 60,
//                                                 validator: (text){
//                                                   if(text?.isEmpty ?? true){
//                                                     return 'this_filed_required'.tr();
//                                                   }
//                                                   return null;
//                                                 }),
//                                             const SizedBox(height: 20,),
//                                             CustomButton(onPressed: (){
//                                               if(reportFormKey.currentState?.validate() ?? false){
//                                                 Navigator.pop(context);
//                                                 ref.read(orderViewModelProvider.notifier).addItems(id: orderModel.id, title: title.text, quantity: quantity.text, price: price.text);
//                                               }
//                                             }, text: "Add".tr(),radius: 10, height: 50, textColor: Colors.white, bgColor: Theme.of(context).primaryColor)
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   onDismissCallback: (dismiss) {})
//                                   .show();
//                             },
//                             text: 'Add Report',
//                             textColor: Colors.white,
//                             radius: 10,
//                             height: 45,
//                             bgColor: Theme.of(context).primaryColor
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 10,),
//                   if (orderModel.amount == 0)
//                     Column(
//                       children: [
//                         CustomTextFormField(
//                           label: 'New amount'.tr(),
//                           validator: (text) {
//                           },
//                           controller: amount,
//                           textInputType: TextInputType.number,
//                         ),
//                         const SizedBox(height: 10,),
//                         SizedBox(
//                           height: 45,
//                           width: screenWidth * 90,
//                           child: CustomButton(
//                             onPressed: () {
//                               if (amount.text.isNotEmpty) {
//                                 ref
//                                     .read(orderViewModelProvider
//                                     .notifier)
//                                     .updateAmount(
//                                     orderId: orderModel.id,
//                                     amount: amount.text);
//                               }
//                             },
//                             text: 'Update amount'.tr(),
//                             textColor: Colors.white,
//                             bgColor: Theme.of(context).primaryColor,
//                             radius: 10,
//                           ),
//                         )
//                       ],
//                     )
//                   else
//                     Column(
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius:
//                               BorderRadius.circular(8),
//                               border: Border.all(
//                                   color: const Color(
//                                       0xffDCDCDC))),
//                           padding: const EdgeInsets.all(12),
//                           child: Column(
//                             mainAxisAlignment:
//                             MainAxisAlignment.start,
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             children: [
//                               AutoSizeText(
//                                 'last_updated_amount'.tr(),
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Theme.of(context)
//                                       .primaryColor,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               AutoSizeText(
//                                 '${orderModel.amount}',
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .primaryColor,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         if (orderModel.isPaid == false && orderModel.status != 3)
//                           Column(
//                             children: [
//                               CustomTextFormField(
//                                 label: 'New amount'.tr(),
//                                 validator: (text) {},
//                                 controller: amount,
//                                 textInputType: TextInputType.number,
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               SizedBox(
//                                 height: 45,
//                                 width: screenWidth * 90,
//                                 child: CustomButton(
//                                   onPressed: () {
//                                     if (amount
//                                         .text.isNotEmpty) {
//                                       ref
//                                           .read(
//                                           orderViewModelProvider
//                                               .notifier)
//                                           .updateAmount(
//                                           orderId: orderModel.id,
//                                           amount:
//                                           amount.text);
//                                     }
//                                   },
//                                   text: 'Update amount'.tr(),
//                                   textColor: Colors.white,
//                                   bgColor: Theme.of(context).primaryColor,
//                                   radius: 10,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                             ],
//                           )
//                       ],
//                     ),
//                   if(orderModel.isPaid)
//                     Column(
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius:
//                               BorderRadius.circular(8),
//                               border: Border.all(
//                                   color: const Color(
//                                       0xffDCDCDC))),
//                           padding: const EdgeInsets.all(12),
//                           child: Column(
//                             mainAxisAlignment:
//                             MainAxisAlignment.start,
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             children: [
//                               AutoSizeText(
//                                 'payment_status'.tr(),
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Theme.of(context)
//                                       .primaryColor,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               AutoSizeText(
//                                 'paid'.tr(),
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .primaryColor,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ) ,
//                         const SizedBox(height: 10,),
//                       ],
//                     ),
//                   if(orderModel.amount != 0)
//                     Column(
//                       children: [
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomButton(
//                                 onPressed: () {
//                                   ref.read(orderViewModelProvider.notifier).sendInvoice(orderId: orderModel.id);
//                                 },
//                                 text: 'Send invoice'.tr(),
//                                 textColor: Colors.white,
//                                 bgColor: Theme.of(context).primaryColor,
//                                 radius: 10,
//                               ),
//                             ),
//                             const SizedBox(width: 5,),
//                             Expanded(
//                               child: CustomButton(
//                                 onPressed: () async {
//                                   Uri url = Uri.parse(orderModel.pdfLink);//order pdf file
//                                   if (await canLaunchUrl(url)) {
//                                     await launchUrl(url);
//                                   } else {
//                                     throw 'Could not launch $url';
//                                   }
//                                 },
//                                 text: 'Show invoice'.tr(),
//                                 textColor: Colors.white,
//                                 bgColor: Theme.of(context).primaryColor,
//                                 radius: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                   (() {
//                     if(orderModel.status == 3 && orderModel.isPaid){
//                       return Container();
//                     }
//                     else{
//                       if((orderModel.type == 1 && orderModel.amount != 0 && orderModel.status != 3))
//                       {
//                         return Column(
//                           children: [
//                             SizedBox(
//                               height: 50,
//                               child: CustomButton(
//                                 onPressed: () async {
//                                   ref.read(orderViewModelProvider.notifier).finishOrder(orderId: orderModel.id, isPayLater: false);
//                                 },
//                                 text: 'finish_order'.tr(),
//                                 textColor: Colors.white,
//                                 bgColor: Theme.of(context).primaryColor,
//                                 radius: 10,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                           ],
//                         );
//                       }
//                       else if ((orderModel.type == 2 || orderModel.type == 3) && orderModel.amount != 0)
//                       {
//                         if(orderModel.isPaid){
//                           return Column(
//                             children: [
//                               SizedBox(
//                                 height: 50,
//                                 child: CustomButton(
//                                   onPressed: () async {
//                                     ref.read(orderViewModelProvider.notifier).finishOrder(orderId: orderModel.id, isPayLater: false);
//                                   },
//                                   text: 'finish_order'.tr(),
//                                   textColor: Colors.white,
//                                   bgColor: Theme.of(context).primaryColor,
//                                   radius: 10,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                             ],
//                           );
//                         }
//                         else if (!orderModel.isPaid && orderModel.status == 3){
//                           return Container();
//                         }
//                         else{
//                           return Column(
//                             children: [
//                               SizedBox(
//                                 height: 50,
//                                 child: CheckboxListTile(
//                                   value: ref.watch(selectPayLater),
//                                   activeColor: Theme.of(context)
//                                       .primaryColor,
//                                   onChanged: (value) {
//                                     ref
//                                         .read(
//                                         selectPayLater.notifier)
//                                         .state = value ?? false;
//                                   },
//                                   controlAffinity:
//                                   ListTileControlAffinity
//                                       .leading,
//                                   title: AutoSizeText(
//                                     'pay_later'.tr(),
//                                     style: TextStyle(
//                                         color: Theme.of(context)
//                                             .primaryColor,
//                                         fontWeight:
//                                         FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               if(ref.watch(selectPayLater))
//                                 Column(
//                                   children: [
//                                     SizedBox(
//                                       height: 50,
//                                       child: CustomButton(
//                                         onPressed: () async {
//                                           ref.read(orderViewModelProvider.notifier).finishOrder(orderId: orderModel.id, isPayLater: true);
//                                         },
//                                         text: 'finish_order'.tr(),
//                                         textColor: Colors.white,
//                                         bgColor: Theme.of(context).primaryColor,
//                                         radius: 10,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                   ],
//                                 )
//                               else
//                                 Column(
//                                   children: [
//                                     SizedBox(
//                                       height: 50,
//                                       child: CheckboxListTile(
//                                         value: ref.watch(selectPayCash) ??
//                                             false,
//                                         activeColor: Theme.of(context)
//                                             .primaryColor,
//                                         onChanged: (value) {
//                                           ref
//                                               .read(
//                                               selectPayCash.notifier)
//                                               .state = value;
//                                         },
//                                         controlAffinity:
//                                         ListTileControlAffinity
//                                             .leading,
//                                         title: AutoSizeText(
//                                           'pay_cash'.tr(),
//                                           style: TextStyle(
//                                               color: Theme.of(context)
//                                                   .primaryColor,
//                                               fontWeight:
//                                               FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     SizedBox(
//                                       height: orderModel.status == 3 ? 0 : 45,
//                                       child: ref.watch(paymentLoadingProvider)
//                                           ? Lottie.asset(
//                                           'assets/images/global_loader.json',
//                                           height: 45)
//                                           : CustomButton(
//                                         onPressed:
//                                         orderModel.amount != null
//                                             ? () async {
//                                           if (orderModel
//                                               .isPaid) {
//                                             if (reportFormKey
//                                                 .currentState
//                                                 ?.validate() ??
//                                                 false) {
//                                               ref
//                                                   .read(orderViewModelProvider
//                                                   .notifier)
//                                                   .finishOrder(
//                                                   orderId:
//                                                   orderModel.id,
//                                                   isPayLater: false);
//                                             }
//                                           } else {
//                                             if (ref.watch(selectPayCash) == true) {//sure_you_get_the_payment_cash
//                                               AwesomeDialog(
//                                                   context: context,
//                                                   dialogType: DialogType.question,
//                                                   animType: AnimType.rightSlide,
//                                                   title: 'Payment'.tr(),
//                                                   desc: 'sure_you_get_the_payment_cash'.tr(),
//                                                   autoDismiss: false,
//                                                   dialogBackgroundColor: Colors.white,
//                                                   btnCancel: CustomButton(
//                                                     onPressed: () {
//                                                       Navigator.of(context).pop();
//                                                     },
//                                                     radius: 10,
//                                                     text: 'No'.tr(),
//                                                     textColor: Colors.white,
//                                                     bgColor: const Color(0xffd63d46),
//                                                     height: 40,
//                                                   ),
//                                                   btnOk: CustomButton(
//                                                     onPressed: () {
//                                                       Navigator.of(context).pop();
//                                                       ref.read(orderViewModelProvider.notifier).updatePayment(orderId: orderModel.id, paymentId: null, paymentWay: 1);
//                                                     },
//                                                     radius: 10,
//                                                     text: 'Yes'.tr(),
//                                                     textColor: Colors.white,
//                                                     bgColor: Theme.of(context).primaryColor,
//                                                     height: 40,
//                                                   ),
//                                                   onDismissCallback: (dismiss) {})
//                                                   .show();
//                                             } else {
//                                               await StripePaymentService.makePayment(amount: '${orderModel.amount}', currency: 'USD', refProvider: ref , order: orderModel);
//                                             }
//                                           }
//                                         }
//                                             : null,
//                                         text: (orderModel.isPaid
//                                             ? 'finish_order'.tr()
//                                             : 'pay'.tr()),
//                                         textColor: Colors.white,
//                                         bgColor: Theme.of(context)
//                                             .primaryColor,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                   ],
//                                 )
//                             ],
//                           );
//                         }
//                       }
//                       else
//                       {
//                         return Container();
//                       }
//                     }
//                   }()),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
