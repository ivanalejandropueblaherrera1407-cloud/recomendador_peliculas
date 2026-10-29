import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = TmdbService();
  String _animo = 'Feliz';
  List<Movie> _peliculas = [];
  bool _cargando = false;
  String? _error;
  String _titulo = 'Elige tu estado de ánimo';

  Future<void> _ejecutar(
      Future<List<Movie>> Function() accion, String titulo) async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final r = await accion();
      setState(() {
        _peliculas = r;
        _titulo = titulo;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _verLista() => _ejecutar(
      () => _service.porAnimo(_animo), 'Películas para sentirte $_animo');

  void _sorprendeme() => _ejecutar(
      () async => [await _service.alAzar(_animo)], 'Tu película de hoy 🎲');

  void _tendencias() =>
      _ejecutar(_service.tendencias, '🔥 Tendencias de la semana');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎬 Película del Fin de Semana')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: TmdbService.generosPorAnimo.keys
                  .map((a) => ChoiceChip(
                        label: Text(a),
                        selected: _animo == a,
                        onSelected: (_) => setState(() => _animo = a),
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _cargando ? null : _sorprendeme,
                    icon: const Icon(Icons.casino),
                    label: const Text('Sorpréndeme'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _cargando ? null : _verLista,
                    icon: const Icon(Icons.list),
                    label: const Text('Ver lista'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Tendencias',
                  onPressed: _cargando ? null : _tendencias,
                  icon: const Icon(Icons.trending_up),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child:
                Text(_titulo, style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(child: _contenido()),
        ],
      ),
    );
  }

  Widget _contenido() {
    if (_cargando) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(_error!, textAlign: TextAlign.center),
      ));
    }
    if (_peliculas.isEmpty) {
      return const Center(child: Text('Toca un botón para empezar 🍿'));
    }
    return ListView.builder(
      itemCount: _peliculas.length,
      itemBuilder: (_, i) => MovieCard(movie: _peliculas[i]),
    );
  }
}