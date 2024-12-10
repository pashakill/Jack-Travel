import 'dart:js' as js;

import 'clipboard_adapter_skeleton.dart';

class ClipboardAdapter extends ClipboardAdapterSkeleton {
  @override
  void copyToClipboard(String content) {
    js.context.callMethod('copyToClipboard',
        ['orderref', content]);
  }



}