import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class EleveProfile extends StatefulWidget {
  const EleveProfile({super.key});

  @override
  State<EleveProfile> createState() => _EleveProfileState();
}

class _EleveProfileState extends State<EleveProfile> {
  late Eleve eleve;
  @override
  Widget build(BuildContext context) {
    eleve = ModalRoute.of(context)!.settings.arguments as Eleve;
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context)!.student_infos),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: [_photoAndNamesUI(), _detailsUI()]),
      ),
    );
  }

  Widget _photoAndNamesUI() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/profile.png", width: 60.0, height: 60.0),
          Text("${eleve.noms} ${eleve.prenom}"),
          Text("(${eleve.classe.designation})"),
        ],
      ),
    );
  }

  Widget _detailsUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.name),
              Text(eleve.noms),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.lastname),
              Text(eleve.prenom),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.father),
              Text("${eleve.papa!.noms} ${eleve.papa!.prenoms}"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.mother),
              Text("${eleve.maman!.noms} ${eleve.maman!.prenoms}"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: PopupMenuButton(
            itemBuilder:
                (BuildContext context) => <PopupMenuItem>[
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.green,
                          size: IconSizeConstantes.small,
                        ),
                        SizedBox(width: 10.0),
                        Text(eleve.papa!.telephone),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.green,
                          size: IconSizeConstantes.small,
                        ),
                        SizedBox(width: 10.0),
                        Text(eleve.maman!.telephone),
                      ],
                    ),
                  ),
                ],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.parents_contancts),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.green,
                      size: IconSizeConstantes.small,
                    ),
                    SizedBox(width: 10.0),
                    Text("${eleve.papa!.telephone}, ${eleve.maman!.telephone}"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
