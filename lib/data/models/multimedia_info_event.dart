class MultimediaInfoEvent{
  /// URL de una imagen tipo póster para el evento. Original: strPoster
  final String? posterUrl;
  /// URL a un video destacado o resumen del evento (a menudo vacío). Original: strVideo
  final String? videoUrl;

  MultimediaInfoEvent({required this.posterUrl, required this.videoUrl});
  ///
  factory MultimediaInfoEvent.fromJson(Map<String, dynamic> json) {
     return MultimediaInfoEvent(
      posterUrl: json['strPoster'],
      videoUrl: json['strVideo'],
    );
  }
}