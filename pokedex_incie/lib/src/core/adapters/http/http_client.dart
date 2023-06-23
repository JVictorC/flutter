import 'package:http/http.dart' as http;
import 'package:pokedex_incie/src/core/adapters/http/client_response.dart';
import 'package:pokedex_incie/src/core/adapters/http/http_client_abs.dart';

import 'client_response_ext.dart';

class HttpClient implements IHttpClient {

  @override
  Future<ClientResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      return response.toClientResponse();
    } catch (error) {
      throw error.toString();
    }
  }
}
