import 'dart:async';

import '../cache_object.dart';

/// Base class for cache info repositories
abstract class CacheInfoRepository {
  /// Returns whether or not there is an existing data file with cache info.
  Future<bool> exists();

  /// Opens the repository, or just returns true if the repo is already open.
  Future<bool> open();

  /// Updates a given [CacheObject], if it exists, or adds a new item to the repository
  Future<dynamic> updateOrInsert(CacheObject cacheObject);

  /// Inserts [cacheObject] into the repository
  Future<CacheObject> insert(CacheObject cacheObject, {bool setTouchedToNow = true});

  /// Gets a [CacheObject] by [key]
  Future<CacheObject?> get(String key);

  /// Deletes a cache object by [id]
  Future<int> delete(int id);

  /// Deletes items with [ids] from the repository
  Future<int> deleteAll(Iterable<int> ids);

  /// Updates an existing [cacheObject]
  Future<int> update(CacheObject cacheObject, {bool setTouchedToNow = true});

  /// Gets the list of all objects in the cache
  Future<List<CacheObject>> getAllObjects();

  /// Gets the list of [CacheObject] that can be removed if the repository is over capacity.
  ///
  /// The exact implementation is up to the repository, but implementations should
  /// return a preferred list of items. For example, the least recently accessed
  Future<List<CacheObject>> getObjectsOverCapacity(int capacity);

  /// Returns a list of [CacheObject] that are older than [maxAge]
  Future<List<CacheObject>> getOldObjects(Duration maxAge);

  /// Close the connection to the repository. If this is the last connection
  /// to the repository it will return true and the repository is truly
  /// closed. If there are still open connections it will return false;
  Future<bool> close();

  /// Deletes the cache data file including all cache data.
  Future<void> deleteDataFile();
}
