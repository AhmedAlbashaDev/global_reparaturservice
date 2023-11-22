import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/models/routes.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:global_reparaturservice/view_model/route_view_model.dart';
import 'package:jiffy/jiffy.dart';

class OrderCard extends ConsumerWidget {
  const OrderCard({super.key, this.route , required this.showOrderStatus, required this.showOrderPaymentStatus, required this.showOrderCheckBox, required this.onPressed, this.orderModel , this.selected = false , this.onChangeCheckbox , this.scaffoldContext ,required this.orderIndex});

  final RoutesModel? route;
  final bool showOrderStatus;
  final bool showOrderCheckBox;
  final bool selected;
  final bool showOrderPaymentStatus;
  final VoidCallback? onPressed;
  final OrderModel? orderModel;
  final dynamic onChangeCheckbox;
  final BuildContext? scaffoldContext;
  final int orderIndex;
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    if((orderModel?.status != 3 && orderModel?.isPaid == false) && route != null) {
      return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const DrawerMotion(),

        extentRatio: .3,
        // All actions are defined in the children parameter.
        children:  [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
              onPressed: (context){
                AwesomeDialog(
                    context: scaffoldContext ?? context,
                    dialogType: DialogType.question,
                    animType: AnimType.rightSlide,
                    title: 'Delete Order'.tr(),
                    desc: 'Are you sure you want to delete this order from the route'.tr(),
                    autoDismiss: false,
                    dialogBackgroundColor: Colors.white,
                    btnCancel: CustomButton(
                      onPressed: () {
                        Navigator.of(scaffoldContext ?? context).pop();
                      },
                      radius: 10,
                      text: 'No'.tr(),
                      textColor: Colors.white,
                      bgColor: const Color(0xffd63d46),
                      height: 40,
                    ),
                    btnOk: CustomButton(
                      onPressed: () {
                        Navigator.of(scaffoldContext ?? context).pop();
                        ref.read(routeViewModelProvider.notifier).update(routeId: route?.id, orders: route?.orders?.where((element) => element.id != orderModel?.id).toList() ?? []);
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
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(10),

            ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(5),
        child: MaterialButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          elevation: .5,
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  '$orderIndex \\ ',
                  style: TextStyle(
                      color:
                      Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText(
                        '${orderModel?.referenceNo}',
                        style: TextStyle(
                            color:
                            Theme.of(context).primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8,),
                      AutoSizeText(
                        '${orderModel?.customer?.name}',
                        style: TextStyle(
                            color:
                            Theme.of(context).primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8,),
                      AutoSizeText(
                        '${'Visit Time'.tr()} : ${Jiffy.parse('${orderModel?.visitTime ?? orderModel?.createdAt}').format(pattern: 'dd/MM/yyyy hh:mm a')}',                        style: TextStyle(
                            color:
                            Theme.of(context).primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Visibility(
                              visible: showOrderPaymentStatus,
                              child: Container(
                                // height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    color: Theme.of(context).primaryColor.withOpacity(.5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                                  child: AutoSizeText(
                                    '${orderModel?.typeName}',
                                    style:  const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ),
                          Visibility(
                              visible: showOrderStatus,
                              child: Container(
                                // height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    color: orderModel?.status == 3 ?  const Color(0xff21AE38).withOpacity(.2) : const Color(0xffE2BD38).withOpacity(.2)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                                  child: AutoSizeText(
                                    '${orderModel?.statusName}',
                                    style:  TextStyle(
                                        color: orderModel?.status == 3 ? const Color(0xff21AE38) : const Color(0xffE2BD38),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ),
                          Visibility(
                              visible: showOrderPaymentStatus,
                              child: Container(
                                // height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    color: orderModel?.isPaid ?? false ?  const Color(0xff21AE38).withOpacity(.2) : const Color(0xffE2BD38).withOpacity(.2)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                                  child: AutoSizeText(
                                    orderModel?.isPaid ?? false ? 'paid'.tr() : 'not_paid'.tr(),
                                    style:  TextStyle(
                                        color: orderModel?.isPaid ?? false ? const Color(0xff21AE38) : const Color(0xffE2BD38),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    } else {
      return Container(
        margin: const EdgeInsets.all(5),
        child: MaterialButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          elevation: .5,
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  '$orderIndex \\ ',
                  style: TextStyle(
                      color:
                      Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText(
                        '${orderModel?.referenceNo}',
                        style: TextStyle(
                            color:
                            Theme.of(context).primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8,),
                      AutoSizeText(
                        '${orderModel?.customer?.name}',
                        style: TextStyle(
                            color:
                            Theme.of(context).primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8,),
                      AutoSizeText(
                        '${'Visit Time'.tr()} : ${Jiffy.parse('${orderModel?.visitTime ?? orderModel?.createdAt}').format(pattern: 'dd/MM/yyyy hh:mm a')}',
                        style: TextStyle(
                            color:
                            Theme.of(context).primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Visibility(
                              visible: showOrderPaymentStatus,
                              child: Container(
                                // height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    color: Theme.of(context).primaryColor.withOpacity(.5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                                  child: AutoSizeText(
                                    '${orderModel?.typeName}',
                                    style:  const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ),
                          Visibility(
                              visible: showOrderStatus,
                              child: Container(
                                // height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    color: orderModel?.status == 3 ?  const Color(0xff21AE38).withOpacity(.2) : const Color(0xffE2BD38).withOpacity(.2)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                                  child: AutoSizeText(
                                    '${orderModel?.statusName}',
                                    style:  TextStyle(
                                        color: orderModel?.status == 3 ? const Color(0xff21AE38) : const Color(0xffE2BD38),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ),
                          Visibility(
                              visible: showOrderPaymentStatus,
                              child: Container(
                                // height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    color: orderModel?.isPaid ?? false ?  const Color(0xff21AE38).withOpacity(.2) : const Color(0xffE2BD38).withOpacity(.2)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
                                  child: AutoSizeText(
                                    orderModel?.isPaid ?? false ? 'paid'.tr() : 'not_paid'.tr(),
                                    style:  TextStyle(
                                        color: orderModel?.isPaid ?? false ? const Color(0xff21AE38) : const Color(0xffE2BD38),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                const SizedBox(width: 5,),
                if(showOrderCheckBox)
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                      value: selected,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: onChangeCheckbox,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
