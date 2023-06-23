import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/material.dart';

class RadioButtonI18n extends StatefulWidget {
  final String groupValue;
  final String value;
  final String text;
  final String flag;
  final Function(String?) onTap;
  const RadioButtonI18n({
    required this.value,
    required this.text,
    required this.onTap,
    required this.groupValue,
    required this.flag,
    Key? key,
  }) : super(key: key);

  @override
  State<RadioButtonI18n> createState() => _RadioButtonI18nState();
}

class _RadioButtonI18nState extends State<RadioButtonI18n> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio<String>(
          value: widget.value,
          groupValue: widget.groupValue,
          onChanged: widget.onTap,
          activeColor: Colors.green,
        ),
        Image.asset(
          'assets/${widget.flag}.png',
          width: 32,
          height: 36,
        ),
        const SizedBox(
          width: 10.0,
        ),
        ZeraText(
          widget.text,
          //color: ZeraColors.primaryMedium,
          color: ZeraColors.primaryDark,
          //type: ZeraTextType.BOLD_16_DARK_01,
          theme: const ZeraTextTheme(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
