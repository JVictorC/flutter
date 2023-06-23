import 'package:dio/dio.dart';

import 'client_response.dart';

extension ClientResponseExt on Response {
  ClientResponse toClientResponse() => ClientResponse(
        data: data,
        statusCode: statusCode!,
        originResponse: this,
      );
}
