import 'package:clock/clock.dart';

///Cache information of one file
class CacheObject {
  static const columnId = '_id';
  static const columnUrl = 'url';
  static const columnKey = 'key';
  static const columnPath = 'relativePath';
  static const columnETag = 'eTag';
  static const columnValidTill = 'validTill';
  static const columnTouched = 'touched';
  static const columnLength = 'length';
  static const columnContentLength = "content_length";
  static const columnComplete = "complete";

  CacheObject(
    this.url, {
    String? key,
    required this.relativePath,
    required this.validTill,
    this.eTag,
    this.id,
    this.length,
    this.contentLength,
    this.touched,
    this.complete,
  }) : key = key ?? url;

  CacheObject.fromMap(Map<String, dynamic> map)
    : id = map[columnId] as int,
      url = map[columnUrl] as String,
      key = map[columnKey] as String? ?? map[columnUrl] as String,
      relativePath = map[columnPath] as String,
      validTill = DateTime.fromMillisecondsSinceEpoch(map[columnValidTill] as int),
      eTag = map[columnETag] as String?,
      length = map[columnLength] as int?,
      contentLength = map[columnContentLength] as int?,
      touched = DateTime.fromMillisecondsSinceEpoch(map[columnTouched] as int),
      complete = map[columnComplete] as int?;

  /// Internal ID used to represent this cache object
  final int? id;

  /// The URL that was used to download the file
  final String url;

  /// The key used to identify the object in the cache.
  ///
  /// This key is optional and will default to [url] if not specified
  final String key;

  /// Where the cached file is stored
  final String relativePath;

  /// When this cached item becomes invalid
  final DateTime validTill;

  /// eTag provided by the server for cache expiry
  final String? eTag;

  /// The length of the cached file
  final int? length;

  /// The content length of the Response
  final int? contentLength;

  /// When the file is last used
  final DateTime? touched;

  /// Weather the file is download complete
  final int? complete;

  Map<String, dynamic> toMap({bool setTouchedToNow = true}) {
    final map = <String, dynamic>{
      columnUrl: url,
      columnKey: key,
      columnPath: relativePath,
      columnETag: eTag,
      columnValidTill: validTill.millisecondsSinceEpoch,
      columnTouched: (setTouchedToNow ? clock.now() : touched)?.millisecondsSinceEpoch ?? 0,
      columnLength: length,
      columnContentLength: contentLength,
      columnComplete: complete,
      if (id != null) columnId: id,
    };
    return map;
  }

  static List<CacheObject> fromMapList(List<Map<String, dynamic>> list) {
    return list.map((map) => CacheObject.fromMap(map)).toList();
  }

  CacheObject copyWith({
    String? url,
    int? id,
    String? relativePath,
    DateTime? validTill,
    String? eTag,
    int? length,
    int? contentLength,
    int? complete,
  }) {
    return CacheObject(
      url ?? this.url,
      id: id ?? this.id,
      key: key,
      relativePath: relativePath ?? this.relativePath,
      validTill: validTill ?? this.validTill,
      eTag: eTag ?? this.eTag,
      length: length ?? this.length,
      contentLength: contentLength ?? this.contentLength,
      complete: complete ?? this.complete,
      touched: touched,
    );
  }
}
