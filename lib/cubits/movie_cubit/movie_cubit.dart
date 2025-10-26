import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/movie_model.dart';
import '../../services/movie_service.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieService movieService;
  MovieCubit(this.movieService) : super(MovieInitial());

  Future<void> getPopularMovies() async {
    try {
      emit(MovieLoading());
      final movies = await movieService.fetchPopularMovies();
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      await getPopularMovies();
      return;
    }

    try {
      emit(MovieLoading());
      final movies = await movieService.searchMovies(query);
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }
}
