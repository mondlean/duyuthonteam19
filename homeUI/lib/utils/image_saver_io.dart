import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String> platformSaveReceiptImage(Uint8List bytes) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final receiptDir = Directory('${docsDir.path}/receiptimg');

  if (!await receiptDir.exists()) {
    await receiptDir.create(recursive: true);
  }

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final dest = File('${receiptDir.path}/receipt_$timestamp.jpg');
  await dest.writeAsBytes(bytes);
  return dest.path;
}
