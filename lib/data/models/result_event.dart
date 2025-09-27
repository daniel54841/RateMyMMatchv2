class ResultEvent{
  /// Puntuación del equipo local (puede ser null si no ha comenzado/terminado). Original: intHomeScore
  final String? homeScore;
  /// Puntuación del equipo visitante. Original: intAwayScore
  final String? awayScore;
  /// Puntuación combinada o algún otro tipo de puntuación (a menudo null). Original: intScore
  final String? totalScore;
  /// Número de votos para una puntuación (a menudo null). Original: intScoreVotes
  final int? scoreVotes;

  ResultEvent({required this.homeScore, required this.awayScore, required this.totalScore, required this.scoreVotes});
  ///
  factory ResultEvent.fromJson(Map<String, dynamic> json) {
    return ResultEvent(
      homeScore: json['intHomeScore'],
      awayScore: json['intAwayScore'],
      totalScore: json['intScore'],
      scoreVotes: json['intScoreVotes'] != null ? int.tryParse(json['intScoreVotes'].toString()) : null,
    );
  }
}