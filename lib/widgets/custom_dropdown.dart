import 'package:adopt_us/config/device.dart';
import 'package:adopt_us/utils/text_utils.dart';
import 'package:flutter/material.dart';


class CustomDropdown extends StatelessWidget {
  final String? hintText;
  final List<String> items;
  final String? value;
  final Function(String?)? onChanged;
  const CustomDropdown({ Key? key,
    this.hintText,
    required this.items,
    required this.value,
    required this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        elevation: 3,
        hint: hintText!=null
          ? Text(
              hintText!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              )
            )
          : null,
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              TextUtils.capitalizeFirstLetterWithSpaces(item),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              )
            ),
          );
        }).toList(),
        // isExpanded: true,
        onChanged: onChanged,
        decoration: const InputDecoration(filled: true),
      )
    );
  }
}