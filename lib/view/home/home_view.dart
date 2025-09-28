// lib/app/modules/events/views/events_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rate_my_match_v2/data/models/league.dart';
import 'package:rate_my_match_v2/widgets/math_item.dart';

import '../../data/models/math_event.dart';
import '../../theme/app_colors.dart';
import 'home_controller.dart';

///
class HomeView extends GetView<HomeController> {

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor, // AppStrings.eventsScreenTitle
        title: Text(
          'RATE MY MATCH',
          style: Get.textTheme.titleLarge?.copyWith(color: AppColors.textColor),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'PARTIDOS',
                      style: Get.textTheme.titleLarge?.copyWith(
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Obx(() {
                      if (controller.isLoadingLeagues.value &&
                          controller.allLeagues.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.leaguesError.value.isNotEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.leaguesError.value,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: controller.fetchAllLeagues,
                                child: const Text("Reintentar cargar ligas"),
                              ),
                            ],
                          ),
                        );
                      }
                      if (controller.allLeagues.isEmpty &&
                          !controller.isLoadingLeagues.value) {
                        return const Center(
                          child: Text("No hay ligas disponibles."),
                        );
                      }

                      return DropdownButtonFormField<League>(
                        decoration: InputDecoration(
                          labelText: 'Selecciona una Liga',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                        ),
                        isExpanded: true, // Para que ocupe el ancho disponible
                        hint: const Text(
                          'Elige una liga...',
                        ), // Texto cuando no hay nada seleccionado
                        value: controller
                            .selectedLeague
                            .value, // La liga actualmente seleccionada
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        items: controller.allLeagues
                            .map<DropdownMenuItem<League>>((League league) {
                              return DropdownMenuItem<League>(
                                value: league, // El objeto League completo
                                child: Text(
                                  league
                                      .strLeague, // Muestra el nombre de la liga
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            })
                            .toList(),
                        onChanged: (League? newValue) {
                          controller.onLeagueSelected(newValue);
                        },
                        // Opcional: añadir validación
                        // validator: (value) => value == null ? 'Por favor selecciona una liga' : null,
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                      style: Get.textTheme.titleMedium?.copyWith(
                        color: AppColors.textColor,
                      ),
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
                      style: Get.textTheme.titleMedium?.copyWith(
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.matches.length,
                      itemBuilder: (context, index) {
                        final MatchEvent match = controller.matches[index];
                        return MathItem(mathValue: match);
                      },
                    ),
                    SizedBox(height: 10),
                    if (controller.matches.isNotEmpty)
                      TextButton(
                        onPressed: controller.clearMatchesSearch,
                        child: Text(
                          "Limpiar búsqueda de partidos",
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
