import 'package:flutter/material.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/models/note.dart';
import 'package:eschoolmobile/utils/theme/constantes/font_size_constantes.dart';

class NoteParentItem extends StatelessWidget {
  final Note note;
  const NoteParentItem({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.cours,
                      textAlign: TextAlign.center,
                      style: TextStyle().copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: FontSizeConstantes.largeFontsize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text("Note"), Text(": ${note.note}")],
                  ),
                ],
              ),
            ),
            Row(
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
                        children: [Text(note.eleve), Text(note.classe)],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "assets/images/star_black.png",
                  width: 15,
                  height: 15,
                  color:
                      note.note >= note.ponderation / 2
                          ? Colors.orange
                          : Colors.black,
                ),
                SizedBox(width: 5),
                Image.asset(
                  "assets/images/star_black.png",
                  width: 15,
                  height: 15,
                  color:
                      note.note >= note.ponderation / 2 + 2
                          ? Colors.orange
                          : Colors.black,
                ),
                SizedBox(width: 5),
                Image.asset(
                  "assets/images/star_black.png",
                  width: 15,
                  height: 15,
                  color:
                      note.note >= note.ponderation / 2 + 2
                          ? Colors.orange
                          : Colors.black,
                ),
                SizedBox(width: 5),
                Image.asset(
                  "assets/images/star_black.png",
                  width: 15,
                  height: 15,
                  color:
                      note.note >= note.ponderation / 2 + 3
                          ? Colors.orange
                          : Colors.black,
                ),
                SizedBox(width: 5),
                Image.asset(
                  "assets/images/star_black.png",
                  width: 15,
                  height: 15,
                  color:
                      note.note == note.ponderation
                          ? Colors.orange
                          : Colors.black,
                ),
                SizedBox(width: 5),
                Text(
                  note.note < note.ponderation / 2
                      ? 'Assez bon'
                      : note.note < note.ponderation / 2 + 2
                      ? 'Bon'
                      : note.note < note.ponderation
                      ? 'Très bon'
                      : AppLocalizations.of(context)!.excellent,
                  style: TextStyle().copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
