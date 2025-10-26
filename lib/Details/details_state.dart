import '../../models/movie_model.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final Movie movie;
  DetailsLoaded(this.movie);
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);
}
