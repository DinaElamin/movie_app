class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;

  // ✅ الإضافات الجديدة
  final double? voteAverage;
  final List<dynamic>? genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,

    // ✅ الإضافات هنا كمان
    this.voteAverage,
    this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',

      // ✅ الإضافات هنا
      voteAverage: (json['vote_average'] != null)
          ? (json['vote_average'] as num).toDouble()
          : 0.0,
      genreIds: json['genre_ids'] ?? [],
    );
  }

  // ✅ Getter بسيط يطلع الأنواع كنص
  String get genre {
    if (genreIds == null || genreIds!.isEmpty) {
      return "Action, Drama";
    }

    final genreMap = {
      28: "Action",
      12: "Adventure",
      16: "Animation",
      35: "Comedy",
      80: "Crime",
      18: "Drama",
      14: "Fantasy",
      27: "Horror",
      9648: "Mystery",
      878: "Sci-Fi",
      53: "Thriller",
      10749: "Romance",
    };

    final genres = genreIds!
        .map((id) => genreMap[id] ?? "Unknown")
        .take(3)
        .join(", ");
    return genres;
  }
}
