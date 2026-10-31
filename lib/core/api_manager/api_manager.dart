import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../utils/failure.dart';
import '../utils/network_info.dart';
import 'api_exceptions.dart';
import 'api_extensions.dart';
import 'base_api_client.dart';
import 'dio_api_response_model.dart';

enum APIMethod { get, post, put, patch, delete }

@lazySingleton
class ApiManager {
  final BaseApiClient _dioClient;
  final NetworkInfo _networkInfo = NetworkInfoImpl();

  ApiManager(this._dioClient);

  /// Core request method with connectivity check and error handling
  // api_manager.dart

  Future<DioApiResponseModel> request({
    required String endPoint,
    required APIMethod method,
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isMultipart = false,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException(message: 'No Internet Connection');
    }

    try {
      final dynamic requestData = isMultipart
          ? (data is Map<String, dynamic>
                ? FormData.fromMap(
                    data.map((key, value) {
                      if (value is File) {
                        return MapEntry(
                          key,
                          MultipartFile.fromFileSync(
                            value.path,
                            filename: value.path.split('/').last,
                          ),
                        );
                      }
                      return MapEntry(key, value);
                    }),
                  )
                : data)
          : (data is Map || data is List ? jsonEncode(data) : data);

      final response = await _executeRequest(
        endPoint: endPoint,
        method: method,
        externalUrl: externalUrl,
        requiresApiKey: requiresApiKey,
        data: requestData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );

      // ✅ Wrap both data and headers
      return DioApiResponseModel(
        data: response.data,
        headers: response.headers.map, // Map<String, List<String>>
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException(
          message: 'Server is taking too long to respond. Please try again.',
        );
      }
      throw e.toApiException();
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  Future<Response> _executeRequest({
    required String endPoint,
    required APIMethod method,
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    switch (method) {
      case APIMethod.get:
        return _dioClient.get(
          endPoint,
          externalUrl: externalUrl,
          requiresApiKey: requiresApiKey,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
          data: data,
        );
      case APIMethod.post:
        return _dioClient.post(
          endPoint,
          externalUrl: externalUrl,
          requiresApiKey: requiresApiKey,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
        );
      case APIMethod.put:
        return _dioClient.put(
          endPoint,
          externalUrl: externalUrl,
          requiresApiKey: requiresApiKey,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
        );
      case APIMethod.patch:
        return _dioClient.patch(
          endPoint,
          externalUrl: externalUrl,
          requiresApiKey: requiresApiKey,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
        );
      case APIMethod.delete:
        return _dioClient.delete(
          endPoint,
          externalUrl: externalUrl,
          requiresApiKey: requiresApiKey,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
        );
    }
  }

  /// Helper for repository to execute a request and return `Either<Failure, T>`
  Future<Either<Failure, T>> execute<T>(
    Future<DioApiResponseModel> Function() call,
    T Function(DioApiResponseModel response) mapper, // ← ApiResponse milega ab
  ) async {
    try {
      final result = await call();
      return Right(mapper(result));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // --- Convenience Methods ---

  Future<DioApiResponseModel> getData(
    String endPoint, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,

    Map<String, dynamic>? queryParameters,
  }) {
    return request(
      endPoint: endPoint,
      method: APIMethod.get,
      data: data,
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      queryParameters: queryParameters,
    );
  }

  Future<DioApiResponseModel> postData(
    String endPoint, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    bool isMultipart = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request(
      endPoint: endPoint,
      method: APIMethod.post,
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      data: data,
      isMultipart: isMultipart,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<DioApiResponseModel> putData(
    String endPoint, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    bool isMultipart = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request(
      endPoint: endPoint,
      method: APIMethod.put,
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      data: data,
      isMultipart: isMultipart,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<DioApiResponseModel> patchData(
    String endPoint, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    bool isMultipart = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request(
      endPoint: endPoint,
      method: APIMethod.patch,
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      data: data,
      isMultipart: isMultipart,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<DioApiResponseModel> deleteData(
    String endPoint, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request(
      endPoint: endPoint,
      method: APIMethod.delete,
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
