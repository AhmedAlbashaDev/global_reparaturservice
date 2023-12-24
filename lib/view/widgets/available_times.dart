import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';

import '../../view_model/order_get_available_times.dart';
import '../screens/bottom_menu/orders/new_order.dart';
import 'custom_button.dart';

class AvailableTimesWidget extends ConsumerStatefulWidget {
  const AvailableTimesWidget({super.key});

  @override
  ConsumerState createState() => _AvailableTimesWidgetState();
}

class _AvailableTimesWidgetState extends ConsumerState<AvailableTimesWidget> {

  _selectCustomVisitDate(BuildContext context) {
    showDatePicker(
        context: context,
        locale: context.locale,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101)).then((picked) {
      if(picked != null){
        ref.read(isCustomDate.notifier).state = true;
        ref.read(selectedVisitDateToNewOrder.notifier).state = Jiffy.parseFromDateTime(picked).format(pattern: 'yyyy-MM-dd');
        ref.read(selectedVisitToNewOrder.notifier).state = null;
        ref.read(orderGetAvailableTimesViewModelProvider.notifier).getAvailableTimes(selectedDate: ref.watch(selectedVisitDateToNewOrder));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(orderGetAvailableTimesViewModelProvider).maybeWhen(
        loading: () => Center(
          child: Lottie.asset(
              'assets/images/global_loader.json',
              height: 50),
        ),
        data: (availableTimes) {
          Future.microtask((){
            if(ref.read(selectedVisitDateToNewOrder) == null){
              ref.read(selectedVisitDateToNewOrder.notifier).state = Jiffy.parseFromDateTime(DateTime.now()).format(pattern: 'yyyy-MM-dd');
            }
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                'Available Time Slots'.tr(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 85,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context , index) {
                    bool isSelected = Jiffy.parseFromDateTime(DateTime.now().add(Duration(days: index))).format(pattern: 'yyyy-MM-dd') == ref.watch(selectedVisitDateToNewOrder);
                    return Center(
                      child: Container(
                        height: 60,
                        width: 90,
                        margin: const EdgeInsets.all(3),
                        padding: EdgeInsets.zero,
                        child:  MaterialButton(
                          onPressed: (){
                            ref.read(isCustomDate.notifier).state = false;
                            ref.read(selectedVisitDateToNewOrder.notifier).state = Jiffy.parseFromDateTime(DateTime.now().add(Duration(days: index))).format(pattern: 'yyyy-MM-dd');
                            ref.read(selectedVisitToNewOrder.notifier).state = null;
                            ref.read(orderGetAvailableTimesViewModelProvider.notifier).getAvailableTimes(selectedDate: ref.watch(selectedVisitDateToNewOrder));
                          },
                          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                          disabledColor: Colors.grey.shade500,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AutoSizeText(
                                '${DateTime.now().add(Duration(days: index)).day}',
                                style:  TextStyle(
                                  color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,

                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              AutoSizeText(
                                '${Jiffy.parseFromDateTime(DateTime.now().add(Duration(days: index))).MMM} ${DateTime.now().add(Duration(days: index)).year}',
                                style:  TextStyle(
                                    color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5,),
              if(ref.watch(isCustomDate))
                Container(
                  height: 60,
                  width: 90,
                  margin: const EdgeInsets.all(3),
                  padding: EdgeInsets.zero,
                  child:  MaterialButton(
                    onPressed: (){
                      ref.read(selectedVisitToNewOrder.notifier).state = null;
                      ref.read(orderGetAvailableTimesViewModelProvider.notifier).getAvailableTimes(selectedDate: ref.watch(selectedVisitDateToNewOrder));
                    },
                    color: Theme.of(context).primaryColor,
                    disabledColor: Colors.grey.shade500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AutoSizeText(
                          '${Jiffy.parse('${ref.watch(selectedVisitDateToNewOrder)}').date}',
                          style:  const TextStyle(
                            color: Colors.white ,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,

                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        AutoSizeText(
                          '${Jiffy.parse('${ref.watch(selectedVisitDateToNewOrder)}').MMM} ${Jiffy.parse('${ref.watch(selectedVisitDateToNewOrder)}').year}',
                          style:  const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 5,),
              AutoSizeText(
                'Which Time'.tr(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5,),
              availableTimes.isNotEmpty
                  ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: availableTimes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4 , childAspectRatio: 10 / 5),
                itemBuilder:
                    (context,
                    index) {
                  return Container(
                    margin: const EdgeInsets.all(3),
                    child: CustomButton(
                      onPressed: () {
                        ref.read(selectedVisitToNewOrder.notifier).state = '${ref.read(selectedVisitDateToNewOrder.notifier).state} ${availableTimes[index]}';
                        // ref.read(selectedCustomVisitToNewOrder.notifier).state = availableTimes[index];
                      },
                      text: availableTimes[index],
                      // text: Jiffy.parse(availableTimes[index]).format(pattern: 'HH:mm'),
                      textColor: ref.watch(selectedVisitToNewOrder)?.split(' ').last == availableTimes[index] ? Colors.white : Theme.of(context).primaryColor,
                      radius: 10,
                      height: 40,
                      bgColor: ref.watch(selectedVisitToNewOrder)?.split(' ').last == availableTimes[index] ? Theme.of(context).primaryColor :Colors.white,
                    ),
                  );
                },
              )
                  :  Center(
                child: AutoSizeText(
                  'No Times Available'.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    AutoSizeText(
                      'Your Visit Time is'.tr(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        ' : ${ref.watch(selectedVisitToNewOrder) ?? 'Not set' }',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              CustomButton(
                  onPressed: (){
                    _selectCustomVisitDate(context);
                  },
                  text: 'Set Custom Visit Date'.tr(),
                  textColor: Colors.white,
                  radius: 10,
                  bgColor: Theme.of(context).primaryColor
              )
            ],
          );
        },
        error: (error){
          return CustomButton(
              onPressed: () {
                ref
                    .read(orderGetAvailableTimesViewModelProvider
                    .notifier)
                    .getAvailableTimes(selectedDate: ref.watch(selectedVisitDateToNewOrder));
              },
              radius: 10,
              text:
              'Retry'.tr(),
              height: 45,
              textColor:
              Colors
                  .white,
              bgColor: Colors.redAccent
          );
        },
        orElse: () {
          return CustomButton(
              onPressed: () {
                ref
                    .read(orderGetAvailableTimesViewModelProvider
                    .notifier)
                    .getAvailableTimes(selectedDate: Jiffy.parseFromDateTime(DateTime.now()).format(pattern: 'yyyy-MM-dd'));
              },
              radius: 10,
              text:
              'Get available times'.tr(),
              height: 45,
              textColor:
              Colors
                  .white,
              bgColor: Theme.of(context).primaryColor
          );
        });
  }
}