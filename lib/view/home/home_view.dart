// lib/app/modules/events/views/events_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rate_my_match_v2/data/models/league.dart';

import '../../data/models/math_event.dart';
import '../../theme/app_colors.dart';
import 'home_controller.dart';

///
class HomeView extends GetView<HomeController> {
  final TextEditingController _countryController = TextEditingController();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor, // AppStrings.eventsScreenTitle
        title:
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _countryController,
                    decoration: InputDecoration(
                      hintText:
                      "Buscador de partidos por pais", // AppStrings.countrySearchHint
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: AppColors.textColor)
                    ),
                    onSubmitted: (value) =>
                        controller.fetchMatchesByCountry(value),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    controller.fetchMatchesByCountry(_countryController.text);
                  },
                  child: Text("Buscar"), // AppStrings.searchButton
                ),
              ],
            ),

        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.textColor),
            onPressed: () {

            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lista de Partidos
              Obx(() {
                if (controller.isLoadingMatches.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.matchesError.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.matchesError.value,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (controller.matches.isEmpty &&
                    controller.currentSearchTerm.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      "No se encontraron resultados para '${controller.currentSearchTerm.value}'.",
                    ),
                  );
                }
                if (controller.matches.isEmpty) {
                  return SizedBox.shrink(); // No mostrar nada si no hay búsqueda activa o resultados
                }


                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.currentSearchTerm.value,
                      style: Get.textTheme.titleSmall?.copyWith(color: Colors.white,),
                    ),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.matches.length,
                      itemBuilder: (context, index) {
                        final MatchEvent match = controller.matches[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: match.multimediaInfoEvent.posterUrl != null
                                ? Image.network(
                                    "${match.multimediaInfoEvent.posterUrl!}/preview",
                                    width: 50,
                                    errorBuilder: (c, e, s) =>
                                        Icon(Icons.sports),
                                  )
                                : Icon(Icons.sports),
                            title: Text(match.event.nameEvent),
                            subtitle: Text(
                              "${match.teamInfo.homeTeamName} vs ${match.teamInfo.awayTeamName}\n"
                              "Liga: ${match.seasonInfo.leagueName}\n"
                              "Fecha: ${match.dateInfoEvent.eventDate} ${match.dateInfoEvent.eventTime ?? ''}",
                            ),
                            isThreeLine: true,
                            // onTap: () => Get.toNamed('/match-details', arguments: match.id), // Para ir a detalles del partido
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    if (controller.matches.isNotEmpty)
                      TextButton(
                        onPressed: controller.clearMatchesSearch,
                        child: Text("Limpiar búsqueda de partidos"),
                      ),
                  ],
                );
              }),
              SizedBox(height: 30),

              // --- Sección para Listar Todas las Ligas (Ejemplo) ---
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Todas las Ligas", style: Get.textTheme.titleMedium),
                  ElevatedButton(
                    onPressed: controller.fetchAllLeagues,
                    child: Text("Cargar Ligas"), // AppStrings.loadLeaguesButton
                  ),
                ],
              ),
              Obx(() {
                if (controller.isLoadingLeagues.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.leaguesError.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.leaguesError.value,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (controller.allLeagues.isEmpty) {
                  return Center(
                    child: Text("Presiona 'Cargar Ligas' para verlas."),
                  ); // AppStrings.pressToLoadLeagues
                }

                // Lista de Ligas
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.allLeagues.length,
                  itemBuilder: (context, index) {
                    final League league = controller.allLeagues[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Image.network(
                          league.strLeague,
                          width: 40,
                          errorBuilder: (c, e, s) => Icon(Icons.shield),
                        ),
                        title: Text(league.strLeague),
                        subtitle: Text(
                          league.strSport ?? 'Deporte Desconocido',
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          // Al seleccionar una liga, buscar sus partidos
                          controller.fetchMatchesByLeagueId(
                            league.idLeague,
                            league.strLeague,
                          );
                        },
                      ),
                    );
                  },
                );
              }),*/
            ],
          ),
        ),
      ),
    );
  }
}
