import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/modern_card.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/custom_widgets/my_btn.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import '../models/language.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class CheckPhoneNumber extends StatefulWidget {
  const CheckPhoneNumber({super.key});

  @override
  State<CheckPhoneNumber> createState() => _CheckPhoneNumberState();
}

class _CheckPhoneNumberState extends State<CheckPhoneNumber> {
  late Language language = Language("Langue", "lg", "assets/globe.png");
  String _phoneNumber = "";

  late GlobalKey<FormState> _formKey;

  _CheckPhoneNumberState() {
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    String task = ModalRoute.of(context)!.settings.arguments as String;
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
                  title: Text(AppLocalizations.of(context)!.phone_number, style: const TextStyle(color: Colors.white)),
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
                              const Icon(Icons.phone_android, size: 50, color: ColorConstantes.primaryColor),
                              const SizedBox(height: 15),
                              Text(
                                task == OtherConstantes.creatingAccount
                                    ? AppLocalizations.of(context)!.enter_phone_number_for_makin_account
                                    : AppLocalizations.of(context)!.enter_phone_number_for_account_verification,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 25),
                              MyTextField(
                                label: AppLocalizations.of(context)!.phone_number,
                                placeholder: AppLocalizations.of(context)!.your_phone_number,
                                width: MediaQuery.of(context).size.width,
                                textInputType: TextInputType.phone,
                                onChanged: (input) => _phoneNumber = input,
                                onSaved: (input) => _phoneNumber = input,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                AppLocalizations.of(context)!.send_otp_msg,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: ColorConstantes.greyColor, fontSize: 13),
                              ),
                              const SizedBox(height: 25),
                              MyButton(
                                text: AppLocalizations.of(context)!.send_otp,
                                width: MediaQuery.of(context).size.width,
                                height: 45.0,
                                borderRadius: 50.0,
                                fontSize: 16.0,
                                textColor: Colors.white,
                                buttonColor: ColorConstantes.primaryColor,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    UtilisateurService.instance.verificationUtilisateur(
                                      context,
                                      _phoneNumber,
                                      AccountCreationProvider.instance.typeUser!,
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
