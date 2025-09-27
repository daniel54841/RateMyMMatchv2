class DateInfoEvent{
  /// Timestamp completo del evento en UTC. Original: strTimestamp
  final String? eventTimestamp;
  /// Fecha del evento en formato YYYY-MM-DD (probablemente UTC). Original: dateEvent
  final String eventDate;
  /// Fecha del evento en formato YYYY-MM-DD (local del evento). Original: dateEventLocal
  final String? localEventDate;
  /// Hora del evento en formato HH:MM:SS (probablemente UTC). Original: strTime
  final String? eventTime;
  /// Hora del evento en formato HH:MM:SS (local del evento). Original: strTimeLocal
  final String? localEventTime;
  ///
  DateInfoEvent({required this.eventTimestamp, required this.eventDate, required this.localEventDate, required this.eventTime, required this.localEventTime});
  ///
  factory DateInfoEvent.fromJson(Map<String, dynamic> json) {
    return DateInfoEvent(
      eventTimestamp: json['strTimestamp'],
      eventDate: json['dateEvent'] ?? '', // Hacerlo no nulo si es un campo esencial
      localEventDate: json['dateEventLocal'],
      eventTime: json['strTime'],
      localEventTime: json['strTimeLocal'],
    );
  }

}