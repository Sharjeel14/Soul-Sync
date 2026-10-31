// lib/core/network/api_response.dart

class DioApiResponseModel<T> {
  final T data;
  final Map<String, List<String>> headers;

  const DioApiResponseModel({required this.data, required this.headers});

  /// Shortcut to get a single header value
  String? header(String key) => headers[key.toLowerCase()]?.firstOrNull;
}
