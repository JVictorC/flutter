import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class CustomZeraDivider extends StatelessWidget {
  const CustomZeraDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width > 600 || kIsWeb ? 56.0 : 0,
          right: MediaQuery.of(context).size.width > 600 || kIsWeb ? 56.0 : 0,
        ),
        child: ZeraDivider(),
      );
}
