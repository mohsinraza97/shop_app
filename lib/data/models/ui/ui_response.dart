import '../network/api_response.dart';

class UiResponse<T> {
  T? data;
  String? errorMessage;

  UiResponse({
    this.data,
    this.errorMessage,
  });

  UiResponse.map(ApiResponse? response) {
    if (response?.hasData ?? false) {
      data = response?.data;
    }
    if (response?.hasError ?? false) {
      errorMessage = response?.message;
    }
  }

  bool get hasData => data != null;

  bool get hasError => errorMessage?.isNotEmpty ?? false;
}
