// lib/app/modules/events/controllers/events_controller.dart
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:rate_my_match_v2/data/models/math_event.dart';
import '../../../data/repositories/contracts/event_repository.dart';
import '../../data/models/league.dart';
import '../../data/providers/api/api_exception.dart'; // Para manejar excepciones de API
// Considera tener una clase de strings para mensajes: import '../../../config/strings/app_strings.dart';

class HomeController extends GetxController {
  ///
  final EventRepository _eventRepository = Get.find<EventRepository>();

  /// Para la lista de todas las ligas
  final RxList<League> allLeagues = <League>[].obs;
  final RxBool isLoadingLeagues = false.obs;
  final RxString leaguesError = ''.obs;

  /// Para la lista de partidos (ya sea por país o por liga)
  final RxList<MatchEvent> matches = <MatchEvent>[].obs;
  final RxBool isLoadingMatches = false.obs;
  final RxString matchesError = ''.obs;
  final RxString currentSearchTerm =
      ''.obs; // Para mostrar qué se está buscando

  ///
  final RxString selectedCountry =
      ''.obs; // Podría venir de un TextField o un selector

  ///
  final Rx<League?> selectedLeague = Rx<League?>(
    null,
  ); // Liga seleccionada en el Dropdown
  ///
  final Logger _logger = Logger();

  @override
  void onReady() {
    super.onReady();
    fetchAllLeagues();
  }

  /// Obtiene todas las ligas
  Future<void> fetchAllLeagues() async {
    isLoadingLeagues.value = true;
    leaguesError.value = '';
    currentSearchTerm.value = "Todas las ligas";

    selectedLeague.value = null;
    try {
      final List<League> leagues = await _eventRepository.getAllLeagues();
      if (leagues.isNotEmpty) {
        allLeagues.assignAll(leagues);
      } else {
        leaguesError.value = "No se encontraron ligas.";
      }
    } on ApiException catch (e) {
      leaguesError.value = "Error de API: ${e.message}";
    } catch (e) {
      leaguesError.value = "Ocurrió un error inesperado al cargar las ligas.";
      _logger.e("Error en fetchAllLeagues: $e");
    } finally {
      isLoadingLeagues.value = false;
    }
  }

  /// Método que se llama cuando una liga es seleccionada en el Dropdown
  void onLeagueSelected(League? league) {
    if (league != null) {
      selectedLeague.value = league;
      _logger.i(
        "Liga seleccionada: ${league.strLeague} (ID: ${league.idLeague})",
      );
      fetchMatchesByLeagueId(league.idLeague, league.strLeague);
    } else {
      // Si se deselecciona la liga (o se elige una opción "ninguna"),
      // limpia los partidos y el término de búsqueda.
      selectedLeague.value = null;
      clearMatchesSearch();
    }
  }

  ///Cargar partidos para la liga seleccionada
  Future<void> fetchMatchesForLeague(String leagueId, String leagueName) async {
    if (leagueId.trim().isEmpty) {
      matchesError.value = "ID de liga no válido.";
      return;
    }
    currentSearchTerm.value = "Partidos de la liga: $leagueName";
    isLoadingMatches.value = true;
    matchesError.value = '';
    matches.clear(); // Limpiar resultados anteriores

    try {
      final List<MatchEvent> fetchedMatches = await _eventRepository
          .getNextEventsByLeagueId(leagueId, leagueName: leagueName);
      if (fetchedMatches.isNotEmpty) {
        matches.assignAll(fetchedMatches);
      } else {
        matchesError.value =
            "No se encontraron próximos partidos para la liga $leagueName.";
      }
    } on ApiException catch (e) {
      matchesError.value = "Error de API: ${e.message}";
    } catch (e) {
      matchesError.value =
          "Ocurrió un error inesperado al buscar partidos por liga.";
      _logger.e("Error en fetchMatchesByLeagueId: $e");
    } finally {
      isLoadingMatches.value = false;
    }
  }

  /// Obtiene partidos para un nombre de país
  Future<void> fetchMatchesByCountry(String countryName) async {
    if (countryName.trim().isEmpty) {
      matchesError.value = "Por favor, ingresa un país.";
      return;
    }
    selectedCountry.value = countryName.trim();
    currentSearchTerm.value = "Partidos en ${selectedCountry.value}";
    isLoadingMatches.value = true;
    matchesError.value = '';
    matches.clear(); // Limpiar resultados anteriores

    try {
      final List<MatchEvent> fetchedMatches = await _eventRepository
          .getEventsByCountry(selectedCountry.value);
      if (fetchedMatches.isNotEmpty) {
        matches.assignAll(fetchedMatches);
      } else {
        matchesError.value =
            "No se encontraron partidos para ${selectedCountry.value}."; // AppStrings.noMatchesFoundForCountry(selectedCountry.value);
      }
    } on ApiException catch (e) {
      matchesError.value =
          "Error de API: ${e.message}"; // AppStrings.apiErrorPrefix + e.message;
    } catch (e) {
      matchesError.value =
          "Ocurrió un error inesperado al buscar partidos por país."; // AppStrings.unexpectedErrorSearchingMatches;
      print("Error en fetchMatchesByCountry: $e");
    } finally {
      isLoadingMatches.value = false;
    }
  }

  /// Obtiene partidos para una ID de liga específica
  Future<void> fetchMatchesByLeagueId(
    String leagueId,
    String leagueName,
  ) async {
    if (leagueId.trim().isEmpty) {
      matchesError.value = "ID de liga no válido.";
      return;
    }
    currentSearchTerm.value = "Partidos de la liga: $leagueName";
    isLoadingMatches.value = true;
    matchesError.value = '';
    matches.clear();
    selectedCountry.value = '';

    try {
      final List<MatchEvent> fetchedMatches = await _eventRepository
          .getNextEventsByLeagueId(leagueId, leagueName: leagueName);
      if (fetchedMatches.isNotEmpty) {
        matches.assignAll(fetchedMatches);
      } else {
        matchesError.value =
            "No se encontraron próximos partidos para la liga $leagueName.";
      }
    } on ApiException catch (e) {
      matchesError.value = "Error de API: ${e.message}";
      _logger.e("API Error en fetchMatchesByLeagueId: ${e.message}");
    } catch (e) {
      matchesError.value =
          "Ocurrió un error inesperado al buscar partidos por liga.";
      _logger.e("Error en fetchMatchesByLeagueId: $e");
    } finally {
      isLoadingMatches.value = false;
    }
  }

  /// Método para limpiar la búsqueda de partidos y errores
  void clearMatchesSearch() {
    matches.clear();
    matchesError.value = '';
    currentSearchTerm.value = '';
    selectedCountry.value = '';
    selectedLeague.value = null;
  }
}
