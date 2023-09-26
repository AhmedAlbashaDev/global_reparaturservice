import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, required this.fadeInFadeOut, required this.searchController, required this.onClose, this.onChanged, required this.enabled});

  final Animation<double> fadeInFadeOut;
  final TextEditingController searchController;
  final VoidCallback onClose;
  final dynamic onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeInFadeOut,
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(right: 35),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
          ),
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              controller: searchController,
              maxLines: 1,
              onChanged: onChanged,
              enabled: enabled,
              decoration: InputDecoration(
                  hintText: 'search'.tr(),
                  suffixIcon: IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                  border: InputBorder.none
              ),
            ),
          ),
        ),
      ),
    );
  }
}
