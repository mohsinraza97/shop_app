class NetworkConstants {
  const NetworkConstants._internal();

  // region base urls / api keys
  static const String base_url = 'https://flutter-shop-app-1777-default-rtdb.firebaseio.com/';
  static const String base_url_authentication = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  static const String api_key = 'AIzaSyBVQRjewGMUhNKPoOaARbCsvutc5ex_H_c';
  // endregion

  // region endpoints
  static const String fetch_products = 'products.json';
  static const String add_product = fetch_products;
  static const String modify_product = 'products/';
  static const String fetch_favorite_products = 'favorite_products.json';
  static const String modify_favorite_product = 'favorite_products/';
  static const String fetch_orders = 'orders/';
  static const String add_order = fetch_orders;
  static const String sign_up = 'signUp?key=';
  static const String login = 'signInWithPassword?key=';
  // endregion

  // region response codes
  static const int response_success_ok = 200;
  static const int response_success_created = 201;
  static const int response_bad_request = 400;
  static const int response_unauthorized = 401;
  static const List<int> response_success_list = [response_success_ok, response_success_created];
  // endregion

  // region custom response code
  static const int response_timeout = -1;
  static const int response_internet_unavailable = -2;
  static const int response_unknown = -3;
  // endregion

  // {
  //   "success": true,
  //   "code": 200,
  //   "message": null,
  //   "data": null
  // }
  static const String success_base_response_start = "{    \"success\":true,    \"code\":200,    \"message\":null,    \"data\":";
  static const String success_base_response_end = " }";
}
