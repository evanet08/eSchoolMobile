import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:provider/provider.dart';

class EleveSelectItem extends StatelessWidget {
  final Eleve eleve;
  final Function() onTap;
  const EleveSelectItem({super.key, required this.eleve, required this.onTap});

  @override
  Widget build(BuildContext context) {
    EleveProvider eleveProvider = Provider.of<EleveProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: ColorConstantes.whiteColor,
          border: Border.all(
            width: 1.0,
            color:
                eleveProvider.eleve != eleve
                    ? ColorConstantes.greyColor
                    : ColorConstantes.primaryColor,
          ), // Optional: Add a background color
        ),

        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Image.asset("assets/images/profile.png", width: 20, height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "${eleve.noms} ${eleve.prenom}",
                    textAlign: TextAlign.center,
                    style: TextStyle().copyWith(
                      color:
                          eleveProvider.eleve != eleve
                              ? ColorConstantes.blackColor
                              : ColorConstantes.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
