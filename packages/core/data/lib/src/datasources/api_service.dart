abstract interface class ApiService<T> {
  Future<T> generateText({
    required String apiKey,
    required String provider,
    required String version,
    required Map<String, dynamic> body,
  });
}
