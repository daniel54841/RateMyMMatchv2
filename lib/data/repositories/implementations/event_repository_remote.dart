import 'package:get/get.dart';
import 'package:rate_my_match_v2/data/models/league.dart';
import 'package:rate_my_match_v2/data/repositories/contracts/event_repository.dart';
import '../../models/math_event.dart';
import '../../providers/api/api_client.dart';
import '../../providers/api/api_endpoints.dart';
import '../../providers/api/api_exception.dart';

class EventRepositoryRemote extends EventRepository{
  final ApiClient _apiClient = Get.find<ApiClient>();
  @override
  Future<List<League>> getAllLeagues() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.allLeagues);

      if (response != null && response['leagues'] != null) {
        final List<dynamic> leaguesJson = response['leagues'];
        return leaguesJson.map((json) => League.fromJson(json)).toList();
      } else {
        // No se encontraron ligas o la respuesta fue inesperada/nula
        _apiClient.logger.i("getAllLeagues no devolvió nada. Comprobar si la respuesta es nula");
        return [];
      }
    } on ApiException catch (e) {
      // Puedes manejar excepciones específicas de la API aquí o relanzarlas
      _apiClient.logger.e("ApiException en getAllLeagues: $e");
      // Considera retornar una lista vacía o relanzar dependiendo de cómo quieras manejarlo en la UI
      // throw Exception("Error de API al obtener ligas: ${e.message}");
      rethrow; // Relanzar para que el controlador/UI pueda manejarlo
    } catch (e) {
      _apiClient.logger.e("Error inesperado en getAllLeagues: $e");
      throw Exception("No se pudieron obtener todas las ligas debido a un error inesperado.");
    }
  }

  @override
  Future<List<MatchEvent>> getEventsByCountry(String countryName) async {
    if (countryName.trim().isEmpty) {
      _apiClient.logger.i("getEventsByCountry llamado con nombre de país vacío.");
      return [];
    }

    _apiClient.logger.i("INFO: Buscando eventos para el país: $countryName");
    List<MatchEvent> allCountryEvents = [];

    try {
      // 1. Obtener todas las ligas
      final List<League> allLeagues = await getAllLeagues();
      if (allLeagues.isEmpty) {
        _apiClient.logger.i("INFO: No se encontraron ligas en la API para buscar por país.");
        return [];
      }

      // 2. Filtrar ligas por el país deseado (ignorando mayúsculas/minúsculas)
      final List<League> countryLeagues = allLeagues.where((league) {
        return league.strLeague.split(' ').first.toLowerCase() == countryName.toLowerCase();
      }).toList();

      if (countryLeagues.isEmpty) {
        _apiClient.logger.i("INFO: No se encontraron ligas para el país: $countryName");
        return [];
      }
      _apiClient.logger.i("INFO: Ligas encontradas para $countryName: ${countryLeagues.map((l) => "${l.strLeague} (ID: ${l.idLeague})").join(', ')}");

      // 3. Obtener eventos para cada liga filtrada.
      // Usamos Future.wait para realizar las llamadas en paralelo para mejor rendimiento.
      List<Future<List<MatchEvent>>> futureLeagueEventsOperations = [];

      for (final league in countryLeagues) {
        // Añadimos la operación (Future) a la lista
        futureLeagueEventsOperations.add(
          // Pasamos el nombre de la liga y el país para un posible enriquecimiento
          // del objeto Match si tu Match.fromJson lo soporta.
            getEventDay(
              league.strLeague,

            ).catchError((e) {
              // Si una llamada a getNextEventsByLeagueId falla, capturamos el error aquí
              // para que Future.wait no falle por completo. Devolvemos una lista vacía
              // para esa liga específica y logueamos el error.
              _apiClient.logger.e("ERROR: Fallo al obtener eventos para la liga ${league.idLeague} (${league.strLeague}): $e");
              return <MatchEvent>[]; // Devolver lista vacía en caso de error para esta liga
            })
        );
      }

      // Esperar a que todas las llamadas a la API para los eventos de las ligas se completen
      final List<List<MatchEvent>> resultsPerLeague = await Future.wait(futureLeagueEventsOperations);

      // Consolidar todos los eventos de todas las listas de resultados
      for (var eventListFromOneLeague in resultsPerLeague) {
        allCountryEvents.addAll(eventListFromOneLeague);
      }

      // Opcional: Ordenar todos los eventos por fecha si es necesario
      // Esto requiere que Match.dateTimeDetails.eventDate y eventTime sean parseables a DateTime.
      try {
        allCountryEvents.sort((a, b) {
          final aDateStr = a.dateInfoEvent?.eventDate;
          final bDateStr = b.dateInfoEvent?.eventDate;
          final aTimeStr = a.dateInfoEvent?.eventTime ?? "00:00:00";
          final bTimeStr = b.dateInfoEvent?.eventTime ?? "00:00:00";

         if(aDateStr != null || bDateStr != null){
           if (aDateStr!.isEmpty || bDateStr!.isEmpty) return 0;
         }else{
           return 0;
         }

          try {
            DateTime dateA = DateTime.parse("$aDateStr $aTimeStr");
            DateTime dateB = DateTime.parse("$bDateStr $bTimeStr");
            return dateA.compareTo(dateB);
          } catch (e) {
            _apiClient.logger.e("Error al parsear fecha para ordenar eventos: $e. Evento A: $aDateStr $aTimeStr, Evento B: $bDateStr $bTimeStr");
            return 0; // No ordenar si hay error de parseo
          }
        });
      } catch (e) {
        _apiClient.logger.e("Error general al intentar ordenar los eventos por país: $e");
      }


      _apiClient.logger.i("Total de eventos encontrados para $countryName: ${allCountryEvents.length}");
      return allCountryEvents;

    } on ApiException catch (e) {
      _apiClient.logger.e("ApiException en getEventsByCountry para $countryName: $e");
      rethrow;
    } catch (e) {
      _apiClient.logger.e("Error inesperado en getEventsByCountry para $countryName: $e");
      throw Exception("No se pudieron obtener los eventos para el país '$countryName' debido a un error inesperado.");
    }
  }

  @override
  Future<List<MatchEvent>> getEventDay(String leagueName, {String? day}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.eventDay,
        queryParameters: {'d': day,'l':leagueName},
      );

      // Los eventos suelen estar en una clave "events"
      if (response != null && response['events'] != null) {
        final List<dynamic> eventsJson = response['events'];
        return eventsJson.map((json) => MatchEvent.fromJson(json)).toList();
      } else {
        _apiClient.logger.i("getNextEventsByLeagueId  no devolvió nada. Comprobar si la respuesta es nula");
        return [];
      }
    } on ApiException catch (e) {
      _apiClient.logger.e("ApiException en getNextEventsByLeagueId para la liga $leagueName: $e");
      rethrow;
    } catch (e) {
      _apiClient.logger.e("Error inesperado en getNextEventsByLeagueId para la liga $leagueName: $e");
      throw Exception("No se pudieron obtener los eventos para la liga con ID '$leagueName'.");
    }
  }

}