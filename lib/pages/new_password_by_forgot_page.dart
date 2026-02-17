import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/modern_card.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/custom_widgets/loading_indicator_dialog.dart';
import 'package:eschoolmobile/custom_widgets/my_btn.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/services/snackbar_service.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import '../models/language.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class NewPasswordByForgot extends StatefulWidget {
  const NewPasswordByForgot({super.key});

  @override
  State<NewPasswordByForgot> createState() => _NewPasswordByForgotState();
}

class _NewPasswordByForgotState extends State<NewPasswordByForgot> {
  late Language language = Language("Langue", "lg", "assets/globe.png");
  String _password = "", _confPassword = "";

  late GlobalKey<FormState> _formKey;

  _NewPasswordByForgotState() {
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorConstantes.primaryColor,
                  ColorConstantes.primaryLight,
                  ColorConstantes.backgroundGarden,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: Text(AppLocalizations.of(context)!.new_password, style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: const BackButton(color: Colors.white),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ModernCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.new_password,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstantes.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 25),
                              MyTextField(
                                label: AppLocalizations.of(context)!.new_password,
                                placeholder: AppLocalizations.of(context)!.your_new_password,
                                width: MediaQuery.of(context).size.width,
                                onSaved: (input) => _password = input,
                                textInputType: TextInputType.text,
                                passwordField: true,
                                onChanged: (input) => _password = input,
                              ),
                              const SizedBox(height: 15),
                              MyTextField(
                                label: AppLocalizations.of(context)!.conf_password,
                                placeholder: AppLocalizations.of(context)!.conf_new_password,
                                width: MediaQuery.of(context).size.width,
                                onSaved: (input) => _confPassword = input,
                                textInputType: TextInputType.text,
                                passwordField: true,
                                onChanged: (input) => _confPassword = input,
                              ),
                              const SizedBox(height: 30),
                              MyButton(
                                text: AppLocalizations.of(context)!.send,
                                width: MediaQuery.of(context).size.width,
                                height: 45.0,
                                borderRadius: 50.0,
                                fontSize: 16.0,
                                textColor: Colors.white,
                                buttonColor: ColorConstantes.primaryColor,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_password != _confPassword) {
                                      SnackBarService.instance.showSnackBarError(
                                        "Les mots de passe ne correspondent pas"
                                      );
                                      return;
                                    }
                                    _formKey.currentState!.save();
                                    UtilisateurService.instance.createCompteUser(
                                      context,
                                      _password,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
