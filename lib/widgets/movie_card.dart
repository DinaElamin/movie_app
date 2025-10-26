import 'package:flutter/material.dart';
import '../models/movie_model.dart';

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
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.movie.posterPath != null
    ? 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}'
    : 'https://via.placeholder.com/150';

    if (widget.isHorizontal) {
      return SizedBox(
        width: 140,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: Image.network(
    widget.movie.posterPath != null && widget.movie.posterPath!.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}'
        : 'https://via.placeholder.com/150',
    fit: BoxFit.cover,
    height: 180,
    width: 140,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        color: Colors.grey[800],
        height: 180,
        width: 140,
        child: const Icon(
          Icons.broken_image,
          color: Colors.white54,
          size: 50,
        ),
      );
    },
  ),
),

                const SizedBox(height: 5),
                Text(
                  widget.movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() => isFavorite = !isFavorite);
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 100,
                height: 140,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                    const SizedBox(height: 8),
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
            IconButton(
              onPressed: () {
                setState(() => isFavorite = !isFavorite);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      );
    }
  }
}
