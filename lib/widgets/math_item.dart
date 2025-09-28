import 'package:flutter/material.dart';
import 'package:rate_my_match_v2/theme/app_colors.dart';
import 'package:rate_my_match_v2/utils/date_hour_format.dart';
import 'package:rate_my_match_v2/widgets/team_play_item.dart';

import '../data/models/math_event.dart';

class MathItem extends StatelessWidget {
  final MatchEvent mathValue;

  ///
  const MathItem({super.key, required this.mathValue});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryColor,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: mathValue.seasonInfo.leagueBadgeUrl != null
                  ? Image.network(
                      mathValue.seasonInfo.leagueBadgeUrl!,
                      width: 30,
                      errorBuilder: (c, e, s) => Icon(Icons.sports),
                    )
                  : Icon(Icons.sports),
            ),
            TeamPlayItem(
              teamName: mathValue.teamInfo.homeTeamName,
              teamBadgeUrl: mathValue.teamInfo.homeTeamBadgeUrl,
              score: 0,
            ),
            SizedBox(height: 8),
            TeamPlayItem(
              teamName: mathValue.teamInfo.awayTeamName,
              teamBadgeUrl: mathValue.teamInfo.awayTeamBadgeUrl,
              score: 0,
            ),
            SizedBox(height: 8),
            Divider(color: Colors.black),
            //localeventTime
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${DateHoutFormat.formatToHourMinute(mathValue.dateInfoEvent.localEventTime!)} ${DateHoutFormat.formatYearMonthDayToDayMonthYear(mathValue.dateInfoEvent.localEventDate!)}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
