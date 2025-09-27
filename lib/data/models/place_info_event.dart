class PlaceInfoEvent{
  /// Nombre del lugar/estadio. Original: strVenue
  final String? venueName;
  /// País donde se juega el evento. Original: strCountry
  final String? countryName;
  /// Ciudad donde se juega el evento (a menudo vacío). Original: strCity
  final String? cityName;
  /// Número de espectadores (a menudo null). Original: intSpectators
  final int? spectators;
  /// Nombre del árbitro oficial (a menudo vacío). Original: strOfficial
  final String? officialReferee;

  PlaceInfoEvent({required this.venueName, required this.countryName, required this.cityName, required this.spectators, required this.officialReferee});
  ///
  factory PlaceInfoEvent.fromJson(Map<String, dynamic> json) {
    return PlaceInfoEvent(
      venueName: json['strVenue'],
      countryName: json['strCountry'],
      cityName: json['strCity'], spectators: json['intSpectators'] != null ? int.tryParse(json['intSpectators'].toString()) : null,
      officialReferee: json['strOfficial'],
    );
  }
}