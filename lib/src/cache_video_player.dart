import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import 'cache_key_helpers.dart';

class CacheVideoPlayer {
  CacheVideoPlayer.networkUrl(
    Uri url, {
    this.formatHint,
    this.closedCaptionFile,
    this.videoPlayerOptions,
    this.httpHeaders = const <String, String>{},
    Map<String, String>? downloadHeaders,
    this.viewType = VideoViewType.textureView,
    this.invalidateCacheIfOlderThan = const Duration(days: 30),
    this.skipCache = false,
    String? cacheKey,
  }) : dataSource = url.toString(),
       dataSourceType = DataSourceType.network,
       package = null,
       _authHeaders = downloadHeaders ?? httpHeaders,
       _cacheKey = cacheKey != null ? getCustomCacheKey(cacheKey) : getCacheKey(url.toString());

  /// The URI to the video file. This will be in different formats depending on
  /// the [DataSourceType] of the original video.
  final String dataSource;

  /// HTTP headers used for the request to the [dataSource].
  /// Only for [CachedVideoPlayerPlus.networkUrl].
  /// Always empty for other video types.
  final Map<String, String> httpHeaders;

  /// HTTP headers used specifically for downloading the video file
  /// for caching purposes.
  ///
  /// This is useful when [httpHeaders] contains streaming-specific headers
  /// like 'Range' that should not be used when downloading the complete video
  /// file for caching.
  ///
  /// If not provided, [httpHeaders] will be used.
  final Map<String, String> _authHeaders;

  /// **Android only**. Will override the platform's generic file format
  /// detection with whatever is set here.
  final VideoFormat? formatHint;

  /// Describes the type of data source this [CachedVideoPlayerPlus]
  /// is constructed with.
  final DataSourceType dataSourceType;

  /// Provide additional configuration options (optional). Like setting the
  /// audio mode to mix.
  final VideoPlayerOptions? videoPlayerOptions;

  /// Only set for [CachedVideoPlayerPlus.asset] videos. The package that the
  /// asset was loaded from.
  final String? package;

  /// The closed caption file to be used with the video.
  ///
  /// This is only used if the video player supports closed captions.
  final Future<ClosedCaptionFile>? closedCaptionFile;

  /// The requested display mode for the video.
  ///
  /// Platforms that do not support the request view type will ignore this.
  final VideoViewType viewType;

  /// If the requested network video is cached already, checks if the cache is
  /// older than the provided [Duration] and re-fetches data.
  final Duration invalidateCacheIfOlderThan;

  /// If set to true, it will skip the cache and use the video from the network.
  final bool skipCache;

  /// The cache key used for caching operations. This is used to uniquely
  /// identify the cached video file.
  final String _cacheKey;

  /// The underlying video player controller that handles actual video playback.
  late final VideoPlayerController _videoPlayerController;

  /// The controller for the video player.
  ///
  /// This provides access to the underlying [VideoPlayerController] for video
  /// playback operations like play, pause, seek, and accessing video state.
  ///
  ///  Always call [initialize] before accessing this property.
  Future<VideoPlayerController> get controller async {
    await _initializedCompleter.future;
    return _videoPlayerController;
  }

  /// 是否初始化标记，保证只调用初始化一次
  bool _hasInit = false;

  bool _hasDisposed = false;

  /// Whether the [CachedVideoPlayerPlus] instance is initialized.
  final _initializedCompleter = Completer();

  /// Returns true if the [CachedVideoPlayerPlus] instance is initialized.
  ///
  /// This getter indicates whether [initialize] has been successfully called
  /// and the video player is ready for use.
  bool get isInitialized => _initializedCompleter.isCompleted;

  /// Returns true if caching is supported and [skipCache] is false.
  ///
  /// Caching is only supported for network data sources. Asset, file, and
  /// contentUri data sources always return false.
  bool get _shouldUseCache {
    return dataSourceType == DataSourceType.network && !kIsWeb && !skipCache;
  }

  Future<void> initialize() async {
    if (_hasDisposed) {
      throw StateError('MultiVideoPlayer has Disposed.');
    }
    if (_hasInit) {
      return _initializedCompleter.future;
    }
    _hasInit = true;

    // 确定数据源
    late String realDataSource;
    if (_shouldUseCache) {
      realDataSource = dataSource;
    } else {
      realDataSource = dataSource;
    }

    _videoPlayerController = switch (dataSourceType) {
      DataSourceType.asset => VideoPlayerController.asset(
        realDataSource,
        package: package,
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: videoPlayerOptions,
        viewType: viewType,
      ),
      DataSourceType.network when skipCache => VideoPlayerController.networkUrl(
        Uri.parse(realDataSource),
        formatHint: formatHint,
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: videoPlayerOptions,
        httpHeaders: httpHeaders,
        viewType: viewType,
      ),
      DataSourceType.contentUri => VideoPlayerController.contentUri(
        Uri.parse(realDataSource),
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: videoPlayerOptions,
        viewType: viewType,
      ),
      _ => VideoPlayerController.file(
        File(realDataSource),
        closedCaptionFile: closedCaptionFile,
        videoPlayerOptions: videoPlayerOptions,
        httpHeaders: httpHeaders,
        viewType: viewType,
      ),
    };

    await _videoPlayerController.initialize();
    _initializedCompleter.complete();
  }

  Future<void> disposed() async {
    _hasDisposed = true;
  }
}
