import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../screens/bottom_menu/orders/select_or_add_customer.dart';
import 'custom_button.dart';

class CustomerCardNewOrder extends StatelessWidget {
  const CustomerCardNewOrder({super.key, required this.empty});

  final bool empty;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFDBDBDB)),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
      ),
      padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 6),
      child: empty
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/user.png' , height: 45,),
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 10,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFDBDBDB).withOpacity(.6)
                      ),
                    ),
                    Container(
                      height: 10,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFDBDBDB).withOpacity(.6)
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFDBDBDB).withOpacity(.6)
                          ),
                        ),
                        SizedBox(width: 5,),
                        Container(
                          height: 10,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFDBDBDB).withOpacity(.6)
                          ),
                        ),
                        SizedBox(width: 5,),
                        Container(
                          height: 10,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFDBDBDB).withOpacity(.6)
                          ),
                        )
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),
          SizedBox(
              height: 50,
              child: CustomButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectOrAddCustomerScreen()));
              }, text: 'select'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor))
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/user.png' , height: 45,),
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
                    AutoSizeText(
                      '+49 1522 343333',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                    AutoSizeText(
                      'additional_info'.tr(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
              height: 50,
              child: CustomButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectOrAddCustomerScreen()));
              }, text: 'change'.tr(), textColor: Colors.white, bgColor: Color(0xffD51E1E)))
        ],
      ),
    );
  }
}
