import '../config/config.dart' as def;
import '../storage/file_system/file_system.dart';
import '../storage/file_system/file_system_web.dart';
import '../storage/repositories/cache_info_repository.dart';
import '../storage/repositories/non_storing_object_provider.dart';
import '../web/file_service.dart';

class Config implements def.Config {
  Config(
    this.cacheKey, {
    Duration? stalePeriod,
    int? maxNrOfCacheObjects,
    CacheInfoRepository? repo,
    FileSystem? fileSystem,
    FileService? fileService,
  }) : stalePeriod = stalePeriod ?? const Duration(days: 30),
       maxNrOfCacheObjects = maxNrOfCacheObjects ?? 200,
       repo = repo ?? NonStoringObjectProvider(),
       fileSystem = fileSystem ?? MemoryCacheSystem(),
       fileService = fileService ?? HttpFileService();

  @override
  final CacheInfoRepository repo;

  @override
  final FileSystem fileSystem;

  @override
  final String cacheKey;

  @override
  final Duration stalePeriod;

  @override
  final int maxNrOfCacheObjects;

  @override
  final FileService fileService;
}
