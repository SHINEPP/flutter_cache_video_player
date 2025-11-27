import 'package:file/file.dart' show File;
import 'package:file/memory.dart';

import 'file_system.dart';

class MemoryCacheSystem implements FileSystem {
  final directory = MemoryFileSystem().systemTempDirectory.createTemp('cache');

  @override
  Future<File> createFile(String name) async {
    return (await directory).childFile(name);
  }
}
