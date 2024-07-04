part of 'movie_details_bloc.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();
}

class GetMovieDetailsEvent extends MovieDetailsEvent {
  final int id;
  const GetMovieDetailsEvent(this.id);
  @override
  List<Object?> get props => [id];
}


class UpdateRatingStar extends MovieDetailsEvent {
  final double ratingStar;
  const UpdateRatingStar(this.ratingStar);
  @override
  List<Object?> get props => [ratingStar];
}


class UpdateReView extends MovieDetailsEvent {
  final String review;
  const UpdateReView(this.review);
  @override
  List<Object?> get props => [review];
}

class CornFirmRating extends MovieDetailsEvent {
  final int id;
  const CornFirmRating(this.id);
  @override
  List<Object?> get props => [id];
}