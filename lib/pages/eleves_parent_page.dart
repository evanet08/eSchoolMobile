import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/eleve_item.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/services/eleve_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';

class ElevesParent extends StatefulWidget {
  const ElevesParent({super.key});

  @override
  State<ElevesParent> createState() => _ElevesParentState();
}

class _ElevesParentState extends State<ElevesParent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(OtherConstantes.pagePadding),
        child: Column(
          children: [
            FutureBuilder<List<Eleve>>(
              future: EleveService.instance.fetchEleves(context),
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
                  List<Eleve>? eleves = snapshot.data;
                  if (eleves != null) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: eleves.length,
                        itemBuilder: (BuildContext context, index) {
                          Eleve eleve = eleves[index];
                          return EleveItem(eleve: eleve, onSlected: (index) {});
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
}
