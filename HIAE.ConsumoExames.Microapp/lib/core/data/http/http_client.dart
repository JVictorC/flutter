import 'package:base_dependencies/dependencies.dart';

import 'http.dart';

class HttpClient implements HttpAdapter {
  final ZeraHttp _http;
  late Map<String, dynamic> _headers;

  HttpClient({required ZeraHttp http}) : _http = http {
    _createInterceptors();
    _setHeaders();
  }

  void _setHeaders() {
    _headers = {
      'apikey': 'a03026be-11e0-4496-9093-26e855f4fa2b',
    };
  }

  void _createInterceptors() {
    _http.interceptor.add(
      ZeraInterceptorWrapper(
        onRequest: (ZeraRequest request) async => request,
        onResponse: (ZeraResponse response) async => response,
        onError: (ZeraError error) async => error,
      ),
    );
  }

  Future<ZeraResponse> _executeRequest(Future<ZeraResponse> action) async {
    try {
      final ZeraResponse response = await action;
      return response;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<ZeraResponse> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _executeRequest(
      _http.delete(
        path,
        body: body,
        header: header ?? _headers,
        queryParams: queryParams,
      ),
    );
    return response;
  }

  @override
  Future<ZeraResponse> get(
    String path, {
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
    ZeraResponseType? zeraResponseType,
  }) async {
    final response = await _executeRequest(
      _http.get(
        path,
        header: header ?? _headers,
        queryParams: queryParams,
        zeraResponseType: zeraResponseType,
      ),
    );
    return response;
  }

  @override
  Future<ZeraResponse> post(
    String path, {
    body,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
    ZeraResponseType? zeraResponseType,
  }) async {
    final response = await _executeRequest(
      _http.post(
        path,
        body: body,
        header: header ?? _headers,
        queryParams: queryParams,
        zeraResponseType: zeraResponseType,
      ),
    );
    return response;
  }

  @override
  Future<ZeraResponse> put(
    String path, {
    body,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _executeRequest(
      _http.put(
        path,
        body: body,
        header: header ?? _headers,
        queryParams: queryParams,
      ),
    );
    return response;
  }

  @override
  Future<ZeraResponse> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _executeRequest(
      _http.patch(
        path,
        body: body,
        header: header ?? _headers,
        queryParams: queryParams,
      ),
    );

    return response;
  }

  @override
  Future<ZeraResponse> download(
    String path,
    String savePath, [
    Map<String, dynamic>? headers,
  ]) async {
    final response = await _executeRequest(
      _http.get(
        path,
        zeraResponseType: ZeraResponseType.bytes,
      ),
    );

    return response;
  }
}
