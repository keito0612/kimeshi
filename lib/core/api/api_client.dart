import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../exceptions/app_exception.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _parseApiError(error.response);
      default:
        return const NetworkException();
    }
  }

  ApiException _parseApiError(Response<dynamic>? response) {
    final data = response?.data;
    if (data == null || data is! Map<String, dynamic>) {
      return ApiException(statusCode: response?.statusCode);
    }

    // メッセージの取得
    String message = data['message'] as String? ?? 'APIエラーが発生しました';

    // バリデーションエラー (ZodError) のパース
    List<ValidationIssue> validationIssues = [];
    final errorData = data['error'];
    if (errorData is Map<String, dynamic>) {
      final issues = errorData['issues'] as List<dynamic>?;
      if (issues != null) {
        validationIssues = issues
            .whereType<Map<String, dynamic>>()
            .map((e) => ValidationIssue.fromJson(e))
            .toList();
      }
      // ZodErrorの場合、メッセージがなければissuesから生成
      if (message == 'APIエラーが発生しました' && validationIssues.isNotEmpty) {
        message = 'バリデーションエラー';
      }
    }

    return ApiException(
      statusCode: response?.statusCode,
      message: message,
      validationIssues: validationIssues,
    );
  }
}
