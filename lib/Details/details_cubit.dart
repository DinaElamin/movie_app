import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/movie_model.dart';
import '../../services/movie_service.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final MovieService movieService;

  DetailsCubit(this.movieService) : super(DetailsInitial());

  void getMovieDetails(Movie movie) async {
    emit(DetailsLoading());
    try {
      // هنا لو API منفصل للتفاصيل ممكن نستدعيه، لكن مؤقتًا هنرجّع نفس الـmovie
      await Future.delayed(const Duration(milliseconds: 500));
      emit(DetailsLoaded(movie));
    } catch (e) {
      emit(DetailsError(e.toString()));
    }
  }
}
