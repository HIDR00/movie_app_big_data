import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/entities/media_details.dart';
import 'package:movies_app/core/utils/enums.dart';
import 'package:movies_app/movies/domain/repository/movies_repository.dart';
import 'package:movies_app/movies/domain/usecases/get_movie_details_usecase.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMoviesDetailsUseCase _getMoviesDetailsUseCase;
  final MoviesRespository _moviesRespository;

  MovieDetailsBloc(this._getMoviesDetailsUseCase,this._moviesRespository)
      : super(const MovieDetailsState()) {
    on<GetMovieDetailsEvent>(_getMovieDetails);
    on<UpdateRatingStar>(_updateRatingStar);
    on<UpdateReView>(_updateReView);
    on<CornFirmRating>(_cornFirmRating);
  }

  Future<void> _getMovieDetails(
      GetMovieDetailsEvent event, Emitter<MovieDetailsState> emit) async {
    emit(
      state.copyWith(
        status: RequestStatus.loading,
      ),
    );
    final result = await _getMoviesDetailsUseCase(event.id);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: RequestStatus.error,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: RequestStatus.loaded,
          movieDetails: r,
        ),
      ),
    );
  }

  Future<void> _updateRatingStar(
      UpdateRatingStar event, Emitter<MovieDetailsState> emit) async {
    emit(
      state.copyWith(
        ratingStar: event.ratingStar
      ),
    );
    print(state.ratingStar);
  }

  Future<void> _updateReView(
      UpdateReView event, Emitter<MovieDetailsState> emit) async {
    emit(
      state.copyWith(
        review: event.review
      ),
    );
  }

  Future<void> _cornFirmRating(
      CornFirmRating event, Emitter<MovieDetailsState> emit) async {
        _moviesRespository.postVoteRatingMovie(event.id, state.ratingStar, state.review);
  }

}
