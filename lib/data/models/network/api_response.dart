import '../../../utils/utilities/json_utils.dart';
import '../base_model.dart';

class ApiResponse<T> implements BaseModel {
  bool? success;
  int? code;
  String? message;
  T? data;

  ApiResponse({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  bool get hasData => data != null;

  bool get hasError => success == null || success == false;

  factory ApiResponse.fromRawJson(
    String rawJson,
    Function(dynamic data) create,
  ) {
    return ApiResponse.fromJson(JsonUtils.fromJson(rawJson), create: create);
  }

  // Here function "create" is very important, this basically gives the control back from where this
  // ApiResponse.fromJson method is called so that data model against the "data" key can be easily created
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    Function(dynamic data)? create,
  }) {
    return ApiResponse<T>(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: create == null ? json['data'] : create(json['data']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'message': message,
      'data': data,
    };
  }
}
