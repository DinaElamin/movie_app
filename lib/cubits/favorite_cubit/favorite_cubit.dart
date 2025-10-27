import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/movie_model.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final List<Movie> _favorites = [];

  void toggleFavorite(Movie movie) {
    if (_favorites.contains(movie)) {
      _favorites.remove(movie);
    } else {
      _favorites.add(movie);
    }
    emit(FavoriteUpdated(List.from(_favorites)));
  }

  bool isFavorite(Movie movie) => _favorites.contains(movie);
}
