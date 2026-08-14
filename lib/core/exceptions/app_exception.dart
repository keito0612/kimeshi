sealed class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'ネットワークエラーが発生しました', super.code});
}

class ValidationIssue {
  final String code;
  final String path;
  final String message;

  const ValidationIssue({
    required this.code,
    required this.path,
    required this.message,
  });

  factory ValidationIssue.fromJson(Map<String, dynamic> json) {
    final pathList = json['path'] as List<dynamic>?;
    return ValidationIssue(
      code: json['code'] as String? ?? '',
      path: pathList?.map((e) => e.toString()).join('.') ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  @override
  String toString() => '[$path] $message';
}

class ApiException extends AppException {
  final int? statusCode;
  final List<ValidationIssue> validationIssues;

  const ApiException({
    super.message = 'APIエラーが発生しました',
    super.code,
    this.statusCode,
    this.validationIssues = const [],
  });

  bool get hasValidationErrors => validationIssues.isNotEmpty;

  String get validationErrorMessage {
    if (validationIssues.isEmpty) return message;
    return validationIssues.map((e) => e.toString()).join('\n');
  }

  @override
  String toString() {
    if (hasValidationErrors) {
      return validationErrorMessage;
    }
    return message;
  }
}

class LocationException extends AppException {
  const LocationException({super.message = '位置情報の取得に失敗しました', super.code});
}

class NoResultException extends AppException {
  const NoResultException({super.message = '条件に合う店舗が見つかりませんでした', super.code});
}
