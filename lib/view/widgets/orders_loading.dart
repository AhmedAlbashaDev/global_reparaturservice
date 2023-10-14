import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../core/globals.dart';
import 'custom_shimmer.dart';

class OrdersLoading extends StatelessWidget {
  const OrdersLoading({super.key ,required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText.rich(
                    TextSpan(text: title, children: const [
                      TextSpan(
                          text: ' ( - )',
                          style: TextStyle(
                              fontSize: 15,
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
                        onPressed: null,
                        child: Image.asset(
                          'assets/images/search.png',
                          height: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context , index){
              return SizedBox(
                width: screenWidth * 100,
                height: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex:2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedShimmerContainer(
                            height: 15,
                            width: screenWidth * 55,
                          ),
                          const SizedBox(height: 5,),
                          RoundedShimmerContainer(
                            height: 10,
                            width: screenWidth * 40,
                          ),
                          const SizedBox(height: 5,),
                          const RoundedShimmerContainer(
                            height: 35,
                            width: 80,
                            radius: 20,
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedShimmerContainer(
                            height: 20,
                            width: 80,
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
