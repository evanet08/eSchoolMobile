import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/my_text.dart';
import 'package:eschoolmobile/models/creneau.dart';
import 'package:eschoolmobile/services/navigation_service.dart';

class CreneauItem extends StatelessWidget {
  final Creneau creneau;
  const CreneauItem({super.key, required this.creneau});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PopupMenuButton(
        itemBuilder:
            (ctx) => <PopupMenuItem>[
              PopupMenuItem(
                onTap:
                    () => NavigationService.instance.navigateTo(
                      "presences",
                      args: creneau,
                    ),
                value: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/attendance.png",
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: MyText(text: "Présences"),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap:
                    () => NavigationService.instance.navigateTo(
                      "appel",
                      args: creneau,
                    ),
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/active.png",
                      width: 20,
                      height: 20,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: MyText(text: "Appel"),
                    ),
                  ],
                ),
              ),
            ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${creneau.heureDebut} - ${creneau.heureFin}"),
            Text(creneau.cours),
            Text(creneau.classe),
          ],
        ),
      ),
    );
  }
}
