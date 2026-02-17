import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/creneau.dart';

class CreneauParentItem extends StatelessWidget {
  final Creneau creneau;
  const CreneauParentItem({super.key, required this.creneau});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${creneau.heureDebut} - ${creneau.heureFin}"),
          Text(creneau.cours),
          Text(creneau.classe),
        ],
      ),
    );
  }
}
