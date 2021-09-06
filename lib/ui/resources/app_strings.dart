class AppStrings {
  const AppStrings._internal();

  static const String app_name = 'MyShop';

  // Drawer
  static const String drawer_home = 'Home';
  static const String drawer_orders = 'Orders';
  static const String drawer_products = 'Manage Products';
  static const String drawer_logout = 'Log out';

  // Pages
  static const String title_cart = 'Your Cart';
  static const String title_orders = 'Your Orders';
  static const String title_products = 'Your Products';
  static const String title_add_product = 'Add Product';
  static const String title_edit_product = 'Edit Product';

  // Tooltips
  static const String tooltip_more_options = 'More options';
  static const String tooltip_add_product = 'Add product';
  static const String tooltip_view_cart = 'View cart';
  static const String tooltip_save = 'Save';

  // Menu items
  static const String menu_item_favorites = 'Only Favorites';
  static const String menu_item_all = 'Show All';

  // Success
  static const String success_order_placement = 'Order placed successfully.';

  // Server errors
  static const String error_timeout = 'The connection to server timed out.';
  static const String error_internet_unavailable = 'Please check your internet connection and try again.';
  static const String error_bad_request = 'Couldn\'t process your request due to a bad request format.';
  static const String error_session_expire = 'Your session has been expired. Please re-login to continue using the app.';
  static const String error_unknown = 'An unknown error has occurred, please try again.';

  // General ui errors
  static const String error_ui_general = 'Oops! Something went wrong, please try again.';
  static const String error_no_data_found = 'No data available.';
  static const String error_product_empty = 'Product data must not be empty.';
  static const String error_product_not_found = 'Product data not found.';
  static const String error_auth_email_exists = 'The email address is already in use by another account.';
  static const String error_auth_email_not_found = 'There is no user data corresponding to this email address.';
  static const String error_auth_invalid_password = 'The password is invalid.';

  // Input fields & validation
  static const String input_field_email = 'Email Address';
  static const String input_field_password = 'Password';
  static const String input_field_confirm_password = 'Confirm Password';
  static const String input_field_title = 'Title';
  static const String input_field_price = 'Price';
  static const String input_field_description = 'Description';
  static const String input_field_image = 'Image URL';
  static const String validation_required = 'This is a required field.';
  static const String validation_invalid_email = 'Must be a valid email address.';
  static const String validation_invalid_password = 'Must be at least 8 characters long.';
  static const String validation_password_not_match = 'Passwords do not match.';
  static const String validation_invalid_price = 'Must be a valid number and greater than 0.';
  static const String validation_invalid_description = 'Must be at least 10 characters long.';
  static const String validation_invalid_image_url = 'Must be a valid URL.';
  static const String validation_invalid_image_type = 'Must be a valid image type (png, jpg or jpeg).';

  // General
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String no = 'No';
  static const String yes = 'Yes';
  static const String exit = 'Exit';
  static const String exit_message = 'Are you sure you want to exit the application?';
  static const String confirmation = 'Confirmation';
  static const String delete = 'Delete';
  static const String undo = 'Undo';
  static const String no_internet = 'No internet';
  static const String please_wait_a_moment = 'Please wait a moment...';
  static const String total = 'Total';
  static const String order_now = 'Order Now';
  static const String cart_empty = 'Your cart is empty.';
  static const String add_to_cart = 'Add to cart';
  static const String save = 'Save';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String login = 'Login';
  static const String sign_up = 'Sign up';
  static const String instead = 'Instead';
  static const String app_version = 'App version';
  static const String logout_message = 'Are you sure you want to log out?';
}