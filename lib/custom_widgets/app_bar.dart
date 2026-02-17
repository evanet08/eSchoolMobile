import 'package:flutter/material.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:provider/provider.dart';
import '../models/language.dart';
import '../providers/language_provider.dart';
import 'my_text.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? color;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;
  final Function(dynamic)? onSelectAnnee;

  const MyAppBar({
    super.key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.color,
    this.bottom,
    this.onSelectAnnee,
  });

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthenticationProvider>(context);
    var languageProvider = Provider.of<LanguageProvider>(context);
    return AppBar(
      title: Text(
        "",
        style: TextStyle().copyWith(color: ColorConstantes.whiteColor),
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: color,
      bottom: bottom,
      actions: [
        auth.status == AuthenticationStatus.Authenticated
            ? Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: PopupMenuButton(
                itemBuilder:
                    (ctx) => <PopupMenuItem>[
                      PopupMenuItem(
                        onTap: () {},
                        value: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.person),
                            Expanded(
                              child: MyText(
                                text: AppLocalizations.of(context)!.my_profile,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap:
                            () => UtilisateurService.instance.logout(context),
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(Icons.login_outlined),
                            Expanded(
                              child: MyText(
                                text: AppLocalizations.of(context)!.logout,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                child: Row(
                  children: [
                    const Image(
                      image: AssetImage("assets/images/profile.png"),
                      height: 25.0,
                      width: 25.0,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      auth.utilisateur!.prenoms,
                      style: TextStyle().copyWith(
                        color: ColorConstantes.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: PopupMenuButton(
            itemBuilder:
                (ctx) =>
                    [
                          Language(
                            AppLocalizations.of(context)!.french,
                            "fr",
                            "assets/images/france.png",
                          ),
                          Language(
                            AppLocalizations.of(context)!.english,
                            "en",
                            "assets/images/angleterre.png",
                          ),
                          Language(
                            AppLocalizations.of(context)!.swahili,
                            "sw",
                            "assets/images/tanzanie.png",
                          ),
                          Language(
                            AppLocalizations.of(context)!.kirundi,
                            "es",
                            "assets/images/burundi.png",
                          ),
                          Language(
                            AppLocalizations.of(context)!.lingala,
                            "zh",
                            "assets/images/drc.png",
                          ),
                        ]
                        .map((e) => Helpers.buildPopupLanguageMenuItem(e))
                        .toList(),
            offset: const Offset(0.0, 100),
            onSelected: (data) {
              languageProvider.changeLanguage(context, data);
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: SizedBox(
              child: Row(
                children: [
                  Image(
                    image: AssetImage(languageProvider.language.imageSrc),
                    height: 20.0,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyle().copyWith(
                      color: ColorConstantes.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        AccountCreationProvider.instance.anneeScolaire != null
            ? PopupMenuButton(
              itemBuilder:
                  (ctx) =>
                      AccountCreationProvider.instance.annees
                          .map(
                            (an) =>
                                PopupMenuItem(value: an, child: Text(an.annee)),
                          )
                          .toList(),
              onSelected: onSelectAnnee,
              child: Text(
                AccountCreationProvider.instance.anneeScolaire!.annee,
                style: TextStyle().copyWith(color: ColorConstantes.whiteColor),
              ),
            )
            : const SizedBox(),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}
