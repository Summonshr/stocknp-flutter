import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Storage {
  store(key, value) {
    getApplicationDocumentsDirectory().then((dir) {
      String path = dir.path;
      File file = File('$path/$key.json');
      file.writeAsString(value);
    });
  }

  read(key, callback) async {
    getApplicationDocumentsDirectory().then((dir) {
      String path = dir.path;
      File file = File('$path/$key.json');
      if (!file.existsSync()) {
        return;
      }
      String json = file.readAsStringSync();
      callback(json);
    });
  }
}
