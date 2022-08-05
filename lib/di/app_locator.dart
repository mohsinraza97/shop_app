import 'package:get_it/get_it.dart';
import 'package:shop_app/ui/view_models/product/product_list_view_model.dart';
import 'package:shop_app/ui/view_models/product/product_view_model.dart';
import '../data/repositories/entities/auth_repository.dart';
import '../data/services/entities/auth_service.dart';
import '../data/repositories/entities/order_repository.dart';
import '../data/services/entities/order_service.dart';
import '../data/repositories/entities/product_repository.dart';
import '../data/services/entities/product_service.dart';
import '../data/services/local/storage_service.dart';
import '../data/services/local/database_service.dart';
import '../data/services/remote/network_service.dart';
import '../data/repositories/local/database_repository.dart';
import '../data/repositories/local/storage_repository.dart';
import '../data/repositories/remote/network_repository.dart';

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

  // view models
  locator.registerFactory(() => ProductListViewModel());
  locator.registerFactory(() => ProductViewModel());
}
