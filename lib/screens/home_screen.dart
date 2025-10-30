import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/movie_cubit/movie_cubit.dart';
import '../widgets/movie_card.dart';
import '../main.dart';
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MovieCubit>().getPopularMovies();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MovieCubit>().searchMovies(value);
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieCubit>();
    final theme = Theme.of(context);
    const primaryColor = Color(0xFFE74C1B);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Movies',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: isDarkModeNotifier,
            builder: (context, isDarkMode, _) {
              return IconButton(
                onPressed: () {
                  isDarkModeNotifier.value = !isDarkModeNotifier.value;
                },
                icon: Icon(
                  isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                  color: primaryColor,
                  size: 26,
                ),
              );
            },
          ),
        ],
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => _onItemTapped(0),
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.white : Colors.white70,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(1),
              icon: Icon(
                Icons.movie,
                color: _selectedIndex == 1 ? Colors.white : Colors.white70,
                size: 28,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: Icon(
                Icons.favorite,
                color: _selectedIndex == 2 ? Colors.white : Colors.white70,
                size: 28,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(3),
              icon: Icon(
                Icons.person_outline,
                color: _selectedIndex == 3 ? Colors.white : Colors.white70,
                size: 28,
              ),
            ),
          ],
        ),
      ),

      // ✅ Main Body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[850]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: theme.colorScheme.onBackground),
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Movie...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    icon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Popular Movies',
                style: TextStyle(
                  color: theme.colorScheme.onBackground,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      );
                    } else if (state is MovieLoaded) {
                      final movies = state.movies;

                      if (movies.isEmpty) {
                        return const Center(
                          child: Text(
                            'No movies found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return MovieCard(
                            movie: movie,
                            isHorizontal: true,
                          );
                        },
                      );
                    } else if (state is MovieError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    } else {
                      cubit.getPopularMovies();
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      );
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
