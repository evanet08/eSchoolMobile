import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/appel.dart';

class AppelItem extends StatelessWidget {
  final Appel appel;
  final Function(bool?) onChanged;
  const AppelItem({super.key, required this.appel, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/profile.png",
              scale: 1,
              width: 30,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text("${appel.eleve.noms} ${appel.eleve.prenom}"),
            ),
          ],
        ),
        Checkbox(value: appel.estPresent, onChanged: onChanged),
      ],
    );
  }
}
