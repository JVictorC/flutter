import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../constants/api_routes.dart';
import '../../constants/strings.dart';
import '../../di/initInjector.dart';
import '../../entities/user_auth_info.dart';
import '../../exceptions/exceptions.dart';
import '../check_internet_connection/check_internet_connection_interface.dart';
import 'client_extension.dart';
import 'client_response.dart';
import 'http_interface.dart';
import 'http_logger_interceptor.dart';
import 'http_retry_connection.dart';
import 'http_retry_interceptor.dart';

class HttpClient implements IHttpClient {
  final Dio _client;
  final int retryRequestAfterException = 2;

  HttpClient(this._client) {
    _client.options.baseUrl = ApiRoutes.baseUrl;
    _client.options.connectTimeout = 5000;
    _client.options.receiveTimeout = 50000;
    _client.options.responseType = ResponseType.json;
    _client.options.contentType = Headers.jsonContentType;

    if (kDebugMode) {
      _client.interceptors.add(HttpLoggerInterceptor());
    }

    _client.interceptors.add(
      HttpRetryInterceptor(
        httpRetryHttpConnection: HttpRetryHttpConnection(
          retry: retryRequestAfterException,
        ),
      ),
    );
  }

  Map<String, dynamic> _setHeaders(Map<String, dynamic>? headers) {
    String? appToken;

    if (I.isRegistered<UserAuthInfoEntity>()) {
      appToken = I.getDependency<UserAuthInfoEntity>().token;
    }

    if (headers != null && !headers.containsKey('Authorization')) {
      headers['Authorization'] = 'Bearer $appToken';
    }

    final Map<String, dynamic> headerAuthorization =
        appToken != null ? {'Authorization': 'Bearer $appToken'} : {};

    return headers ?? headerAuthorization;
  }

  Future<ClientResponse> _prepareRequest({
    required Future<Response> Function() action,
  }) async {
    if (await I.getDependency<ICheckInternetConnection>().checkConnection()) {
      try {
        final response = await action();
        return response.toClientResponse();
      } on DioError catch (error) {
        throw error.message;
      } catch (_) {
        throw Exception();
      }
    } else {
      throw NoInternetConnectionFailure(message: NO_INTERNET_CONNECTION);
    }
  }

  @override
  Future<ClientResponse> post(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onSendProgress,
  }) async {
    _client.options.headers = _setHeaders(headers);

    return await _prepareRequest(
      action: () async => await _client.post(
        url,
        data: body,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
      ),
    );
  }

  @override
  Future<ClientResponse> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    _client.options.headers = _setHeaders(headers);

    return await _prepareRequest(
      action: () async => await _client.get(
        path,
        queryParameters: queryParameters,
      ),
    );
  }

  @override
  Future<ClientResponse> delete(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    _client.options.headers = _setHeaders(headers);

    return await _prepareRequest(
      action: () async => await _client.delete(
        url,
        data: body,
        queryParameters: queryParameters,
      ),
    );
  }

  @override
  Future<ClientResponse> put(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    _client.options.headers = _setHeaders(headers);

    return await _prepareRequest(
      action: () async => await _client.put(
        url,
        data: body,
        queryParameters: queryParameters,
      ),
    );
  }

  @override
  Future<ClientResponse> patch(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    _client.options.headers = _setHeaders(headers);
    return await _prepareRequest(
      action: () async => await _client.patch(
        url,
        data: body,
        queryParameters: queryParameters,
      ),
    );
  }

  @override
  void removeRetryRequestErrorInterceptor() {
    _client.interceptors.removeLast();
  }
}
