import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:provider/provider.dart';

class CoursSelectItem extends StatelessWidget {
  final Cours cours;
  final Function() onTap;
  const CoursSelectItem({super.key, required this.cours, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ClassesProvider classesProvider = Provider.of<ClassesProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: ColorConstantes.whiteColor,
          border: Border.all(
            width: 1.0,
            color:
                classesProvider.cours != cours
                    ? ColorConstantes.greyColor
                    : ColorConstantes.primaryColor,
          ), // Optional: Add a background color
        ),

        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              cours.designation,
              textAlign: TextAlign.center,
              style: TextStyle().copyWith(
                color:
                    classesProvider.cours != cours
                        ? ColorConstantes.blackColor
                        : ColorConstantes.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
