import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/api/firebase_api.dart';
import 'package:eschoolmobile/firebase_options.dart';
import 'package:eschoolmobile/pages/annees_scolaires_page.dart';
import 'package:eschoolmobile/pages/appels_page.dart';
import 'package:eschoolmobile/pages/check_phone_number_page.dart';
import 'package:eschoolmobile/pages/eleve_profile.dart';
import 'package:eschoolmobile/pages/enregistrement_notes.dart';
import 'package:eschoolmobile/pages/login_page.dart';
import 'package:eschoolmobile/pages/new_password_by_forgot_page.dart';
import 'package:eschoolmobile/pages/notes_evaluation.dart';
import 'package:eschoolmobile/pages/nouvelle_evaluation.dart';
import 'package:eschoolmobile/pages/otp_verification_page.dart';
import 'package:eschoolmobile/pages/presences_page.dart';
import 'package:eschoolmobile/pages/principal_page.dart';
import 'package:eschoolmobile/pages/success_page.dart';
import 'package:eschoolmobile/pages/user_selection_page.dart';
import 'package:eschoolmobile/pages/activity_dashboard_page.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/cours_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/providers/language_provider.dart';
import 'package:eschoolmobile/services/local_notification_service.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/utils/theme/my_theme.dart';
import 'package:provider/provider.dart';
import './services/snackbar_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await FirebaseApi().initNotifications();
  LocalNotificationService().initNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthenticationProvider.instance),
        ChangeNotifierProvider.value(value: ClassesProvider.instance),
        ChangeNotifierProvider.value(value: CoursProvider.instance),
        ChangeNotifierProvider.value(value: EleveProvider.instance),
        ChangeNotifierProvider.value(value: LanguageProvider.instance),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? locale;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: SnackBarService.instance.snackbarKey,
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      initialRoute: 'user_selection',
      routes: {
        'user_selection': (context) => const UserSelectionPage(),
        'login': (context) => const Login(),
        'principal': (context) => const Principal(),
        'annees': (context) => const AnneesScolairesPage(),
        'enregistrement_notes': (context) => const EnregistrementNotes(),
        'profile_eleve': (context) => const EleveProfile(),
        'check_phone_number': (context) => const CheckPhoneNumber(),
        'check_verification_code': (context) => const OTPVerification(),
        'success': (context) => const Success(),
        'new_password': (context) => const NewPasswordByForgot(),
        'new_evaluation': (context) => const NouvelleEvaluation(),
        'notes_evaluation': (context) => const NotesEvaluation(),
        'appel': (context) => const AppelsPage(),
        'presences': (context) => const PresencesPage(),
        'dashboard_teacher': (context) => const ActivityDashboardPage(userType: 'Teacher'),
        'dashboard_parent': (context) => const ActivityDashboardPage(userType: 'Parent'),
        'dashboard_admin': (context) => const ActivityDashboardPage(userType: 'Administrative'),
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale ?? const Locale('fr'),
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
        Locale('sw'),
        Locale('zh'),
        Locale('es'),
      ],
      home: const UserSelectionPage(),
    );
  }

  setLocale(Locale newlocale) {
    setState(() {
      locale = newlocale;
    });
  }
}
