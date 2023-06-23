import 'package:dio/dio.dart';

import 'http_retry_connection.dart';

class HttpRetryInterceptor extends Interceptor {
  final HttpRetryHttpConnection httpRetryHttpConnection;
  HttpRetryInterceptor({
    required this.httpRetryHttpConnection,
  });

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    final clientResponse = await httpRetryHttpConnection.retryRequest(
      requestOptions: err.requestOptions,
    );

    return clientResponse?.originResponse != null
        ? handler.resolve(
            clientResponse?.originResponse,
          )
        : super.onError(err, handler);
  }
}
