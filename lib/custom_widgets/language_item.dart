import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/my_text.dart';
import 'package:eschoolmobile/models/language.dart';

class LanguageItem extends StatelessWidget {
  final Language language;

  const LanguageItem({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        child: Row(
          children: [
            Image(image: AssetImage(language.imageSrc), height: 20.0),
            const SizedBox(width: 10.0),
            MyText(text: language.language),
          ],
        ),
      ),
    );
  }
}
