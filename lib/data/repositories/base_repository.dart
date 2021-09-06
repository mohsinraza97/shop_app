import 'package:flutter/material.dart';
import '../../utils/utilities/internet_utils.dart';
import '../services/local/database_service.dart';
import '../services/local/storage_service.dart';
import '../services/remote/network_service.dart';
import '../app_locator.dart';
import '../services/base_service.dart';

// In such implementation the view models don't actually have to know anything
// about the data source (network, storage, database)

// A concrete implementation to service contract
class BaseRepository implements BaseService {
  @protected
  final networkService = locator<NetworkService>();
  @protected
  final storageService = locator<StorageService>();
  @protected
  final databaseService = locator<DatabaseService>();

  @override
  @protected
  Future<bool> hasInternet() async {
    return await InternetUtils.isInternetAvailable();
  }
}
