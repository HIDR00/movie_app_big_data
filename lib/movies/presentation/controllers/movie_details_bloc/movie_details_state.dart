part of 'movie_details_bloc.dart';

class MovieDetailsState {
  final MediaDetails? movieDetails;
  final RequestStatus status;
  final String message;
  final double ratingStar;
  final String review;

  const MovieDetailsState({
    this.movieDetails,
    this.status = RequestStatus.loading,
    this.message = '',
    this.ratingStar = -1,
    this.review = ''
  });

  MovieDetailsState copyWith({
    MediaDetails? movieDetails,
    RequestStatus? status,
    String? message,
    double? ratingStar,
    String? review,
  }) {
    return MovieDetailsState(
      movieDetails: movieDetails ?? this.movieDetails,
      status: status ?? this.status,
      message: message ?? this.message,
      ratingStar: ratingStar ?? this.ratingStar,
      review: review ?? this.review,
    );
  }
}
