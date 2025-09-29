class Event {
  /// Nombre principal del evento  Original: strEvent
  final String nameEvent;

  /// Tipo de deporte (ej. "Soccer"). Original: strSport
  final String sportType;

  /// Estado actual del evento Original: strStatus
  final String? status;

  /// Indica si el evento ha sido pospuesto ("yes", "no"). Original: strPostponed
  final String postponedStatus;

  Event({
    required this.nameEvent,
    required this.sportType,
    this.status,
    required this.postponedStatus,
  });
///
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      nameEvent:
          json['strEvent'] ??
          json['strFilename'] ??
          'Unknown Event', // Usar filename si strEvent es nulo
      sportType: json['strSport'] ?? 'Unknown Sport', // Esencial
      status: json['strStatus'],
      postponedStatus:
          json['strPostponed'] ?? 'no', // Default a 'no' si es nulo
    );
  }
}
