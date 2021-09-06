import 'dart:async';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;
import '../../../utils/utilities/json_utils.dart';
import '../../enums/network_request_type.dart';
import '../../../ui/resources/app_strings.dart';
import '../../../utils/constants/network_constants.dart';
import '../../../utils/utilities/log_utils.dart';

class NetworkClient {
  const NetworkClient._internal();

  static final NetworkClient _instance = NetworkClient._internal();

  static NetworkClient get instance => _instance;

  Future<http.Response?> request(
    NetworkRequestType requestType, {
    required String endpoint,
    String? token,
    String? baseUrl = NetworkConstants.base_url,
    dynamic body,
  }) async {
    Exception? exception;
    http.Response? response;
    var url = '$baseUrl$endpoint';
    if (baseUrl == NetworkConstants.base_url && (token?.isNotEmpty ?? false)) {
      final queryParamOperator = endpoint.contains('?') ? '&' : '?';
      final tokenQueryParam = 'auth=$token';
      url = '$baseUrl$endpoint$queryParamOperator$tokenQueryParam';
    }
    final uri = Uri.parse(url);
    try {
      body = JsonUtils.toJson(body);
      final headers = _getHeaders(token);
      _logRequest(
        EnumToString.convertToString(requestType),
        uri,
        token: token,
        body: body,
      );
      if (requestType == NetworkRequestType.get) {
        response = await http.get(uri, headers: headers);
      } else if (requestType == NetworkRequestType.post) {
        response = await http.post(uri, headers: headers, body: body);
      } else if (requestType == NetworkRequestType.put) {
        response = await http.put(uri, headers: headers, body: body);
      } else if (requestType == NetworkRequestType.patch) {
        response = await http.patch(uri, headers: headers, body: body);
      } else if (requestType == NetworkRequestType.delete) {
        response = await http.delete(uri, headers: headers, body: body);
      }
    } on TimeoutException catch (e) {
      exception = e;
      response = http.Response(
        AppStrings.error_timeout,
        NetworkConstants.response_timeout,
      );
    } on SocketException catch (e) {
      exception = e;
      response = http.Response(
        AppStrings.error_internet_unavailable,
        NetworkConstants.response_internet_unavailable,
      );
    } on Exception catch (e) {
      exception = e;
      response = http.Response(
        AppStrings.error_unknown,
        NetworkConstants.response_unknown,
      );
    }
    _logResponse(
      EnumToString.convertToString(requestType),
      uri,
      response: response,
      exception: exception,
    );
    return response;
  }

  Map<String, String> _getHeaders(String? token) {
    var headers = {'Content-Type': 'application/json'};
    // if (token?.isNotEmpty ?? false) {
    //   headers = {
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $token',
    //   };
    // }
    return headers;
  }

  void _logRequest(
    String requestType,
    Uri uri, {
    String? token,
    dynamic body,
  }) {
    try {
      var logMap = Map<String, String>();
      logMap['URL'] = uri.toString();
      logMap['Headers'] = _getHeaders(token).toString();
      if (body != null) {
        logMap['Body'] = body;
      }
      LogUtils.debug(
        'NetworkRequest',
        requestType.toUpperCase(),
        logMap.toString(),
      );
    } on Exception catch (ex) {
      LogUtils.error(
        'NetworkRequest',
        requestType.toUpperCase(),
        ex.toString(),
      );
    }
  }

  void _logResponse(
    String requestType,
    Uri uri, {
    http.Response? response,
    Exception? exception,
  }) {
    try {
      var logMap = Map<String, String>();
      logMap['URL'] = uri.toString();
      logMap['Response'] = 'Status: ${response?.statusCode} - ${response?.reasonPhrase}, Body: ${response?.body}';
      if (exception != null) {
        logMap['Exception'] = exception.toString();
      }
      LogUtils.debug(
        'NetworkResponse',
        requestType.toUpperCase(),
        logMap.toString(),
      );
    } on Exception catch (ex) {
      LogUtils.error(
        'NetworkResponse',
        requestType.toUpperCase(),
        ex.toString(),
      );
    }
  }
}
