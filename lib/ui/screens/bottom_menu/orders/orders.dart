import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/search_field_status.dart';
import '../../../widgets/custom_menu_screens_app_bar.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/order_card.dart';
import '../../../widgets/search.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animation.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackgroundWidget(),
          Column(
            children: [
              const CustomMenuScreenAppBar(),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText.rich(
                              TextSpan(text: 'orders'.tr(), children: const [
                                TextSpan(
                                    text: ' (10)',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500))
                              ]),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DropdownButton<String>(
                                  value: 'Completed',
                                  onTap: (){},
                                  icon: Image.asset(
                                    'assets/images/filter.png',
                                    height: 18,
                                  ),
                                  items: <String>['All', 'Completed', 'Not Completed']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      onTap: (){},
                                      child: AutoSizeText(
                                        value,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    print('Value $value');
                                  },

                                ),
                                Center(
                                  child: SizedBox(
                                    width: 35,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onPressed: () {
                                        ref
                                            .read(searchFieldStatusProvider
                                                .notifier)
                                            .state = true;
                                        animation.forward();
                                      },
                                      child: Image.asset(
                                        'assets/images/search.png',
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SearchWidget(
                          fadeInFadeOut: _fadeInFadeOut,
                          searchController: searchController,
                          onChanged: (text) {},
                          onClose: () {
                            ref.read(searchFieldStatusProvider.notifier).state =
                                false;
                            animation.reverse();
                          },
                          enabled: ref.watch(searchFieldStatusProvider),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return OrderCard(
                            onPressed: (){},
                            showOrderStatus: true,
                            showOrderPaymentStatus: true,
                            showOrderCheckBox: false,
                          );
                        },
                        itemCount: 10,
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingAddButton(
        onPresses: () {},
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
