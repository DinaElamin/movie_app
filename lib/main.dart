import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/movie_cubit/movie_cubit.dart';
import 'cubits/favorite_cubit/favorite_cubit.dart';
import 'services/movie_service.dart';
import 'screens/home_screen.dart';

final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => MovieCubit(MovieService())..getPopularMovies(),
            ),
            BlocProvider(
              create: (_) => FavoriteCubit(), 
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFE74C1B),
                onBackground: Colors.black,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Colors.black,
              ),
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF1E1E1E),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFE74C1B),
                onBackground: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Colors.white,
              ),
            ),

            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
