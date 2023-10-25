
import 'package:auto_size_text/auto_size_text.dart';
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

import '../../../../core/service/stripe_payment.dart';
import '../../../../models/order.dart';
import '../../../../models/response_state.dart';
import '../../../../view_model/order_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/custsomer_card_new_order.dart';
import '../../../widgets/gradient_background.dart';
import '../routes/route_details_technician_map.dart';

final selectPayCash = StateProvider.autoDispose<bool?>((ref) => null);
final addedImages = StateProvider<int>((ref) => 0);
final addedVideos = StateProvider<int>((ref) => 0);

class OrderDetailsTechnician extends ConsumerStatefulWidget {
  const OrderDetailsTechnician({super.key, required this.orderId ,required this.routeId});

  final int orderId;
  final int routeId;

  @override
  ConsumerState createState() => _OrderDetailsTechnicianState(orderId: orderId , routeId: routeId);
}

class _OrderDetailsTechnicianState
    extends ConsumerState<OrderDetailsTechnician> {
  _OrderDetailsTechnicianState({required this.orderId ,required this.routeId});

  final int orderId;
  final int routeId;

  late TextEditingController report;
  late TextEditingController amount;

  static final GlobalKey<FormState> _reportFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(orderViewModelProvider.notifier).loadOne(orderId: orderId);
      ref.read(addedImages.notifier).state = 0;
      ref.read(addedVideos.notifier).state = 0;
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

    ref.listen<ResponseState<OrderModel>>(orderViewModelProvider, (previous, next) {
      next.whenOrNull(
        success: (order) {
          ref.read(selectedFilesToUpload).clear();
          amount.clear();
          ref.read(orderViewModelProvider.notifier).loadOne(orderId: orderId);
        },
        error: (error) {

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

          final snackBar = SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            showCloseIcon: true,
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.zero,
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
            Column(
              children: [
                CustomAppBar(
                  title: 'order_details'.tr(),
                  onPop: (){
                    ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId);
                    Navigator.pop(context);
                  },
                ),
                ref.watch(orderViewModelProvider).maybeWhen(
                      loading: () => Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                'assets/images/global_loader.json',
                                height: 50),
                            if(ref.watch(sendingRequestProgress) > 0)
                              Column(
                              children: [
                                const SizedBox(height: 10,),
                                AutoSizeText(
                                  '${ref.watch(sendingRequestProgress)}%',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      data: (orderModel) {

                        if(orderModel.status == 3){
                          report.text = orderModel.report ?? '';
                        }

                        return Expanded(
                          child: SizedBox(
                            width: screenWidth * 95,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color:  const Color(0xffDCDCDC))),
                                      padding:  const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            'visit'.tr(),
                                            style:  TextStyle(
                                              fontSize: 11,
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          AutoSizeText(
                                            orderModel.isVisit ? 'second_visit'.tr() : 'first_visit'.tr(),
                                            style:  TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
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
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          AutoSizeText(
                                            orderModel.address,
                                            style:  TextStyle(
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
                                                'upload_image_or_video'.tr(),
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
                                            onPressed:  orderModel.status == 3 ? null : () async {
                                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                type: FileType.media,
                                                allowCompression: true,
                                              );
                                              var ext = result?.files.single.extension;
                                              if(result != null){
                                                if((ext == 'png' || ext == 'jpg' || ext == 'jpeg') && result.files.single.size > ((1e+6 * 3))){
                                                  final snackBar = SnackBar(
                                                    backgroundColor: Theme.of(context).primaryColor,
                                                    showCloseIcon: true,
                                                    behavior: SnackBarBehavior.floating,
                                                    padding: EdgeInsets.zero,
                                                    content: CustomSnakeBarContent(
                                                      icon: const Icon(Icons.error, color: Colors.red , size: 25,),
                                                      message: 'image_file_is_large_max_size_is_3_mega_for_each_file'.tr(),
                                                      bgColor: Colors.grey.shade600,
                                                      borderColor: Colors.redAccent.shade200,
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                                else if(result.files.single.size > ((1e+6 * 10))){
                                                  final snackBar = SnackBar(
                                                    backgroundColor: Theme.of(context).primaryColor,
                                                    showCloseIcon: true,
                                                    behavior: SnackBarBehavior.floating,
                                                    padding: EdgeInsets.zero,
                                                    content: CustomSnakeBarContent(
                                                      icon: const Icon(Icons.error, color: Colors.red , size: 25,),
                                                      message: 'video_file_is_large_max_size_is_10_mega_for_each_file'.tr(),
                                                      bgColor: Colors.grey.shade600,
                                                      borderColor: Colors.redAccent.shade200,
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                                else{
                                                  if(ext == 'png' || ext == 'jpg' || ext == 'jpeg'){
                                                    if(ref.watch(addedImages) < 3){
                                                      ref.read(addedImages.notifier).state++;
                                                      ref.read(selectedFilesToUpload.notifier).addFiles(result.files.first);
                                                    }
                                                    else{
                                                      final snackBar = SnackBar(
                                                        backgroundColor: Theme.of(context).primaryColor,
                                                        showCloseIcon: true,
                                                        behavior: SnackBarBehavior.floating,
                                                        padding: EdgeInsets.zero,
                                                        content: CustomSnakeBarContent(
                                                          icon: const Icon(Icons.error, color: Colors.red , size: 25,),
                                                          message: 'images_maximum'.tr(),
                                                          bgColor: Colors.grey.shade600,
                                                          borderColor: Colors.redAccent.shade200,
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    }
                                                  }
                                                  else{
                                                    if(ref.read(addedVideos) < 1){
                                                      ref.read(addedVideos.notifier).state++;
                                                      ref.read(selectedFilesToUpload.notifier).addFiles(result.files.first);
                                                    }
                                                    else{
                                                      final snackBar = SnackBar(
                                                        backgroundColor: Theme.of(context).primaryColor,
                                                        showCloseIcon: true,
                                                        behavior: SnackBarBehavior.floating,
                                                        padding: EdgeInsets.zero,
                                                        content: CustomSnakeBarContent(
                                                          icon: const Icon(Icons.error, color: Colors.red , size: 25,),
                                                          message: 'videos_maximum'.tr(),
                                                          bgColor: Colors.grey.shade600,
                                                          borderColor: Colors.redAccent.shade200,
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    }
                                                  }
                                                }
                                              }
                                            },

                                            icon: Icon(
                                              Icons.add_box_rounded,
                                              color:
                                                  Theme.of(context).primaryColor,
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
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context , index){
                                        return Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          margin: const EdgeInsets.all(1),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  '${orderModel.files?[index].fileName}',
                                                  style: TextStyle(
                                                    color: Theme.of(context).primaryColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(onPressed: (){
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
                                                                      ref.read(orderViewModelProvider.notifier).deleteFile(id: orderId, fileId: orderModel.files?[index].id);
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
                                                  }, icon: Icon(Icons.delete_rounded , color: Theme.of(context).primaryColor,)),
                                                ],
                                              )
                                            ],
                                          )
                                        );
                                      },
                                    ),
                                    ListView.builder(
                                      itemCount: ref.watch(selectedFilesToUpload).length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context , index){
                                        return Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            margin: const EdgeInsets.all(1),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    '${ref.read(selectedFilesToUpload)[index]?.name}',
                                                    style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        overflow: TextOverflow.ellipsis
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(onPressed: (){
                                                      var ext = ref.read(selectedFilesToUpload)[index]?.extension;
                                                      if(ext == 'png' || ext == 'jpg' || ext == 'jpeg'){
                                                        ref.read(addedImages.notifier).state--;
                                                      }
                                                      else{
                                                        ref.read(addedVideos.notifier).state--;
                                                      }
                                                      ref.read(selectedFilesToUpload.notifier).removeFiles(ref.watch(selectedFilesToUpload)[index]);
                                                    }, icon: Icon(Icons.close_rounded , color: Theme.of(context).primaryColor,)),
                                                  ],
                                                )
                                              ],
                                            )
                                        );
                                      },
                                    ),
                                    if(ref.watch(selectedFilesToUpload).isNotEmpty)
                                      Column(
                                      children: [
                                        const SizedBox(height: 5,),
                                        SizedBox(
                                          height: 40,
                                          width: screenWidth * 70,
                                          child: CustomButton(
                                            onPressed: (){
                                              ref.read(orderViewModelProvider.notifier).addFiles(id: orderId, files: ref.read(selectedFilesToUpload));
                                            },
                                            text: 'upload'.tr(),
                                            textColor: Colors.white,
                                            bgColor: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    Form(
                                      key: _reportFormKey,
                                      child: CustomTextFormField(
                                        label: 'order_report'.tr(),
                                        controller: report,
                                        textInputType: TextInputType.multiline,
                                        height: 115,
                                        validator: (text) {
                                          if(text?.isEmpty ?? true){
                                            return 'this_filed_required'.tr();
                                          }
                                          return null;
                                        },
                                        readOnly: orderModel.status == 3 ? true : false,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color:  const Color(0xffDCDCDC))),
                                      padding:  const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            'order_status'.tr(),
                                            style:  TextStyle(
                                              fontSize: 11,
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          AutoSizeText(
                                            orderModel.statusName.tr(),
                                            style:  TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    if (orderModel.amount == null) CustomTextFormField(
                                        label: 'Set amount'.tr(),
                                        validator: (text){},
                                        controller: amount,
                                        searchSuffix: Container(
                                        margin: const EdgeInsets.all(10),
                                        child: MaterialButton(
                                          onPressed: (){
                                            if(amount.text.isNotEmpty) {
                                              ref.read(orderViewModelProvider.notifier).updateAmount(orderId: orderId, amount: amount.text);
                                            }
                                          },
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.zero,
                                          color: Colors.grey[100],
                                          child: AutoSizeText(
                                            'Update'.tr(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).primaryColor
                                            ),
                                          ),
                                        ),
                                      ),
                                        textInputType: TextInputType.number,

                                    ) else Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                  color:  const Color(0xffDCDCDC))),
                                          padding:  const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                'last_updated_amount'.tr(),
                                                style:  TextStyle(
                                                  fontSize: 11,
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              AutoSizeText(
                                                orderModel.amount ?? '100 USD',
                                                style:  TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        if(orderModel.isPaid == false)
                                        CustomTextFormField(
                                            label: 'Update amount'.tr(),
                                            validator: (text){},
                                            controller: amount,
                                            searchSuffix: Container(
                                              margin: const EdgeInsets.all(10),
                                              child: MaterialButton(
                                                onPressed: (){
                                                  if(amount.text.isNotEmpty) {
                                                    ref.read(orderViewModelProvider.notifier).updateAmount(orderId: orderId, amount: amount.text);
                                                  }
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                padding: EdgeInsets.zero,
                                                color: Colors.grey[100],
                                                child: AutoSizeText(
                                                  'Update'.tr(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).primaryColor
                                                  ),
                                                ),
                                              ),
                                            ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: orderModel.isPaid ? 10 : 5,),
                                    orderModel.isPaid
                                        ? Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color:  const Color(0xffDCDCDC))),
                                      padding:  const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            'payment_status'.tr(),
                                            style:  TextStyle(
                                              fontSize: 11,
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          AutoSizeText(
                                            'paid'.tr(),
                                            style:  TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                        : SizedBox(
                                      height: 50,
                                      child: CheckboxListTile(
                                        value: ref.watch(selectPayCash) ?? false,
                                        activeColor: Theme.of(context).primaryColor,
                                        onChanged: (value){
                                          ref.read(selectPayCash.notifier).state = value;
                                        },
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: AutoSizeText(
                                          'pay_cash'.tr(),
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: orderModel.isPaid ? 10 : 5,),
                                    SizedBox(
                                      height: orderModel.status == 3 ? 0 : 45,
                                      child: ref.watch(paymentLoadingProvider)
                                          ? Lottie.asset(
                                              'assets/images/global_loader.json',
                                              height: 45
                                            )
                                          : CustomButton(
                                        onPressed: () async {
                                          if(orderModel.isPaid){
                                            if(_reportFormKey.currentState?.validate() ?? false){
                                              ref.read(orderViewModelProvider.notifier).finishOrder(orderId: orderId, report: report.text);
                                            }
                                          }
                                          else {
                                            if(ref.watch(selectPayCash) == true){
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
                                                            'sure_you_get_the_payment_cash'.tr(),
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
                                                                ref.read(orderViewModelProvider.notifier).updatePayment(orderId: orderId, paymentId: null, paymentWay: 1);
                                                              },
                                                              text: 'yes'.tr(),
                                                              textColor: Colors.white,
                                                              bgColor: Theme.of(context).primaryColor,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            else{
                                              final paymentId = await StripePaymentService.makePayment(amount: '100' , currency: 'USD' , refProvider: ref);
                                              if(paymentId.isNotEmpty){
                                                ref.read(orderViewModelProvider.notifier).updatePayment(orderId: orderId, paymentId: paymentId, paymentWay: 2);
                                              }
                                            }
                                          }
                                        },
                                        text:  (orderModel.isPaid ? 'finish_order'.tr() : 'pay'.tr()),
                                        textColor: Colors.white,
                                        bgColor: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
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
