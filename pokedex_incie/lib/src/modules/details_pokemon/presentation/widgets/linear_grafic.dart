// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class LinearGraphic extends StatelessWidget {
  const LinearGraphic({
    Key? key,
    required this.points,
    required this.label,
    required this.color,
  }) : super(key: key);

  final double points;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: points / 100,
            backgroundColor: Colors.white,
            color: color,
            minHeight: 10,
          ),
        )
      ],
    );
  }
}
