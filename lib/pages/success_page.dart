import 'package:flutter/material.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/custom_widgets/my_btn.dart';
import 'package:eschoolmobile/services/navigation_service.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    String message = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage("assets/images/success.gif"),
                      height: 150.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(AppLocalizations.of(context)!.success),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Text(message),
              ),
              MyButton(
                text: "Ok",
                width: MediaQuery.of(context).size.width,
                height: 40,
                fontSize: 13,
                textColor: Colors.white,
                onPressed: () {
                  NavigationService.instance.navigateToReplacement('');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
