class TeamInfo{
  /// Nombre del equipo local. Original: strHomeTeam
  final String homeTeamName;
  /// ID del equipo local en TheSportsDB. Original: idHomeTeam
  final String? homeTeamId;
  /// URL de la imagen del escudo/logo del equipo local. Original: strHomeTeamBadge
  final String? homeTeamBadgeUrl;
  /// Nombre del equipo visitante. Original: strAwayTeam
  final String awayTeamName;
  /// ID del equipo visitante en TheSportsDB. Original: idAwayTeam
  final String? awayTeamId;
  /// URL de la imagen del escudo/logo del equipo visitante. Original: strAwayTeamBadge
  final String? awayTeamBadgeUrl;

  TeamInfo({required this.homeTeamName, required this.homeTeamId, required this.homeTeamBadgeUrl, required this.awayTeamName, required this.awayTeamId, required this.awayTeamBadgeUrl});

  ///
  factory TeamInfo.fromJson(Map<String, dynamic> json) {
    return TeamInfo(
      homeTeamName: json['strHomeTeam'] ?? 'Home Team',
      homeTeamId: json['idHomeTeam'],
      homeTeamBadgeUrl: json['strHomeTeamBadge'],
      awayTeamName: json['strAwayTeam'] ?? 'Away Team',
      awayTeamId: json['idAwayTeam'],
      awayTeamBadgeUrl: json['strAwayTeamBadge'],
    );
  }
}
