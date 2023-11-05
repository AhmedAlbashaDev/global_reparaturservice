import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/core/providers/request_sending_progress.dart';
import 'package:global_reparaturservice/core/providers/select_files_to_upload.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:global_reparaturservice/view/widgets/custom_text_form_field.dart';
import 'package:global_reparaturservice/view_model/route_view_model.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/service/stripe_payment.dart';
import '../../../../models/order.dart';
import '../../../../models/response_state.dart';
import '../../../../view_model/order_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custsomer_card_new_order.dart';
import '../../../widgets/gradient_background.dart';

final selectPayCash = StateProvider.autoDispose<bool?>((ref) => null);
final selectPayLater = StateProvider.autoDispose<bool>((ref) => false);
final addedFiles = StateProvider<int>((ref) => 0);
final orderType = StateProvider<int>((ref) => 0);

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

  late TextEditingController report;
  late TextEditingController amount;

  static final GlobalKey<FormState> _reportFormKey = GlobalKey<FormState>();

  OrderModel? globalOrderModel;

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(orderViewModelProvider.notifier).loadOne(orderId: orderId);
      ref.read(addedFiles.notifier).state = 0;
    });

    report = TextEditingController();
    amount = TextEditingController();
  }

  @override
  void dispose() {
    report.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResponseState<OrderModel>>(orderViewModelProvider,
        (previous, next) {
      next.whenOrNull(
        success: (order) {

          if(order?['send_invoice'] == true){
            AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.rightSlide,
                title: 'Invoice'.tr(),
                desc: 'Successfully send invoice to customer'.tr(),
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
          else if(order?['finish_order'] == true){
            AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.rightSlide,
                title: 'Order'.tr(),
                desc: 'Successfully finished this order \n Check other orders'.tr(),
                autoDismiss: false,
                dialogBackgroundColor: Colors.white,
                btnOk: CustomButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(selectedFilesToUpload).clear();
                    amount.clear();
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
          else{
            ref.read(selectedFilesToUpload).clear();
            amount.clear();
            ref.read(orderViewModelProvider.notifier).loadOne(orderId: orderId);
          }
        },
        data: (orderModel){
          ref.read(orderType.notifier).state = orderModel.type;
          if(orderModel.type == 3){
            report.text = orderModel.report ?? '';
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
                  title: 'order_details'.tr(),
                  onPop: () {
                    ref
                        .read(routeViewModelProvider.notifier)
                        .loadOne(routeId: routeId);
                    Navigator.pop(context);
                  },
                ),
                ref.watch(orderViewModelProvider).maybeWhen(
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

                        if (orderModel.status == 3) {
                          report.text = orderModel.report ?? '';
                        }

                        if(_refreshController.isRefresh){
                          _refreshController.refreshCompleted();
                        }

                        globalOrderModel = orderModel;

                        return OrderDetailsTechnicianView(orderModel: orderModel, reportFormKey: _reportFormKey, refreshController: _refreshController, report: report, amount: amount);
                      },
                      success: (data) {
                          return OrderDetailsTechnicianView(orderModel: globalOrderModel!, reportFormKey: _reportFormKey, refreshController: _refreshController, report: report, amount: amount);
                      },
                      error: (error) => CustomError(
                        message: error.errorMessage ?? '',
                        onRetry: () {
                          ref
                              .read(orderViewModelProvider.notifier)
                              .loadOne(orderId: orderId);
                        },
                      ),
                      orElse: () => Center(
                        child: CustomError(
                          message: 'unknown_error_please_try_again'.tr(),
                          onRetry: () {
                            ref
                                .read(orderViewModelProvider.notifier)
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
  const OrderDetailsTechnicianView({super.key ,required this.orderModel,required this.reportFormKey,required this.refreshController ,required this.report,required this.amount,});

  final OrderModel orderModel;

  final TextEditingController report;
  final TextEditingController amount;

  final GlobalKey<FormState> reportFormKey;

  final RefreshController refreshController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  .read(orderViewModelProvider.notifier)
                  .loadOne(orderId: orderModel.id);
            },
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
                          'Order reference'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SelectionArea(
                          child: AutoSizeText(
                            orderModel.referenceNo,
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
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'order_address'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          orderModel.address,
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
                            color: const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'floor_number'.tr(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              AutoSizeText(
                                '${orderModel.floorNumber}',
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
                        Expanded(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'apartment_number'.tr(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              AutoSizeText(
                                orderModel.apartmentNumber ??
                                    'N/A',
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
                            color: const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'order_status'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          orderModel.statusName.tr(),
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
                        IconButton(
                          onPressed: orderModel.status == 3
                              ? null
                              : () async {
                            FilePickerResult? result =
                            await FilePicker
                                .platform
                                .pickFiles(
                              type: FileType.any,
                              allowCompression: true,
                            );

                            if (result != null) {
                              if (result.files.single.size > ((1e+6 * 10))) {
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
                                    'image_file_is_large_max_size_is_3_mega_for_each_file'
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
                                  ref.read(selectedFilesToUpload.notifier).addFiles(result.files.first);
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
                                      message:
                                      'images_maximum'
                                          .tr(),
                                      bgColor: Colors
                                          .grey
                                          .shade600,
                                      borderColor: Colors
                                          .redAccent
                                          .shade200,
                                    ),
                                  );
                                  ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(
                                      snackBar);
                                }
                              }
                            }
                          },
                          icon: Icon(
                            Icons.add_box_rounded,
                            color: Theme.of(context)
                                .primaryColor,
                            size: 30,
                          ),
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
                                        showDialog(
                                          context: context,
                                          barrierDismissible:
                                          false,
                                          builder: (_) =>
                                              Center(
                                                child: Container(
                                                  height:
                                                  screenHeight *
                                                      20,
                                                  width:
                                                  screenWidth *
                                                      90,
                                                  margin:
                                                  const EdgeInsets
                                                      .all(
                                                      24),
                                                  decoration: BoxDecoration(
                                                      color: Colors
                                                          .white,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Material(
                                                        child:
                                                        AutoSizeText(
                                                          'are_you_sure_you_want_to_delete'
                                                              .tr(),
                                                          style: TextStyle(
                                                              color: Theme.of(context)
                                                                  .primaryColor,
                                                              fontSize:
                                                              17,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                        children: [
                                                          CustomButton(
                                                            onPressed:
                                                                () {
                                                              Navigator.pop(context);
                                                            },
                                                            text:
                                                            'no'.tr(),
                                                            textColor:
                                                            Theme.of(context).primaryColor,
                                                            bgColor:
                                                            Colors.white,
                                                          ),
                                                          CustomButton(
                                                            onPressed:
                                                                () {
                                                              Navigator.pop(context);
                                                              ref.read(orderViewModelProvider.notifier).deleteFile(
                                                                  id: orderModel.id,
                                                                  fileId: orderModel.files?[index].id);
                                                            },
                                                            text:
                                                            'yes'.tr(),
                                                            textColor:
                                                            Colors.white,
                                                            bgColor:
                                                            Colors.red,
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        );
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
                          width: screenWidth * 70,
                          child: CustomButton(
                            onPressed: () {
                              ref
                                  .read(orderViewModelProvider
                                  .notifier)
                                  .addFiles(
                                  id: orderModel.id,
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
                  const SizedBox(height: 5,),
                  //Order Type
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
                          'Order Type'.tr(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if(orderModel.type != 3)
                          Column(
                            children: [
                              RadioListTile(
                                  value: 1,
                                  groupValue: ref.watch(orderType),
                                  onChanged: (value) {
                                    if(orderModel.status != 3){
                                      ref.read(orderType.notifier).state = value ?? 1;
                                    }
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                  title: AutoSizeText(
                                    'Pick-Up'.tr(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                              ),
                              RadioListTile(
                                  value: 2,
                                  groupValue: ref.watch(orderType),
                                  onChanged: (value) {
                                    if(orderModel.status != 3){
                                      ref.read(orderType.notifier).state = value ?? 2;
                                    }
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                  title: AutoSizeText(
                                    'On-Site'.tr(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                              ),
                            ],
                          )
                        else
                          RadioListTile(
                              value: 3,
                              groupValue: orderModel.type,
                              onChanged: (value) {},
                              activeColor: Theme.of(context).primaryColor,
                              title: AutoSizeText(
                                'Drop-Off'.tr(),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: reportFormKey,
                    child: CustomTextFormField(
                      label: 'order_report'.tr(),
                      controller: report,
                      textInputType: TextInputType.multiline,
                      height: 115,
                      validator: (text) {
                        if (text?.isEmpty ?? true) {
                          return 'this_filed_required'.tr();
                        }
                        return null;
                      },
                      readOnly: orderModel.status == 3
                          ? true
                          : false,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  if (orderModel.amount == 0)
                    Column(
                      children: [
                        CustomTextFormField(
                          label: 'New amount'.tr(),
                          validator: (text) {},
                          controller: amount,
                          textInputType: TextInputType.number,
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          height: 45,
                          width: screenWidth * 90,
                          child: CustomButton(
                            onPressed: () {
                              if (amount.text.isNotEmpty) {
                                ref
                                    .read(orderViewModelProvider
                                    .notifier)
                                    .updateAmount(
                                    orderId: orderModel.id,
                                    amount: amount.text);
                              }
                            },
                            text: 'Update amount'.tr(),
                            textColor: Colors.white,
                            bgColor: Theme.of(context).primaryColor,
                            radius: 10,
                          ),
                        )
                      ],
                    )
                  else
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(
                                      0xffDCDCDC))),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'last_updated_amount'.tr(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              AutoSizeText(
                                '${orderModel.amount}',
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
                          height: 5,
                        ),
                        if (orderModel.isPaid == false && orderModel.status != 3)
                          Column(
                            children: [
                              CustomTextFormField(
                                label: 'New amount'.tr(),
                                validator: (text) {},
                                controller: amount,
                                textInputType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 45,
                                width: screenWidth * 90,
                                child: CustomButton(
                                  onPressed: () {
                                    if (amount
                                        .text.isNotEmpty) {
                                      ref
                                          .read(
                                          orderViewModelProvider
                                              .notifier)
                                          .updateAmount(
                                          orderId: orderModel.id,
                                          amount:
                                          amount.text);
                                    }
                                  },
                                  text: 'Update amount'.tr(),
                                  textColor: Colors.white,
                                  bgColor: Theme.of(context).primaryColor,
                                  radius: 10,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          )
                      ],
                    ),
                  if(orderModel.isPaid)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(
                                      0xffDCDCDC))),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'payment_status'.tr(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              AutoSizeText(
                                'paid'.tr(),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ) ,
                        const SizedBox(height: 10,),
                      ],
                    ),
                  if(orderModel.amount != 0)
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                onPressed: () {
                                  ref.read(orderViewModelProvider.notifier).sendInvoice(orderId: orderModel.id);
                                },
                                text: 'Send invoice'.tr(),
                                textColor: Colors.white,
                                bgColor: Theme.of(context).primaryColor,
                                radius: 10,
                              ),
                            ),
                            const SizedBox(width: 5,),
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
                                text: 'Show invoice'.tr(),
                                textColor: Colors.white,
                                bgColor: Theme.of(context).primaryColor,
                                radius: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  if(orderModel.type != 3)
                    if((ref.watch(orderType) == 1 && orderModel.amount != 0))
                      if(orderModel.status != 3)
                        Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: CustomButton(
                                onPressed: () async {
                                  if (reportFormKey.currentState?.validate() ?? false) {
                                    ref.read(orderViewModelProvider.notifier).finishOrder(orderId: orderModel.id, report: report.text , isPayLater: false);
                                  }
                                },
                                text: 'finish_order'.tr(),
                                textColor: Colors.white,
                                bgColor: Theme.of(context).primaryColor,
                                radius: 10,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      else
                        Container()
                    else if (ref.watch(orderType) == 2 && orderModel.amount != 0)
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: CheckboxListTile(
                              value: ref.watch(selectPayLater),
                              activeColor: Theme.of(context)
                                  .primaryColor,
                              onChanged: (value) {
                                ref
                                    .read(
                                    selectPayLater.notifier)
                                    .state = value ?? false;
                              },
                              controlAffinity:
                              ListTileControlAffinity
                                  .leading,
                              title: AutoSizeText(
                                'pay_later'.tr(),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if(ref.watch(selectPayLater))
                            Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: CustomButton(
                                    onPressed: () async {
                                      if (reportFormKey.currentState?.validate() ?? false) {
                                        ref.read(orderViewModelProvider.notifier).finishOrder(orderId: orderModel.id, report: report.text , isPayLater: true);
                                      }
                                    },
                                    text: 'finish_order'.tr(),
                                    textColor: Colors.white,
                                    bgColor: Theme.of(context).primaryColor,
                                    radius: 10,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: CheckboxListTile(
                                    value: ref.watch(selectPayCash) ??
                                        false,
                                    activeColor: Theme.of(context)
                                        .primaryColor,
                                    onChanged: (value) {
                                      ref
                                          .read(
                                          selectPayCash.notifier)
                                          .state = value;
                                    },
                                    controlAffinity:
                                    ListTileControlAffinity
                                        .leading,
                                    title: AutoSizeText(
                                      'pay_cash'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: orderModel.status == 3 ? 0 : 45,
                                  child: ref.watch(paymentLoadingProvider)
                                      ? Lottie.asset(
                                      'assets/images/global_loader.json',
                                      height: 45)
                                      : CustomButton(
                                    onPressed:
                                    orderModel.amount != null
                                        ? () async {
                                      if (orderModel
                                          .isPaid) {
                                        if (reportFormKey
                                            .currentState
                                            ?.validate() ??
                                            false) {
                                          ref
                                              .read(orderViewModelProvider
                                              .notifier)
                                              .finishOrder(
                                              orderId:
                                              orderModel.id,
                                              report: report
                                                  .text,
                                              isPayLater: false);
                                        }
                                      } else {
                                        if (ref.watch(selectPayCash) == true) {//sure_you_get_the_payment_cash
                                          AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.question,
                                              animType: AnimType.rightSlide,
                                              title: 'Payment'.tr(),
                                              desc: 'sure_you_get_the_payment_cash'.tr(),
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
                                                  ref.read(orderViewModelProvider.notifier).updatePayment(orderId: orderModel.id, paymentId: null, paymentWay: 1);
                                                },
                                                radius: 10,
                                                text: 'Yes'.tr(),
                                                textColor: Colors.white,
                                                bgColor: Theme.of(context).primaryColor,
                                                height: 40,
                                              ),
                                              onDismissCallback: (dismiss) {})
                                              .show();
                                        } else {
                                          await StripePaymentService.makePayment(amount: '${orderModel.amount}', currency: 'USD', refProvider: ref , order: orderModel);
                                        }
                                      }
                                    }
                                        : null,
                                    text: (orderModel.isPaid
                                        ? 'finish_order'.tr()
                                        : 'pay'.tr()),
                                    textColor: Colors.white,
                                    bgColor: Theme.of(context)
                                        .primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                        ],
                      )
                    else
                      Container()
                  else
                    Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: CheckboxListTile(
                                value: ref.watch(selectPayLater),
                                activeColor: Theme.of(context)
                                    .primaryColor,
                                onChanged: (value) {
                                  ref
                                      .read(
                                      selectPayLater.notifier)
                                      .state = value ?? false;
                                },
                                controlAffinity:
                                ListTileControlAffinity
                                    .leading,
                                title: AutoSizeText(
                                  'pay_later'.tr(),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if(ref.watch(selectPayLater))
                              Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: CustomButton(
                                      onPressed: () async {
                                        if (reportFormKey.currentState?.validate() ?? false) {
                                          ref.read(orderViewModelProvider.notifier).finishOrder(orderId: orderModel.id, report: report.text , isPayLater: true);
                                        }
                                      },
                                      text: 'finish_order'.tr(),
                                      textColor: Colors.white,
                                      bgColor: Theme.of(context).primaryColor,
                                      radius: 10,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: CheckboxListTile(
                                      value: ref.watch(selectPayCash) ??
                                          false,
                                      activeColor: Theme.of(context)
                                          .primaryColor,
                                      onChanged: (value) {
                                        ref
                                            .read(
                                            selectPayCash.notifier)
                                            .state = value;
                                      },
                                      controlAffinity:
                                      ListTileControlAffinity
                                          .leading,
                                      title: AutoSizeText(
                                        'pay_cash'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: orderModel.status == 3 ? 0 : 45,
                                    child: ref.watch(paymentLoadingProvider)
                                        ? Lottie.asset(
                                        'assets/images/global_loader.json',
                                        height: 45)
                                        : CustomButton(
                                      onPressed:
                                      orderModel.amount != null
                                          ? () async {
                                        if (orderModel
                                            .isPaid) {
                                          if (reportFormKey
                                              .currentState
                                              ?.validate() ??
                                              false) {
                                            ref
                                                .read(orderViewModelProvider
                                                .notifier)
                                                .finishOrder(
                                                orderId:
                                                orderModel.id,
                                                report: report
                                                    .text,
                                                isPayLater: false);
                                          }
                                        } else {
                                          if (ref.watch(selectPayCash) == true) {//sure_you_get_the_payment_cash
                                            AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.question,
                                                animType: AnimType.rightSlide,
                                                title: 'Payment'.tr(),
                                                desc: 'sure_you_get_the_payment_cash'.tr(),
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
                                                    ref.read(orderViewModelProvider.notifier).updatePayment(orderId: orderModel.id, paymentId: null, paymentWay: 1);
                                                  },
                                                  radius: 10,
                                                  text: 'Yes'.tr(),
                                                  textColor: Colors.white,
                                                  bgColor: Theme.of(context).primaryColor,
                                                  height: 40,
                                                ),
                                                onDismissCallback: (dismiss) {})
                                                .show();
                                          } else {
                                            await StripePaymentService.makePayment(amount: '${orderModel.amount}', currency: 'USD', refProvider: ref , order: orderModel);
                                          }
                                        }
                                      }
                                          : null,
                                      text: (orderModel.isPaid
                                          ? 'finish_order'.tr()
                                          : 'pay'.tr()),
                                      textColor: Colors.white,
                                      bgColor: Theme.of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
