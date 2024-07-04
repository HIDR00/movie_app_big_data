import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:movies_app/core/data/error/exceptions.dart';
import 'package:movies_app/movies/data/models/movie_details_model.dart';

import 'package:movies_app/core/data/network/api_constants.dart';
import 'package:movies_app/core/data/network/error_message_model.dart';
import 'package:movies_app/movies/data/models/movie_model.dart';
import 'package:movies_app/movies/data/mongo_db.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<List<List<MovieModel>>> getMovies();
  Future<MovieDetailsModel> getMovieDetails(int movieId);
  Future<List<MovieModel>> getAllPopularMovies(int page);
  Future<List<MovieModel>> getAllTopRatedMovies(int page);
  Future<void> postVoteRatingMovie(int movieId, double ratingStar, String review);
}

class MoviesRemoteDataSourceImpl extends MoviesRemoteDataSource {
  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await Dio().get(ApiConstants.nowPlayingMoviesPath);
    if (response.statusCode == 200) {
      return List<MovieModel>.from(
          (response.data['results'] as List).map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await Dio().get(ApiConstants.popularMoviesPath);
    if (response.statusCode == 200) {
      return List<MovieModel>.from(
          (response.data['results'] as List).map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await Dio().get(ApiConstants.topRatedMoviesPath);
    if (response.statusCode == 200) {
      return List<MovieModel>.from(
          (response.data['results'] as List).map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<List<MovieModel>>> getMovies() async {
    final response = Future.wait(
      [
        getNowPlayingMovies(),
        getPopularMovies(),
        getTopRatedMovies(),
      ],
      eagerError: true,
    );
    return response;
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final response = await Dio().get(ApiConstants.getMovieDetailsPath(movieId));
    if (response.statusCode == 200) {
      await postClickDetailMovie(MovieDetailsModel.fromJson(response.data));
      return MovieDetailsModel.fromJson(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getAllPopularMovies(int page) async {
    final response = await Dio().get(ApiConstants.getAllPopularMoviesPath(page));
    if (response.statusCode == 200) {
      return List<MovieModel>.from(
          (response.data['results'] as List).map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getAllTopRatedMovies(int page) async {
    final response = await Dio().get(ApiConstants.getAllTopRatedMoviesPath(page));
    if (response.statusCode == 200) {
      return List<MovieModel>.from(
          (response.data['results'] as List).map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  Future<void> postClickDetailMovie(MovieDetailsModel movieDetailModel) async {
    try {
      var movieDetailClick = MongoDB.db.collection('movieDetailClick');
      String formattedTimestamp = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
      movieDetailClick.insertOne({
        'message': 'Click recorded',
        'timestamp': formattedTimestamp,
        'title': movieDetailModel.title,
        'posterUrl': movieDetailModel.posterUrl,
        'backdropUrl': movieDetailModel.backdropUrl,
        'releaseDate': movieDetailModel.releaseDate,
        'genres': movieDetailModel.genres,
        'runtime': movieDetailModel.runtime,
        'overview': movieDetailModel.overview,
        'voteAverage': movieDetailModel.voteAverage,
        'voteCount': movieDetailModel.voteCount
      });
      print('title: ${movieDetailModel.title}');
    } catch (e) {
      print('Failed to post click: $e');
    }
  }

  @override
  Future<void> postVoteRatingMovie(int movieId, double ratingStar, String review) async {
    try {
      final response = await Dio().get(ApiConstants.getMovieDetailsPath(movieId));
      MovieDetailsModel movieDetailModel = MovieDetailsModel.fromJson(response.data);
      print('title: ${movieDetailModel.title}');


      await updateVoteAverage(movieId,ratingStar,movieDetailModel);

      var movieDetailClick = MongoDB.db.collection('movieVote');
      String formattedTimestamp = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
      print('ratingStar: ${ratingStar}');
      if (ratingStar != -1) {
        movieDetailClick.insertOne({
          'message': 'Click recorded',
          'id': movieDetailModel.tmdbID,
          'timestamp': formattedTimestamp,
          'title': movieDetailModel.title,
          'releaseDate': movieDetailModel.releaseDate,
          'genres': movieDetailModel.genres,
          'myVote': ratingStar,
          'review': review
        });
      }
    } catch (e) {
      print('Failed to post click: $e');
    }
  }

  Future<void> updateVoteAverage(int movieId, double ratingStar,MovieDetailsModel movieDetailModel) async {
    try {
      print('updateVoteAverageStart');

      var movieVoteAverage = MongoDB.db.collection('movieVoteAverage');
      var result = await movieVoteAverage.findOne({'id': movieId});
      if (result != null) {
        double currentAverage = result['vote_average'];
        int currentCount = result['vote_count'];
        double newAverage = ((currentAverage * currentCount) + ratingStar) / (currentCount + 1);
        await movieVoteAverage.update({
          'id': movieId
        }, {
          '\$set': {'vote_average': double.parse(newAverage.toStringAsFixed(3)), 'vote_count': currentCount + 1}
        });
        print('updateVoteAverageEnd');
      } else {
        movieVoteAverage.insertOne({
          'id': movieId,
          'title': movieDetailModel.title,
          'vote_average': ratingStar,
          'vote_count': 1,
          'status': 'Released',
          'release_date': movieDetailModel.releaseDate,
          'revenue': 245066411,
          'runtime': movieDetailModel.runtime,
          'adult': false,
          'backdrop_path': movieDetailModel.backdropUrl,
          'budget': 6000000,
          'homepage': movieDetailModel.trailerUrl,
          'imdb_id': movieDetailModel.tmdbID,
          'original_language': 'en',
          'original_title': movieDetailModel.title,
          'overview': movieDetailModel.overview,
          'popularity': 158.448,
          'poster_path': movieDetailModel.posterUrl,
          'tagline': 'Your mind is the scene of the crime.',
          'genres': movieDetailModel.genres,
          'production_companies': 'Paramount, Alfran Productions',
          'production_countries': 'United States of America',
          'spoken_languages': 'English, Italian, Latin',
          'keywords': 'rescue, mission, dream, airplane, paris, france, virtual reality, kidn…'
        });
      }
    } catch (e) {
      print('Failed to post click: $e');
    }
  }
}
