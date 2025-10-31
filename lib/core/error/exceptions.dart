class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occured!']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occured!']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occured!']);
}

