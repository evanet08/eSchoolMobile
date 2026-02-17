import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/appel.dart';

class PresenceItem extends StatelessWidget {
  final Appel presence;
  final Function(bool?) onChanged;
  const PresenceItem({
    super.key,
    required this.presence,
    required this.onChanged,
  });

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
              child: Text("${presence.eleve.noms} ${presence.eleve.prenom}"),
            ),
          ],
        ),
        Switch(value: presence.estPresent, onChanged: onChanged),
      ],
    );
  }
}
