import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/custom_widgets/appel_item.dart';
import 'package:eschoolmobile/custom_widgets/my_text.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/appel.dart';
import 'package:eschoolmobile/models/creneau.dart';
import 'package:eschoolmobile/services/presence_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';

class AppelsPage extends StatefulWidget {
  const AppelsPage({super.key});

  @override
  State<AppelsPage> createState() => _AppelsPageState();
}

class _AppelsPageState extends State<AppelsPage> {
  Future<List<Appel>>? appels;
  bool show = false;
  bool allChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Creneau creneau = ModalRoute.of(context)!.settings.arguments as Creneau;
    appels ??= PresenceService.instance.fetchAppels(creneau);
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.all(OtherConstantes.pagePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MyText(
              text:
                  "Appel des présences au cours de ${creneau.cours} en ${creneau.classe} le ${creneau.jour} de ${creneau.heureDebut} à ${creneau.heureFin}",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: MyTextField(
                label: "Rechecrhe",
                placeholder: "Recherche",
                width: MediaQuery.of(context).size.width,
              ),
            ),
            show
                ? Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      appels!.then((apps) async {
                        int status = await PresenceService.instance
                            .enregistrerPresences(context, apps);
                        if (status == 201) {
                          appels!.then((apps) {
                            for (var app in apps) {
                              app.estPresent = false;
                            }
                            setState(() {
                              appels = appels;
                              show = false;
                              allChecked = false;
                            });
                          });
                        }
                      });
                    },
                    child: Image.asset(
                      "assets/images/diskette.png",
                      height: 20,
                      width: 20,
                      color: Colors.blue,
                    ),
                  ),
                )
                : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyText(
                  text: allChecked ? 'Tout décocher' : 'Tout cocher',
                  color: Colors.green,
                ),
                Checkbox(
                  value: allChecked,
                  onChanged: (check) {
                    appels!.then((apps) {
                      for (var app in apps) {
                        app.estPresent = check!;
                      }
                      setState(() {
                        appels = appels;
                        show = check!;
                        allChecked = check;
                      });
                    });
                  },
                ),
              ],
            ),
            FutureBuilder<List<Appel>>(
              future: appels,
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
                  List<Appel>? appels = snapshot.data;
                  if (appels != null) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: appels.length,
                        itemBuilder: (BuildContext context, index) {
                          Appel appel = appels[index];
                          return AppelItem(
                            appel: appel,
                            onChanged: (checked) {
                              setState(() {
                                appel.estPresent = checked!;
                                appel.dateAppel = Helpers.convertDateToString(
                                  DateTime.now(),
                                  'dd/MM/YYYY',
                                );
                              });
                              checkPresences();
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text("hahaha"));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void checkPresences() {
    bool ok = false;
    appels!.then((apps) {
      for (var app in apps) {
        if (app.estPresent) {
          ok = true;
        } else {
          allChecked = false;
        }
      }
      if (ok) {
        setState(() {
          show = true;
        });
      } else {
        show = false;
      }
    });
  }
}
