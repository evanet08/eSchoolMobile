import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/modern_card.dart';
import 'package:flutter/services.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import '../models/language.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({super.key});

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  late Language language = Language("Langue", "lg", "assets/globe.png");
  String digit1 = "";
  String digit2 = "";
  String digit3 = "";
  String digit4 = "";

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
                  title: Text(AppLocalizations.of(context)!.code_verification, style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: const BackButton(color: Colors.white),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ModernCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.code_verification,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorConstantes.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!.sending_otp_msg,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: ColorConstantes.greyColor),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AccountCreationProvider.instance.phoneNumber!,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () => NavigationService.instance.navigateToReplacement("check_phone_number"),
                                  child: Text(
                                    AppLocalizations.of(context)!.ask_change_phone_number,
                                    style: const TextStyle(color: ColorConstantes.primaryColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildOTPField(context, (v) { digit1 = v; FocusScope.of(context).nextFocus(); }, autofocus: true),
                                _buildOTPField(context, (v) { digit2 = v; FocusScope.of(context).nextFocus(); }),
                                _buildOTPField(context, (v) { digit3 = v; FocusScope.of(context).nextFocus(); }),
                                _buildOTPField(context, (v) { 
                                  digit4 = v; 
                                  String code = "$digit1$digit2$digit3$digit4";
                                  UtilisateurService.instance.verificationCodeSecret(context, code);
                                }),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.resend_code_after, style: const TextStyle(fontSize: 13)),
                                const SizedBox(width: 5),
                                const Text("20s", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.ask_code_not_received, style: const TextStyle(fontSize: 13)),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () => UtilisateurService.instance.verificationUtilisateur(
                                    context,
                                    AccountCreationProvider.instance.phoneNumber!,
                                    AccountCreationProvider.instance.typeUser!,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.resend,
                                    style: const TextStyle(color: ColorConstantes.primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  Widget _buildOTPField(BuildContext context, Function(String) onChanged, {bool autofocus = false}) {
    return SizedBox(
      width: 55,
      child: TextFormField(
        onChanged: (v) { if (v.length == 1) onChanged(v); },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        autofocus: autofocus,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
