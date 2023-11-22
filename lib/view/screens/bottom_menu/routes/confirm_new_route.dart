import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/providers/selected_orders_new_order_provider.dart';
import 'package:global_reparaturservice/models/routes.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/routes/new_route.dart';
import 'package:global_reparaturservice/view_model/route_view_model.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/response_state.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snakbar.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/order_card.dart';

class ConfirmNewRoute extends ConsumerWidget {
  const ConfirmNewRoute({super.key , this.technician});

  final UserModel? technician;

  @override
  Widget build(BuildContext context , WidgetRef ref) {

    ref.listen<ResponseState<RoutesModel>>(routeViewModelProvider, (previous, next) {
      next.whenOrNull(
        success: (order) {

          Navigator.pop(context);
          Navigator.pop(context , 'update');

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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'confirm_new_route'.tr(),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        AutoSizeText.rich(
                          TextSpan(
                              text: 'orders'.tr(),
                              children:  [
                                TextSpan(
                                    text: ' (${ref.read(selectedOrdersToNewOrder).length})',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500))
                              ]),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return OrderCard(
                                orderIndex: index + 1,
                                orderModel: ref.read(selectedOrdersToNewOrder)[index],
                                onPressed: null,
                                showOrderStatus: true,
                                showOrderCheckBox: false,
                                showOrderPaymentStatus: true
                            );
                          },
                          itemCount: ref.read(selectedOrdersToNewOrder).length,
                        ),

                        const SizedBox(height: 5,),

                        AutoSizeText(
                          'technician'.tr(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10,),

                        technician == null
                            ? SizedBox(
                          height: 50,
                          child: CheckboxListTile(
                            value: true,
                            activeColor: Theme.of(context).primaryColor,
                            enabled: false,
                            onChanged: (value){
                              if(value == true){
                                ref.read(selectedTechnician.notifier).state = null;
                              }
                              ref.read(selectTechnicianLater.notifier).state = value ?? false;
                            },
                            title: AutoSizeText(
                              'Driver Will Assign Automatically'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),
                            ),
                          ),
                        )
                            : Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFDBDBDB))
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/car.png', height: 30,),
                                  const SizedBox(width: 10,),
                                  AutoSizeText(
                                    '${technician?.name}',
                                    style: TextStyle(
                                        color:
                                        Theme.of(context).primaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20,),

                        ref.watch(routeViewModelProvider).maybeWhen(
                            loading: () => Center(
                              child: Lottie.asset(
                                  'assets/images/global_loader.json',
                                  height: 50
                              ),
                            ),
                            orElse: (){
                              return CustomButton(
                                onPressed: (){
                                  ref.read(routeViewModelProvider.notifier).create(
                                    description: 'This is just description',
                                    driverId: technician?.id,
                                    orders: ref.read(selectedOrdersToNewOrder),
                                  );
                                },
                                text: 'place_route'.tr(),
                                textColor: Colors.white,
                                bgColor: Theme.of(context).primaryColor,
                              );
                            }
                        ),
                      ],
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
