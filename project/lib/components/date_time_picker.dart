import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:tbib_style/style/font_style.dart';

Widget defaultDateTimePicker({
  required BuildContext context,
  required TextEditingController controller,
  DateTimePickerType type = DateTimePickerType.dateTime,
  String mask = 'd MM, yyyy - hh:mm a',
  String? dateLabel,
  String? timeLabel,
  String? label,
  IconData? prefix,
  dynamic suffixPressed,
  IconData? suffix,
  required dynamic validator,
  bool use24 = false,
}) {
  return DateTimePicker(
    controller: controller,
    type: type,
    dateMask: mask,
    firstDate: DateTime(DateTime.now().year - 1000),
    lastDate: DateTime(DateTime.now().year + 1000),
    validator: validator,
    icon: const Icon(Icons.event),
    dateLabelText: dateLabel,
    style: TBIBFontStyle.h4,
    timeLabelText: timeLabel,
    use24HourFormat: use24,
    locale: const Locale('en', 'US'),
    decoration: label != null
        ? InputDecoration(
            prefixIcon: Icon(
              prefix,
            ),
            suffixIcon: suffix != null
                ? IconButton(
                    onPressed: suffixPressed,
                    icon: Icon(
                      suffix,
                    ),
                  )
                : null,
            labelText: label,
            labelStyle: TBIBFontStyle.h4,
            border: const OutlineInputBorder(),
          )
        : null,
  );
}
