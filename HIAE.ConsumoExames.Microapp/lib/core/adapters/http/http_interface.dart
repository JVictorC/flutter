import 'client_response.dart';

abstract class IHttpClient {
  void removeRetryRequestErrorInterceptor();

  Future<ClientResponse> post(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onSendProgress,
  });

  Future<ClientResponse> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<ClientResponse> delete(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<ClientResponse> put(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<ClientResponse> patch(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });
}
