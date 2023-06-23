class ClientResponse {
  const ClientResponse({
    required this.data,
    required this.statusCode,
    this.originResponse,
  });

  final dynamic data;
  final int statusCode;
  final dynamic originResponse;
}
