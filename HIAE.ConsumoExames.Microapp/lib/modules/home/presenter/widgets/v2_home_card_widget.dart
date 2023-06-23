import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class V2HomeCardWidget extends StatelessWidget {
  final String text;
  final Widget icon;
  final void Function()? onTap;
  const V2HomeCardWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          height: 170,
          width: 164,
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 15),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(27, 28, 29, 0.15),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: ZeraColors.primaryMedium,
                  borderRadius: BorderRadius.circular(64),
                ),
                child: Center(
                  child: icon,
                ),
              ),
              const SizedBox(height: 11),
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: Align(
                    alignment: Alignment.center,
                    child: ZeraText(
                      text,
                      textAlign: TextAlign.center,
                      theme: ZeraTextTheme(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: ZeraColors.neutralDark,
                        lineHeight: 1.28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
