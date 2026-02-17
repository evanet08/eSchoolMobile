import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/my_text.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';

class EleveItem extends StatelessWidget {
  final Eleve eleve;
  final Function(dynamic)? onSlected;
  const EleveItem({super.key, required this.eleve, required this.onSlected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: PopupMenuButton(
        onSelected: onSlected,
        itemBuilder:
            (BuildContext context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      color: ColorConstantes.primaryColor,
                    ),
                    MyText(text: "Details"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    MyText(text: "Conduite"),
                  ],
                ),
              ),
            ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/profile.png",
                  scale: 1,
                  width: 40,
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${eleve.noms} ${eleve.prenom}"),
                      Text(eleve.classe.designation),
                    ],
                  ),
                ),
              ],
            ),
            Icon(
              Icons.more_vert,
              color: ColorConstantes.greyColor,
              size: IconSizeConstantes.small,
            ),
          ],
        ),
      ),
    );
  }
}
