import 'package:http/http.dart' as http;
import '../../../utils/utilities/json_utils.dart';
import '../../models/entities/user.dart';
import '../../models/network/add_response.dart';
import '../../models/entities/order.dart';
import '../../../utils/utilities/log_utils.dart';
import '../../enums/network_response_type.dart';
import '../../enums/network_request_type.dart';
import '../../../ui/resources/app_strings.dart';
import '../../models/network/api_response.dart';
import '../../services/local/storage_service.dart';
import '../../app_locator.dart';
import '../../models/entities/product.dart';
import '../../../utils/constants/network_constants.dart';
import '../../services/remote/network_service.dart';
import 'network_client.dart';

class NetworkRepository implements NetworkService {
  final _storageService = locator<StorageService>();

  // region auth
  @override
  Future<ApiResponse<User>> signUp(UserRequest? userRequest) async {
    final response = await NetworkClient.instance.request(
      NetworkRequestType.post,
      baseUrl: NetworkConstants.base_url_authentication,
      endpoint: '${NetworkConstants.sign_up}${NetworkConstants.api_key}',
      body: userRequest?.toJson(),
    );
    return _handleAuthResponse(response);
  }

  @override
  Future<ApiResponse<User>> login(UserRequest? userRequest) async {
    final response = await NetworkClient.instance.request(
      NetworkRequestType.post,
      baseUrl: NetworkConstants.base_url_authentication,
      endpoint: '${NetworkConstants.login}${NetworkConstants.api_key}',
      body: userRequest?.toJson(),
    );
    return _handleAuthResponse(response);
  }

  ApiResponse<User> _handleAuthResponse(http.Response? response) {
    final apiResponse = _getApiResponse<User>(response, (data) {
      return data != null ? User.fromJson(data) : null;
    });
    // Handling these errors because Firebase doesn't provide a consistent
    // response format for success/error case for each API. In actual,
    // we'll also handle error payload in to our generic API response parsing
    if (apiResponse.code == NetworkConstants.response_bad_request) {
      final responseData = JsonUtils.fromJson(response?.body);
      if (responseData != null) {
        String? errMsg = responseData!['error']['message'];
        if (errMsg?.contains('EMAIL_EXISTS') ?? false) {
          apiResponse.message = AppStrings.error_auth_email_exists;
        } else if (errMsg?.contains('EMAIL_NOT_FOUND') ?? false) {
          apiResponse.message = AppStrings.error_auth_email_not_found;
        } else if (errMsg?.contains('INVALID_PASSWORD') ?? false) {
          apiResponse.message = AppStrings.error_auth_invalid_password;
        }
      }
    }
    return apiResponse;
  }
  // endregion

  // region product
  @override
  Future<ApiResponse<List<Product>>> fetchProducts(bool filterByUser) async {
    final user = await _storageService.getCurrentUser();
    final accessToken = await _storageService.getAccessToken();
    final favoriteProductsResponse = await _fetchUserFavoriteProducts(user?.id, accessToken);
    String fetchProductsEndpoint = NetworkConstants.fetch_products;
    if (filterByUser) {
      fetchProductsEndpoint += '?orderBy="UserId"&equalTo="${user?.id}"';
    }
    final productsResponse = await NetworkClient.instance.request(
      NetworkRequestType.get,
      token: accessToken,
      endpoint: fetchProductsEndpoint,
    );
    return _getApiResponse<List<Product>>(productsResponse, (data) {
      return data != null
          ? ProductFetchResponse.fromJson(
              data,
              favoriteProductsResponse.data,
            ).products
          : null;
    });
  }

  @override
  Future<ApiResponse<AddResponse>> addProduct(Product? product) async {
    final user = await _storageService.getCurrentUser();
    product?.userId = user?.id;

    final accessToken = await _storageService.getAccessToken();
    final response = await NetworkClient.instance.request(
      NetworkRequestType.post,
      token: accessToken,
      endpoint: NetworkConstants.add_product,
      body: product?.toJson(),
    );
    return _getApiResponse<AddResponse>(response, (data) {
      return data != null ? AddResponse.fromJson(data) : null;
    });
  }

  @override
  Future<ApiResponse<Product>> updateProduct(Product? product) async {
    final user = await _storageService.getCurrentUser();
    product?.userId = user?.id;

    final accessToken = await _storageService.getAccessToken();
    final response = await NetworkClient.instance.request(
      NetworkRequestType.patch,
      token: accessToken,
      endpoint: '${NetworkConstants.modify_product}${product?.id}.json',
      body: product?.toJson(),
    );
    return _getApiResponse<Product>(response, (data) {
      return data != null ? Product.fromJson(data) : null;
    });
  }

  @override
  Future<ApiResponse<bool>> updateProductFavoriteStatus(
      Product? product) async {
    final user = await _storageService.getCurrentUser();
    final accessToken = await _storageService.getAccessToken();
    final response = await NetworkClient.instance.request(
      NetworkRequestType.put,
      token: accessToken,
      endpoint: '${NetworkConstants.modify_favorite_product}${user?.id}/${product?.id}.json',
      body: product?.isFavorite,
    );
    return _getApiResponse<bool>(response, (data) => data);
  }

  @override
  Future<ApiResponse<bool>> deleteProduct(String? id) async {
    final accessToken = await _storageService.getAccessToken();
    final response = await NetworkClient.instance.request(
      NetworkRequestType.delete,
      token: accessToken,
      endpoint: '${NetworkConstants.modify_product}$id.json',
    );
    final apiResponse = _getApiResponse<bool>(response, (data) => data);
    if (apiResponse.data == null &&
        apiResponse.code == NetworkConstants.response_success_ok) {
      apiResponse.data = true;
    }
    return apiResponse;
  }

  Future<ApiResponse<Map<String, dynamic>>> _fetchUserFavoriteProducts(
    String? userId,
    String? accessToken,
  ) async {
    final response = await NetworkClient.instance.request(
      NetworkRequestType.get,
      token: accessToken,
      endpoint: '${NetworkConstants.modify_favorite_product}$userId.json',
    );
    return _getApiResponse<Map<String, dynamic>>(response, (data) => data);
  }
  // endregion

  // region order
  @override
  Future<ApiResponse<List<Order>>> fetchOrders() async {
    final user = await _storageService.getCurrentUser();
    final accessToken = await _storageService.getAccessToken();
    final response = await NetworkClient.instance.request(
      NetworkRequestType.get,
      token: accessToken,
      endpoint: '${NetworkConstants.fetch_orders}${user?.id}.json',
    );
    return _getApiResponse<List<Order>>(response, (data) {
      return data != null ? OrderFetchResponse.fromJson(data).orders : null;
    });
  }

  @override
  Future<ApiResponse<AddResponse>> addOrder(Order? order) async {
    final user = await _storageService.getCurrentUser();
    final accessToken = await _storageService.getAccessToken();
    final response = await NetworkClient.instance.request(
      NetworkRequestType.post,
      token: accessToken,
      endpoint: '${NetworkConstants.add_order}${user?.id}.json',
      body: order?.toJson(),
    );
    return _getApiResponse<AddResponse>(response, (data) {
      return data != null ? AddResponse.fromJson(data) : null;
    });
  }
  // endregion

  // region helpers
  ApiResponse<T> _getApiResponse<T>(
    http.Response? response,
    Function(dynamic data) create,
  ) {
    try {
      final type = _getNetworkResponseType(response);
      final body = response?.body;
      if (type == NetworkResponseType.success) {
        return ApiResponse.fromRawJson(
          _getNetworkResponseBody(body),
          (data) => create(data),
        );
      } else if (type == NetworkResponseType.bad_request) {
        return ApiResponse(
          message: AppStrings.error_bad_request,
          code: NetworkConstants.response_bad_request,
        );
      } else if (type == NetworkResponseType.unauthorized) {
        return ApiResponse(
          message: AppStrings.error_session_expire,
          code: NetworkConstants.response_unauthorized,
        );
      }
      return ApiResponse(message: body ?? AppStrings.error_unknown);
    } catch (e) {
      LogUtils.error('NetworkRepository', '_getApiResponse<T>', e.toString());
      return ApiResponse(message: AppStrings.error_unknown);
    }
  }

  NetworkResponseType _getNetworkResponseType(http.Response? response) {
    final status = response?.statusCode;
    if (NetworkConstants.response_success_list.contains(status)) {
      return NetworkResponseType.success;
    } else if (status == NetworkConstants.response_bad_request) {
      return NetworkResponseType.bad_request;
    } else if (status == NetworkConstants.response_unauthorized) {
      return NetworkResponseType.unauthorized;
    } else {
      return NetworkResponseType.unknown;
    }
  }

  String _getNetworkResponseBody(String? body) {
    return '${NetworkConstants.success_base_response_start}'
        '${body ?? ''}'
        '${NetworkConstants.success_base_response_end}';
  }
  // endregion
}
