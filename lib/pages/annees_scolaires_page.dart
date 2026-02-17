import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/annee.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/classe_service.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';

class AnneesScolairesPage extends StatefulWidget {
  const AnneesScolairesPage({super.key});

  @override
  State<AnneesScolairesPage> createState() => _AnneesScolairesPageState();
}

class _AnneesScolairesPageState extends State<AnneesScolairesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Années scolaires",
        color: ColorConstantes.primaryColorDark,
      ),
      body: Center(
        child: FutureBuilder<List<Annee>>(
          future: ClasseService.instance.fetchAnneesScolaires(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CircularProgressIndicator(),
                ),
              ); // Loading state
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              ); // Error state
            } else {
              List<Annee>? annees = snapshot.data;
              if (annees != null) {
                return _anneesListView(annees);
              } else {
                return Center(child: Text("hahaha"));
              }
            }
          },
        ),
      ),
    );
  }

  Widget _anneesListView(List<Annee> annees) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.builder(
        itemCount: annees.length,
        itemBuilder: (BuildContext context, index) {
          var annee = annees[index];
          return InkWell(
            onTap: () async {
              AccountCreationProvider.instance.anneeScolaire = annee;
              await EleveProvider.instance.getEleves(context);
              await ClassesProvider.instance.getClassesAndCourses(context);
              NavigationService.instance.navigateToReplacement("principal");
            },
            child: Card(
              color: Colors.white,
              child: SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/chat.png",
                            height: 40,
                            width: 40,
                          ),
                          Text(annee.annee),
                          Text(
                            annee.etatAnnee,
                            style: TextStyle(
                              color:
                                  annee.etatAnnee == 'Cloturée'
                                      ? Colors.red
                                      : annee.etatAnnee == 'En Cours'
                                      ? Colors.blue
                                      : Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ouverture: ${Helpers.convertEndateToFrdate(annee.dateOuverture)}",
                            ),
                            Text(
                              "Clôture: ${Helpers.convertEndateToFrdate(annee.dateCloture)}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
