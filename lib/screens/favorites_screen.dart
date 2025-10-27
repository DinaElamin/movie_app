import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/favorite_cubit/favorite_cubit.dart';
import '../widgets/movie_card.dart';
import '../models/movie_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Favorites ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteUpdated && state.favorites.isNotEmpty) {
          return GridView.builder(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 0, 
    crossAxisSpacing: 0, 
    childAspectRatio: 0.78, 
  ),
  itemCount: state.favorites.length,
  itemBuilder: (context, index) {
    final Movie movie = state.favorites[index];
    return SizedBox(
      width: 140,
      child: MovieCard(movie: movie, isHorizontal: true), 
    );
  },
);

          } else if (state is FavoriteUpdated && state.favorites.isEmpty) {
            return const Center(
              child: Text(
                "No favorites yet ",
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
