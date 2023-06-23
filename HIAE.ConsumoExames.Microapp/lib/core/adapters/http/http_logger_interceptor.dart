import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';

class HttpLoggerInterceptor implements Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');

      String colorValue = '\x1B[31m';

      debugPrint('\n');
      debugPrint(
        '\n$colorValue((Error))',
      );

      debugPrint(
        '\n$colorValue-Error Message: ${err.message}',
      );

      debugPrint(
        colorValue + '-stackTrace: ${err.stackTrace}',
      );

      debugPrint(
        colorValue + '-Method: ${err.requestOptions.method}',
      );

      if (err.requestOptions.headers.isNotEmpty) {
        final prettyStringHeaders = encoder.convert(err.requestOptions.headers);

        debugPrint(
          colorValue + '-Headers:',
        );
        prettyStringHeaders.split('\n').forEach(
              (dynamic element) => debugPrint(colorValue + ' ' + element),
            );
      }

      debugPrint(
        colorValue + '-BaseURL: ${err.requestOptions.baseUrl}',
      );
      debugPrint(
        colorValue + '-EndPoint: ${err.requestOptions.path}',
      );

      if (err.requestOptions.queryParameters.isNotEmpty) {
        debugPrint(
          colorValue + '-QueryParameters: ',
        );
        final prettyStringParameters =
            encoder.convert(err.requestOptions.queryParameters);

        prettyStringParameters.split('\n').forEach(
              (dynamic element) => debugPrint(colorValue + ' ' + element),
            );
        debugPrint('\n');
      }

      if (err.requestOptions.data != null) {
        debugPrint(
          colorValue + '-Body: ',
        );

        final prettyString = encoder.convert(err.requestOptions.data);
        prettyString.split('\n').forEach(
              (dynamic element) => debugPrint(colorValue + ' ' + element),
            );

        debugPrint('\n');
      }
    }
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');

      String colorValue = '\x1B[36m';

      debugPrint('\n');
      debugPrint(
        '\n$colorValue((Request))',
      );

      debugPrint(
        '\n' + colorValue + '-Method: ${options.method}',
      );

      if (options.headers.isNotEmpty) {
        final prettyStringHeaders = encoder.convert(options.headers);

        debugPrint(
          colorValue + '-Headers:',
        );
        prettyStringHeaders.split('\n').forEach(
              (dynamic element) => debugPrint(colorValue + ' ' + element),
            );
      }

      debugPrint(
        colorValue + '-BaseURL: ${options.baseUrl}',
      );
      debugPrint(
        colorValue + '-EndPoint: ${options.path}',
      );

      if (options.queryParameters.isNotEmpty) {
        debugPrint(
          colorValue + '-QueryParameters: ',
        );
        final prettyStringParameters = encoder.convert(options.queryParameters);

        prettyStringParameters.split('\n').forEach(
              (dynamic element) => debugPrint(colorValue + ' ' + element),
            );
        debugPrint('\n');
      }

      if (options.data != null) {
        debugPrint(
          colorValue + '-Body: ',
        );

        final prettyString = encoder.convert(options.data);
        prettyString.split('\n').forEach(
              (dynamic element) => debugPrint(colorValue + ' ' + element),
            );

        debugPrint('\n');
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      String colorValue =
          response.statusCode?.clamp(200, 299) == response.statusCode
              ? '\x1B[32m'
              : '\x1B[31m';

      String status;

      switch (response.statusCode) {
        case 200:
          status = 'Success';
          break;

        case 204:
          status = 'No Content';
          break;

        case 400:
          status = 'Bad Request';
          break;

        case 401:
          status = 'Unauthorized';
          break;

        case 404:
          status = 'Not Found';
          break;

        default:
          status = 'Internal Server Error';
      }

      debugPrint('\n');
      debugPrint(
        '\n$colorValue((Response))',
      );

      debugPrint(
        '\n' + colorValue + '-Method: ${response.requestOptions.method}',
      );
      debugPrint(colorValue + '-StatusCode: ${response.statusCode}');
      debugPrint(colorValue + '-Status: $status');
      debugPrint(
        colorValue + '-BaseURL: ${response.requestOptions.baseUrl}',
      );
      debugPrint(
        colorValue + '-EndPoint: ${response.requestOptions.path}',
      );

      if (response.data != null) {
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final prettyString = encoder.convert(response.data);
        prettyString.split('\n').forEach(
              (dynamic element) => debugPrint(colorValue + ' ' + element),
            );

        debugPrint('\n');
      }
    }
    handler.next(response);
  }
}
