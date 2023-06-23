import 'dart:convert';

import 'package:http/http.dart';
import 'package:pokedex_incie/src/core/adapters/http/client_response.dart';

extension ClientResponseExt on Response {
  ClientResponse toClientResponse() => ClientResponse(
        body: jsonDecode(body),
        statusCode: statusCode,
      );
}