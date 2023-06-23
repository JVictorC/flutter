import 'package:pokedex_incie/src/core/adapters/http/client_response.dart';

abstract class IHttpClient {
  Future<ClientResponse> get(
    String url, {
    Map<String, String>? headers,
  });
}