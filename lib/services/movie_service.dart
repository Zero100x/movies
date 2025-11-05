import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class OmdbService {
  static const String baseUrl = 'https://www.omdbapi.com/';
  static const String apiKey = '402df957'; // Clave pública demo

  static Future<List<Movie>> getPopularMovies() async {
    final moviesList = [
      'The Irishman',
      'Her',
      'Inception',
      'Interstellar',
      'Avatar',
      'The Dark Knight',
      'Joker'
    ];

    List<Movie> movies = [];

    for (String title in moviesList) {
      final response =
          await http.get(Uri.parse('$baseUrl?t=$title&apikey=$apiKey'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          movies.add(Movie.fromJson(data));
        }
      }
    }

    return movies;
  }
}
