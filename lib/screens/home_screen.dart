import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/cubits/movie_cubit/movie_cubit.dart';
import 'package:movie_app/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Load popular on start
    context.read<MovieCubit>().getPopularMovies();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // debounce 500ms
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // call cubit search
      context.read<MovieCubit>().searchMovies(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieCubit>();

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Color(0xFFE74C1B),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: Colors.white, size: 30),
            Icon(Icons.movie, color: Colors.white70, size: 28),
            Icon(Icons.favorite, color: Colors.white70, size: 28),
            Icon(Icons.person_outline, color: Colors.white70, size: 28),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Search bar (now connected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Movie...',
                    hintStyle: TextStyle(color: Colors.grey),
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🎬 Popular Movies (or search results)
              const Text(
                'Popular Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MovieLoaded) {
                      final movies = state.movies;

                      return ListView(
                        children: [
                          // أفلام بشكل أفقي
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: movies.length,
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: MovieCard(
                                    movie: movie,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // قسم الفيفورت
                          const Text(
                            'Your Favorites',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    } else if (state is MovieError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      // fallback
                      cubit.getPopularMovies();
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
