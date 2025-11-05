class Movie {
  final String title;
  final String year;
  final String poster;
  final String plot;
  final double imdbRating;

  Movie({
    required this.title,
    required this.year,
    required this.poster,
    required this.plot,
    required this.imdbRating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    double rating = 0.0;
    if (json['imdbRating'] != null && json['imdbRating'] != 'N/A') {
      rating = double.tryParse(json['imdbRating']) ?? 0.0;
    }

    return Movie(
      title: json['Title'] ?? 'Unknown',
      year: json['Year'] ?? 'Unknown',
      poster: json['Poster'] ?? '',
      plot: json['Plot'] ?? '',
      imdbRating: rating,
    );
  }
}
