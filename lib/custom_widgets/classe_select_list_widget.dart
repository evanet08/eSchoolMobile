import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/classe_select_item.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ClasseSelectListWidget extends StatefulWidget {
  const ClasseSelectListWidget({super.key});

  @override
  State<ClasseSelectListWidget> createState() => _ClasseSelectListWidgetState();
}

class _ClasseSelectListWidgetState extends State<ClasseSelectListWidget> {
  late ClassesProvider classesProvider;
  @override
  Widget build(BuildContext context) {
    classesProvider = Provider.of<ClassesProvider>(context);
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            color: ColorConstantes.whiteColor,
            border: Border.all(
              color:
                  classesProvider.classe == null
                      ? ColorConstantes.primaryColor
                      : ColorConstantes.greyColor,
              width: 2.0,
            ), // Optional: Add a background color
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                classesProvider.classe = null;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                AppLocalizations.of(context)!.all_classes,
                style: TextStyle().copyWith(
                  color:
                      classesProvider.classe == null
                          ? ColorConstantes.primaryColor
                          : ColorConstantes.blackColor,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  classesProvider.classes.map((Classe classe) {
                    return ClasseSelectItem(
                      classe: classe,
                      onTap: () {
                        setState(() {
                          classesProvider.classe = classe;
                        });
                      },
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
