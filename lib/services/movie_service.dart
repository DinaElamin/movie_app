import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class MovieService {
  final Dio _dio = Dio();
  final String _apiKey = 'aa6fc65fcedb7431af3ac2fbe6484cd0';

  Future<List<Movie>> fetchPopularMovies() async {
    const String url = 'https://api.themoviedb.org/3/movie/popular';
    try {
      final response = await _dio.get(url, queryParameters: {'api_key': _apiKey});
      final List results = response.data['results'] ?? [];
      return results.map((e) => Movie.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error ${e.response?.statusCode}: ${e.response?.statusMessage}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final String url = 'https://api.themoviedb.org/3/search/movie';
    try {
      final response = await _dio.get(url, queryParameters: {
        'api_key': _apiKey,
        'query': query,
        'include_adult': false,
        'page': 1,
      });
      final List results = response.data['results'] ?? [];
      return results.map((e) => Movie.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error ${e.response?.statusCode}: ${e.response?.statusMessage}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
