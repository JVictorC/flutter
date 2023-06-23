import 'package:base_dependencies/dependencies.dart';

abstract class HttpAdapter {
  Future<ZeraResponse> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
    ZeraResponseType? zeraResponseType,
  });
  Future<ZeraResponse> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
  });
  Future<ZeraResponse> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
  });
  Future<ZeraResponse> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
  });
  Future<ZeraResponse> get(
    String path, {
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParams,
    ZeraResponseType? zeraResponseType,
  });
  Future<ZeraResponse> download(String path, String savePath);
}
