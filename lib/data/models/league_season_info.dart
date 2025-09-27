class LeagueSeasonInfo {
  /// Identificador de la liga a la que pertenece el evento. Original: idLeague
  final String leagueId;

  /// Nombre de la liga. Original: strLeague
  final String leagueName;

  /// URL de la imagen del escudo/logo de la liga. Original: strLeagueBadge
  final String? leagueBadgeUrl;

  /// Temporada a la que pertenece el evento (ej. "2025-2026"). Original: strSeason
  final String season;

  /// Número de la jornada o ronda dentro de la competición. Original: intRound
  final String? round;

  LeagueSeasonInfo({
    required this.leagueId,
    required this.leagueName,
    this.leagueBadgeUrl,
    required this.season,
    this.round,
  });
  ///
  factory LeagueSeasonInfo.fromJson(Map<String, dynamic> json) {
    return LeagueSeasonInfo(
      leagueId: json['idLeague'] ?? '',
      leagueName: json['strLeague'] ?? 'Unknown League',
      leagueBadgeUrl: json['strLeagueBadge'],
      season: json['strSeason'] ?? '',
      round: json['intRound'],
    );
  }
}
