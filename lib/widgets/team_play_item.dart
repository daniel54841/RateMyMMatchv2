import 'package:flutter/material.dart';
import 'package:rate_my_match_v2/data/models/team_info.dart';

class TeamPlayItem extends StatelessWidget {
  ///
  final String teamName;
  ///
  final String? teamBadgeUrl;
  ///
  final int score;
  //homeTeamName
  // homeTeamBadgeUrl
  //awayTeamName
   const TeamPlayItem({super.key, required this.teamName, required this.teamBadgeUrl, required this.score});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Añade un padding si quieres espacio alrededor de toda la fila
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Row(
        children: [
          // Team Badge
          teamBadgeUrl != null && teamBadgeUrl!.isNotEmpty
              ? Image.network(
            teamBadgeUrl!,
            width: 30,
            height: 30, // Es bueno dar un alto también para evitar saltos de layout
            fit: BoxFit.contain, // O BoxFit.cover según necesites
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.sports, size: 30), // Ícono con tamaño definido
          )
              : const Icon(Icons.sports, size: 30), // Ícono con tamaño definido

          const SizedBox(width: 10.0), // Espacio entre el logo y el nombre

          // Team Name (flexible para ocupar el espacio y permitir que el nombre se ajuste)
          Expanded( // 'Expanded' en lugar de 'Flexible' asegura que tome el espacio necesario
            child: Text(
              teamName,
              style: const TextStyle(fontSize: 16), // Ajusta el estilo según necesites
              overflow: TextOverflow.ellipsis, // Para nombres largos
              maxLines: 1, // Limita a una línea
            ),
          ),

          // Spacer para empujar el score hacia la derecha
          // const Spacer(), // Esto se elimina si el nombre del equipo es `Expanded` y el score no.

          // Score (Alineado a la derecha)
          Padding(
            padding: const EdgeInsets.only(left: 8.0), // Espacio entre nombre y score si no hay Spacer
            child: Text(
              score.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Estilo para el score
            ),
          )
        ],
      ),
    );
  }
}
