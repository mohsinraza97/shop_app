import 'package:get_it/get_it.dart';
import 'repositories/entities/auth_repository.dart';
import 'services/entities/auth_service.dart';
import 'repositories/entities/order_repository.dart';
import 'services/entities/order_service.dart';
import 'repositories/entities/product_repository.dart';
import 'services/entities/product_service.dart';
import 'services/local/storage_service.dart';
import 'services/local/database_service.dart';
import 'services/remote/network_service.dart';
import 'repositories/local/database_repository.dart';
import 'repositories/local/storage_repository.dart';
import 'repositories/remote/network_repository.dart';

// Using GetIt is a convenient way to provide objects anywhere we need them in the app
GetIt locator = GetIt.instance;

void initLocator() {
  // services
  locator.registerLazySingleton<NetworkService>(() => NetworkRepository());
  locator.registerLazySingleton<StorageService>(() => StorageRepository());
  locator.registerLazySingleton<DatabaseService>(() => DatabaseRepository());
  locator.registerLazySingleton<ProductService>(() => ProductRepository());
  locator.registerLazySingleton<OrderService>(() => OrderRepository());
  locator.registerLazySingleton<AuthService>(() => AuthRepository());
}
