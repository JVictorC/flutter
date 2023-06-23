import 'dart:async';

import 'package:dio/dio.dart';

import '../../di/initInjector.dart';
import 'client_response.dart';
import 'http_interface.dart';

class HttpRetryHttpConnection {
  final int _retry;

  HttpRetryHttpConnection({required int retry})
      : _retry = retry,
        assert(retry >= 0, 'The value cannot be less than zero');

  Future<ClientResponse?> retryRequest({
    required RequestOptions requestOptions,
  }) async {
    ClientResponse? response;

    if (_retry > 0) {
      int repeat = 0;
      final httpClient = I.getDependency<IHttpClient>();

      httpClient.removeRetryRequestErrorInterceptor();

      await Future.doWhile(
        () async {
          await Future.delayed(
            const Duration(
              seconds: 5,
            ),
          );
          try {
            if (requestOptions.method.toUpperCase() == 'POST') {
              response = await httpClient.post(
                requestOptions.path,
                body: requestOptions.data,
                headers: requestOptions.headers,
                queryParameters: requestOptions.queryParameters,
              );
            } else if (requestOptions.method.toUpperCase() == 'PUT') {
              response = await httpClient.put(
                requestOptions.path,
                body: requestOptions.data,
                headers: requestOptions.headers,
                queryParameters: requestOptions.queryParameters,
              );
            } else if (requestOptions.method.toUpperCase() == 'GET') {
              response = await httpClient.get(
                requestOptions.path,
                headers: requestOptions.headers,
                queryParameters: requestOptions.queryParameters,
              );
            } else if (requestOptions.method.toUpperCase() == 'PATCH') {
              response = await httpClient.patch(
                requestOptions.path,
                headers: requestOptions.headers,
                body: requestOptions.data,
                queryParameters: requestOptions.queryParameters,
              );
            } else if (requestOptions.method.toUpperCase() == 'DELETE') {
              response = await httpClient.delete(
                requestOptions.path,
                headers: requestOptions.headers,
                body: requestOptions.data,
                queryParameters: requestOptions.queryParameters,
              );
            } else {
              repeat++;
            }
          } catch (_) {
            response = null;
            repeat++;
          }

          bool continueLoop =
              response != null && [200, 201, 204].contains(response?.statusCode)
                  ? false
                  : repeat < _retry;

          return continueLoop;
        },
      );
    }

    return response;
  }
}
