import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TmdbService {
  // 👇 PEGA AQUÍ TU API KEY (v3) de https://www.themoviedb.org/settings/api
  static const String _apiKey = 'TU_API_KEY_AQUI';
  static const String _base = 'https://api.themoviedb.org/3';

  // Estado de ánimo -> id de género de TMDB
  static const Map<String, int> generosPorAnimo = {
    'Feliz': 35, // Comedia
    'Triste': 18, // Drama
    'Emocionado': 28, // Acción
    'Asustado': 27, // Terror
    'Romántico': 10749, // Romance
    'Curioso': 878, // Ciencia ficción
  };

  Future<List<Movie>> _get(String path, Map<String, String> params) async {
    final uri = Uri.parse('$_base$path').replace(queryParameters: {
      'api_key': _apiKey,
      'language': 'es-MX',
      ...params,
    });
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode}: revisa tu API key o conexión');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return (data['results'] as List)
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Lista de películas populares del género según el ánimo.
  Future<List<Movie>> porAnimo(String animo) {
    final genero = generosPorAnimo[animo]!;
    return _get('/discover/movie', {
      'with_genres': '$genero',
      'sort_by': 'popularity.desc',
      'page': '1',
    });
  }

  /// Tendencias de la semana.
  Future<List<Movie>> tendencias() => _get('/trending/movie/week', {});

  /// Una película al azar del género según el ánimo.
  Future<Movie> alAzar(String animo) async {
    final genero = generosPorAnimo[animo]!;
    final pagina = Random().nextInt(10) + 1;
    final lista = await _get('/discover/movie', {
      'with_genres': '$genero',
      'sort_by': 'popularity.desc',
      'page': '$pagina',
    });
    if (lista.isEmpty) throw Exception('Sin resultados');
    return lista[Random().nextInt(lista.length)];
  }
}