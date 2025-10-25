import 'package:flutter/foundation.dart';
import 'package:rate_my_match_v2/data/models/date_info_event.dart';
import 'package:rate_my_match_v2/data/models/league_season_info.dart';
import 'package:rate_my_match_v2/data/models/multimedia_info_event.dart';
import 'package:rate_my_match_v2/data/models/place_info_event.dart';
import 'package:rate_my_match_v2/data/models/result_event.dart';
import 'package:rate_my_match_v2/data/models/team_info.dart';

import 'event.dart'; // Para @required o required en versiones antiguas

class MatchEvent {
  ///Identificador único del evento en TheSportsDB. Original: idEvent
  final String? id; //

  // --- Información General del Evento ---
  final Event? event;

  // --- Información de la Liga y Temporada ---
  final LeagueSeasonInfo? seasonInfo;

  // --- Información de los Equipos ---
  final TeamInfo? teamInfo;
  // --- Resultados y Puntuación ---
  final ResultEvent? resultEvent;
  // --- Fecha y Hora ---
  final DateInfoEvent? dateInfoEvent;
  // --- Ubicación y Detalles Adicionales ---
  final PlaceInfoEvent? placeInfoEvent;
  // --- Multimedia y Redes Sociales ---
  final MultimediaInfoEvent? multimediaInfoEvent;

  ///
  MatchEvent({
    this.id,
    this.event,
    this.seasonInfo,
    this.teamInfo,
    this.resultEvent,
    this.dateInfoEvent,
    this.placeInfoEvent,
    this.multimediaInfoEvent,
  });

  ///
  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
      id: json['idEvent'] ?? '',
      event: Event.fromJson(json),
      seasonInfo: LeagueSeasonInfo.fromJson(json),
      teamInfo: TeamInfo.fromJson(json),
      resultEvent: ResultEvent.fromJson(json),
      dateInfoEvent: DateInfoEvent.fromJson(json),
      placeInfoEvent: PlaceInfoEvent.fromJson(json),
      multimediaInfoEvent: MultimediaInfoEvent.fromJson(json),
    );
  }
}
