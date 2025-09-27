class League {
  ///
  final String idLeague;

  ///
  final String strLeague;

  ///

  final String? strSport;

  ///
  final String? strLeagueAlternate;

  ///
  final String? strCountry;
  ///
  League({
    required this.idLeague,
    required this.strLeague,
    this.strSport,
    this.strLeagueAlternate,
    this.strCountry,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      idLeague: json['idLeague'] ?? '',
      strLeague: json['strLeague'] ?? 'Unknown League',
      strSport: json['strSport'],
      strLeagueAlternate: json['strLeagueAlternate'],
      strCountry: json['strCountry'],
    );
  }
}
