import 'package:flutter/material.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/conduite.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class ConduiteEnfantParentItem extends StatelessWidget {
  final Conduite conduite;
  const ConduiteEnfantParentItem({super.key, required this.conduite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/profile.png",
            scale: 1,
            width: 40,
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("${conduite.eleve.noms} ${conduite.eleve.prenom}"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.schedule,
                  style: TextStyle().copyWith(fontSize: 12),
                ),
                Text(
                  "${conduite.creneau.cours}: ${conduite.creneau.jour}, ${conduite.date}",
                  style: TextStyle().copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quote", style: TextStyle().copyWith(fontSize: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      conduite.mention < 1
                          ? "assets/images/star_black.png"
                          : "assets/images/star_yellow.png",
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(width: 5),
                    Image.asset(
                      conduite.mention < 2
                          ? "assets/images/star_black.png"
                          : "assets/images/star_yellow.png",
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(width: 5),
                    Image.asset(
                      conduite.mention < 3
                          ? "assets/images/star_black.png"
                          : "assets/images/star_yellow.png",
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(width: 5),
                    Image.asset(
                      conduite.mention < 4
                          ? "assets/images/star_black.png"
                          : "assets/images/star_yellow.png",
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(width: 5),
                    Image.asset(
                      conduite.mention < 5
                          ? "assets/images/star_black.png"
                          : "assets/images/star_yellow.png",
                      width: 15,
                      height: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      Helpers.getMentionConduiteStrByValue(
                        context,
                        conduite.mention,
                      ),
                      style: TextStyle().copyWith(
                        color:
                            conduite.mention < 3
                                ? ColorConstantes.redColor
                                : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
