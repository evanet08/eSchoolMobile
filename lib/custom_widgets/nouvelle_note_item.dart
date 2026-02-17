import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/models/note.dart';

class NouvelleNoteItem extends StatelessWidget {
  final Note note;
  const NouvelleNoteItem({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
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
                child: Text(note.eleve),
              ),
            ],
          ),
          MyTextField(
            label: "",
            placeholder: "",
            textInputType: TextInputType.number,
            width: 60.0,
            height: 25.0,
            onChanged: (value) {
              if (value != null && value != "") {
                try {
                  note.note = double.parse(value);
                } catch (e) {}
              } else {
                note.note = -1;
              }
            },
          ),
        ],
      ),
    );
  }
}
