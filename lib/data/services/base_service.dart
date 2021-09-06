// Using an abstract class like this allows you to swap concrete implementations.
// This is useful for separating architectural layers.
// It also makes testing and development easier because you can provide a mock implementation or fake data.
// By simply creating another concrete implementation like FakeNetworkRepository

// A service contract
abstract class BaseService {
  Future<bool> hasInternet();
}
