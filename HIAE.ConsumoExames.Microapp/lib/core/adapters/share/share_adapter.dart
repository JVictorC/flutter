import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

import '../../singletons/context_key.dart';
import 'share_interface.dart';

class ShareAdapter implements IShareAdapter {
  @override
  Future<void> share(String title) async {
    await Share.share(
      title,
    );
  }

  @override
  Future<void> shareFiles(List<String> directoryFile, String? title) async {
    final box = ContextUtil().context!.findRenderObject() as RenderBox?;
    await Share.shareFiles(
      directoryFile,
      text: title,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
