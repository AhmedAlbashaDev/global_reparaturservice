import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/search_field_status.dart';
import '../../../widgets/search.dart';

class UsersTechniciansTab extends ConsumerWidget {
  const UsersTechniciansTab({super.key, required this.animation, required this.fadeInFadeOut, required this.searchController, required this.onClose, this.onChanged});

  final AnimationController animation;
  final Animation<double> fadeInFadeOut;
  final TextEditingController searchController;
  final VoidCallback onClose;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 4),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText.rich(
                      TextSpan(
                          text: 'technicians'.tr(),
                          children: const [
                            TextSpan(
                                text: ' (15)',
                                style: TextStyle(
                                    fontSize: 15  ,
                                    fontWeight: FontWeight.w500
                                )
                            )
                          ]
                      ),
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
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onPressed: (){
                            ref.read(searchFieldStatusProvider.notifier).state = true;
                            animation.forward();
                          },
                          child: Image.asset('assets/images/search.png' , height: 20,),
                        ),
                      ),
                    )
                  ],
                ),
                SearchWidget(
                  fadeInFadeOut: fadeInFadeOut,
                  searchController: searchController,
                  onChanged: (text){
                  },
                  onClose: (){
                    ref.read(searchFieldStatusProvider.notifier).state = false;
                    animation.reverse();
                  },
                  enabled: ref.watch(searchFieldStatusProvider),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context , index){
                return Container(
                    margin: EdgeInsets.all(5),
                    child: MaterialButton(
                      onPressed: (){},
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
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffF7F7F7),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        'Technician Name',
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10,),
                                      AutoSizeText(
                                        '+49 1522 343333',
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: (){},
                                    icon: Image.asset('assets/images/edit.png' , height: 20,),
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
    );
  }
}
