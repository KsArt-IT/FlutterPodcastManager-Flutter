sealed class AppFailure implements Exception {
  final String message;
  final int? code;
  const AppFailure({required this.message, this.code});
}

final class ServerFailure extends AppFailure {
  const ServerFailure({required super.message, super.code});
}

final class CacheFailure extends AppFailure {
  const CacheFailure({required super.message});
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure({required super.message});
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure({required super.message});
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure({required super.message});
}
