import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            height: 165,
            child: movie.posterUrl == null
                ? const Center(child: Icon(Icons.movie, size: 48))
                : Image.network(
                    movie.posterUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (c, child, p) => p == null
                        ? child
                        : const Center(child: CircularProgressIndicator()),
                    errorBuilder: (c, e, s) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(movie.voteAverage.toStringAsFixed(1)),
                    const SizedBox(width: 12),
                    Text(movie.releaseDate.split('-').first),
                  ]),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview.isEmpty
                        ? 'Sin sinopsis disponible.'
                        : movie.overview,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}