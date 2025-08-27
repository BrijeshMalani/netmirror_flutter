class MovieModel {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;

  MovieModel({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }
}

class MovieDetailModel {
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final List<Map<String, String>> ratings;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String type;
  final String dvd;
  final String boxOffice;
  final String production;
  final String website;

  MovieDetailModel({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.ratings,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbID,
    required this.type,
    required this.dvd,
    required this.boxOffice,
    required this.production,
    required this.website,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> ratingsList = [];
    if (json['Ratings'] != null) {
      ratingsList = (json['Ratings'] as List)
          .map(
            (rating) => {
              'Source': (rating['Source'] ?? '').toString(),
              'Value': (rating['Value'] ?? '').toString(),
            },
          )
          .toList();
    }

    return MovieDetailModel(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      rated: json['Rated'] ?? '',
      released: json['Released'] ?? '',
      runtime: json['Runtime'] ?? '',
      genre: json['Genre'] ?? '',
      director: json['Director'] ?? '',
      writer: json['Writer'] ?? '',
      actors: json['Actors'] ?? '',
      plot: json['Plot'] ?? '',
      language: json['Language'] ?? '',
      country: json['Country'] ?? '',
      awards: json['Awards'] ?? '',
      poster: json['Poster'] ?? '',
      ratings: ratingsList,
      metascore: json['Metascore'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
      imdbVotes: json['imdbVotes'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      dvd: json['DVD'] ?? '',
      boxOffice: json['BoxOffice'] ?? '',
      production: json['Production'] ?? '',
      website: json['Website'] ?? '',
    );
  }
}

class MovieSearchResponse {
  final List<MovieModel> search;
  final String totalResults;
  final String response;

  MovieSearchResponse({
    required this.search,
    required this.totalResults,
    required this.response,
  });

  factory MovieSearchResponse.fromJson(Map<String, dynamic> json) {
    List<MovieModel> searchList = [];
    if (json['Search'] != null) {
      searchList = (json['Search'] as List)
          .map((item) => MovieModel.fromJson(item))
          .toList();
    }

    return MovieSearchResponse(
      search: searchList,
      totalResults: json['totalResults'] ?? '0',
      response: json['Response'] ?? 'False',
    );
  }
}
