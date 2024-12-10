import 'package:flutter/services.dart';

import 'clipboard_adapter_skeleton.dart';

class ClipboardAdapter extends ClipboardAdapterSkeleton {
  @override
  void copyToClipboard(String content) {
      ClipboardData cdata = ClipboardData(
          text: content);
      Clipboard.setData(cdata);
  }



}