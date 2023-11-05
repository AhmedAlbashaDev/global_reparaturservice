import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/routes.dart';
import 'package:jiffy/jiffy.dart';

import '../../core/providers/app_mode.dart';
import '../../view_model/routes_view_model.dart';
import '../screens/bottom_menu/routes/route_details_admin.dart';
import '../screens/bottom_menu/routes/route_details_technician_map.dart';

class RouteCard extends ConsumerWidget {
  const RouteCard({super.key ,required this.routesModel});

  final RoutesModel? routesModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        onPressed: (){
          if(ref.read(currentAppModeProvider.notifier).state == AppMode.admins){
            Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailsAdmin(routeId: routesModel!.id)
            ));
          }
          else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailsTechnician(routeId: routesModel!.id)
            )).then((value) {
              ref.read(routesViewModelProvider.notifier).loadAll();
            });
          }
        },
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        clipBehavior: Clip.antiAlias,
        elevation: .5,
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      routesModel!.referenceNo,
                      style: TextStyle(
                          color:
                          Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8,),
                    AutoSizeText(
                      routesModel!.driver?.name ?? 'no_driver_assigned'.tr(),
                      style: TextStyle(
                          color:
                          Theme.of(context).primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    AutoSizeText(
                      Jiffy.parse(routesModel!.createdAt.toString()).format(pattern: 'dd/MM/yyyy hh:mm a'),
                      style: TextStyle(
                          color:
                          Theme.of(context).primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: AutoSizeText(
                  routesModel!.statusName,
                  style: TextStyle(
                      color: routesModel!.status == 3 ? Colors.green : const Color(0xFFE2BC37),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
