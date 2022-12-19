import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/utils/text_utils.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final List<String> options;
  final Function(String?)? onChanged;
  final String selectionOption;
  const CustomRadioButton({ Key? key, 
    required this.options,
    required this.onChanged,
    required this.selectionOption
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((e) => Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio(
              value: e, 
              groupValue: selectionOption, 
              onChanged: onChanged,
              activeColor: Themes.colorSecondary
            ),
            Text(TextUtils.capitalizeFirstLetterWithSpaces(e)),
            const SizedBox(width: 20,)
          ],
        ),
      )).toList(),
    );
  }
}