import '../../models/league.dart';
import '../../models/math_event.dart';

///
abstract class EventRepository{
  /// Obtiene la lista de todas las ligas disponibles
  Future<List<League>> getAllLeagues();
  /// Obtiene los próximos N eventos/partidos para una ID de liga específica.
  ///
  /// Opcionalmente puede recibir [leagueName] y [countryName] para enriquecer
  /// los objetos [MatchEvent] devueltos si esa información no viene directamente
  /// en la respuesta del endpoint de eventos de la liga.
  Future<List<MatchEvent>> getEventDay(
      String leagueName, {String? day});
  /// Obtiene todos los próximos eventos/partidos para un país específico.
  ///
  /// Esto implicará primero encontrar las ligas de ese país y luego
  /// obtener los eventos de esas ligas.
  Future<List<MatchEvent>> getEventsByCountry(String countryName);
}