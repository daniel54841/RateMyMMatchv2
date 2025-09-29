
class ApiEndpoints{
  ///Obtención de todas las ligas disponibles
  static const String allLeagues = 'all_leagues.php';
  /// Obtención de proximos partidos/eventos
  static const String eventDay = "eventsday.php";
  /// Obtecion de partidos/eventos por fecha y liga
  /// Parametros: id={LEAGUE_ID}&s={SEASON_YEAR}
  static const String seasonEventsByLeagueId = "eventsseason.php";
  ///
  /// Obtención de todos los equipos filtrados por liga
  /// l={LEAGUE_NAME}
  static const String allTeamsByLeagueName = "search_all_teams.php";
  /// Busqueda de jugadores por equipo
  /// t={TEAM_NAME}
  static const String searchPlayersByTeamName = "searchplayers.php";
  /// Busqueda de jugadores por id
  /// id={PLAYER_ID}
  static const String playerDetailsById = "lookupplayer.php";
}