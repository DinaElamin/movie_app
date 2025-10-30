import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../Details/details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/favorite_cubit/favorite_cubit.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final bool isHorizontal;
  const MovieCard({
    super.key,
    required this.movie,
    this.isHorizontal = true,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.movie.posterPath != null && widget.movie.posterPath!.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}'
        : 'https://via.placeholder.com/150';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(movie: widget.movie)),
        );
      },
      child: widget.isHorizontal
          ? _buildHorizontalCard(imageUrl, context)
          : _buildVerticalCard(imageUrl, context),
    );
  }

  // 🎬 شكل أفقي (للـ Home Screen)
  Widget _buildHorizontalCard(String imageUrl, BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[800],
                height: 220,
                child: const Icon(Icons.broken_image, color: Colors.white54, size: 50),
              ),
            ),
          ),
          // تدرج أسود تحت النصوص
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // أيقونة المفضلة
          Positioned(
            right: 10,
            top: 10,
            child: BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                final isFav = context.read<FavoriteCubit>().isFavorite(widget.movie);
                return GestureDetector(
                  onTap: () => context.read<FavoriteCubit>().toggleFavorite(widget.movie),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.redAccent : Colors.white,
                      size: 22,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🎞️ شكل رأسي (مثلاً في صفحة All Movies)
  Widget _buildVerticalCard(String imageUrl, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              final isFav = context.read<FavoriteCubit>().isFavorite(widget.movie);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.redAccent : Colors.white,
                ),
                onPressed: () => context.read<FavoriteCubit>().toggleFavorite(widget.movie),
              );
            },
          ),
        ],
      ),
    );
  }
}
