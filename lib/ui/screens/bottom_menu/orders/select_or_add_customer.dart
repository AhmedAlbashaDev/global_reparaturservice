import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/ui/widgets/floating_add_button.dart';

import '../../../../providers/search_field_status.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/search.dart';
import '../users/add_new_customer.dart';

class SelectOrAddCustomerScreen extends ConsumerStatefulWidget {
  const SelectOrAddCustomerScreen({super.key});

  @override
  ConsumerState createState() => _SelectOrAddCustomerScreenState();
}

class _SelectOrAddCustomerScreenState extends ConsumerState<SelectOrAddCustomerScreen> with TickerProviderStateMixin {
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
  Widget build(BuildContext context,) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: 'select_customer'.tr(),
                ),
                Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          SizedBox(
                            height: 50,
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText.rich(
                                      TextSpan(
                                          text: 'customers'.tr(),
                                          children: const [
                                            TextSpan(
                                                text: ' (1,443)',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500))
                                          ]),
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
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
                                    )
                                  ],
                                ),
                                SearchWidget(
                                  fadeInFadeOut: _fadeInFadeOut,
                                  searchController: searchController,
                                  onChanged: (text) {},
                                  onClose: () {
                                    ref
                                        .read(searchFieldStatusProvider.notifier)
                                        .state = false;
                                    animation.reverse();
                                  },
                                  enabled: ref.watch(searchFieldStatusProvider),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: EdgeInsets.all(5),
                                    child: MaterialButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      elevation: .5,
                                      color: const Color(0xffF7F7F7),
                                      child: Container(
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: const Color(0xffF7F7F7),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                                        child: Container(
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xffF7F7F7),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              child: Row(
                                                children: [
                                                  Image.asset('assets/images/user.png' , height: 40,),
                                                  SizedBox(width: 30,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      AutoSizeText(
                                                        'Customer Name',
                                                        style: TextStyle(
                                                            color: Theme.of(context).primaryColor,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      Row(
                                                        children: [
                                                          AutoSizeText(
                                                            'Surname',
                                                            style: TextStyle(
                                                                color: Theme.of(context).primaryColor,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w500),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          CircleAvatar(
                                                            radius: 5,
                                                            backgroundColor: Colors.grey,
                                                          ),
                                                          SizedBox(width: 5,),
                                                          AutoSizeText(
                                                            'shop@mail.com',
                                                            style: TextStyle(
                                                                color: Theme.of(context).primaryColor,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                      AutoSizeText(
                                                        '+49 1522 343333',
                                                        style: TextStyle(
                                                            color: Theme.of(context).primaryColor,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
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
      ),
      floatingActionButton: FloatingAddButton(
        onPresses: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewCustomerScreen()));
        },
      )
    );
  }
}