import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('sw'),
    Locale('zh'),
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'MonEcole'**
  String get app_name;

  /// No description provided for @authentication_msg.
  ///
  /// In en, this message translates to:
  /// **'For school staff, students and parents of students'**
  String get authentication_msg;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @your_password.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get your_password;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create my account'**
  String get create_account;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgot_password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// No description provided for @send_otp_msg.
  ///
  /// In en, this message translates to:
  /// **'A validation code will be send to this phone number for the next step'**
  String get send_otp_msg;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Your phone number'**
  String get your_phone_number;

  /// No description provided for @send_otp.
  ///
  /// In en, this message translates to:
  /// **'Send the code'**
  String get send_otp;

  /// No description provided for @enter_phone_number_for_makin_account.
  ///
  /// In en, this message translates to:
  /// **'Enter below your phone number for your account'**
  String get enter_phone_number_for_makin_account;

  /// No description provided for @enter_phone_number_for_account_verification.
  ///
  /// In en, this message translates to:
  /// **'Enter below your phone number to verify your account'**
  String get enter_phone_number_for_account_verification;

  /// No description provided for @code_verification.
  ///
  /// In en, this message translates to:
  /// **'Code verification'**
  String get code_verification;

  /// No description provided for @sending_otp_msg.
  ///
  /// In en, this message translates to:
  /// **'We have sent the code verification to'**
  String get sending_otp_msg;

  /// No description provided for @ask_change_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Change phone number?'**
  String get ask_change_phone_number;

  /// No description provided for @resend_code_after.
  ///
  /// In en, this message translates to:
  /// **'Resend code after'**
  String get resend_code_after;

  /// No description provided for @ask_code_not_received.
  ///
  /// In en, this message translates to:
  /// **'Code not received?'**
  String get ask_code_not_received;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @swahili.
  ///
  /// In en, this message translates to:
  /// **'Swahili'**
  String get swahili;

  /// No description provided for @kirundi.
  ///
  /// In en, this message translates to:
  /// **'Kirundi'**
  String get kirundi;

  /// No description provided for @lingala.
  ///
  /// In en, this message translates to:
  /// **'Lingala'**
  String get lingala;

  /// No description provided for @user_identity.
  ///
  /// In en, this message translates to:
  /// **'User identity'**
  String get user_identity;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @your_name.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get your_name;

  /// No description provided for @lastname.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastname;

  /// No description provided for @your_lastname.
  ///
  /// In en, this message translates to:
  /// **'Your last name'**
  String get your_lastname;

  /// No description provided for @place_birth.
  ///
  /// In en, this message translates to:
  /// **'Place of birth'**
  String get place_birth;

  /// No description provided for @your_place_birth.
  ///
  /// In en, this message translates to:
  /// **'Your place of birth'**
  String get your_place_birth;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get date_of_birth;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get send;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'Identity card/Passport'**
  String get id;

  /// No description provided for @capture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @profile_picture.
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get profile_picture;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @your_new_password.
  ///
  /// In en, this message translates to:
  /// **'Your new password'**
  String get your_new_password;

  /// No description provided for @conf_password.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation'**
  String get conf_password;

  /// No description provided for @conf_new_password.
  ///
  /// In en, this message translates to:
  /// **'Your new password confirmation'**
  String get conf_new_password;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @account_username.
  ///
  /// In en, this message translates to:
  /// **'Account username'**
  String get account_username;

  /// No description provided for @account_password.
  ///
  /// In en, this message translates to:
  /// **'Account password'**
  String get account_password;

  /// No description provided for @menus.
  ///
  /// In en, this message translates to:
  /// **'Menus'**
  String get menus;

  /// No description provided for @powered_by.
  ///
  /// In en, this message translates to:
  /// **'Powered by '**
  String get powered_by;

  /// No description provided for @reset_password_success_msg.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully'**
  String get reset_password_success_msg;

  /// No description provided for @picture.
  ///
  /// In en, this message translates to:
  /// **'Picture'**
  String get picture;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get wait;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @empty_email_alert.
  ///
  /// In en, this message translates to:
  /// **'Please enter your e-mail address'**
  String get empty_email_alert;

  /// No description provided for @invalid_email_alert.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid e-mail address'**
  String get invalid_email_alert;

  /// No description provided for @empty_password_alert.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get empty_password_alert;

  /// No description provided for @success_login.
  ///
  /// In en, this message translates to:
  /// **'Login success'**
  String get success_login;

  /// No description provided for @failed_login.
  ///
  /// In en, this message translates to:
  /// **'Login Error. Please verify your credentials'**
  String get failed_login;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @empty_conf_password_alert.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get empty_conf_password_alert;

  /// No description provided for @all_classes.
  ///
  /// In en, this message translates to:
  /// **'My all classes'**
  String get all_classes;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @logging_out_success.
  ///
  /// In en, this message translates to:
  /// **'Logged Out Successfully'**
  String get logging_out_success;

  /// No description provided for @error_logging_out.
  ///
  /// In en, this message translates to:
  /// **'Error Logging Out'**
  String get error_logging_out;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @your_comment.
  ///
  /// In en, this message translates to:
  /// **'Your comment'**
  String get your_comment;

  /// No description provided for @research.
  ///
  /// In en, this message translates to:
  /// **'Research'**
  String get research;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @no_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t you have an account? :'**
  String get no_have_account;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @your_email.
  ///
  /// In en, this message translates to:
  /// **'Your e-mail address'**
  String get your_email;

  /// No description provided for @all_courses.
  ///
  /// In en, this message translates to:
  /// **'My all courses'**
  String get all_courses;

  /// No description provided for @enregistrement_note_title.
  ///
  /// In en, this message translates to:
  /// **'Recording of students\'s notes in {classe} class on {cours} course'**
  String enregistrement_note_title(Object classe, Object cours);

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @grades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get grades;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @your_status.
  ///
  /// In en, this message translates to:
  /// **'Your status'**
  String get your_status;

  /// No description provided for @behaviors.
  ///
  /// In en, this message translates to:
  /// **'Behaviors'**
  String get behaviors;

  /// No description provided for @behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get behavior;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @behavior_of.
  ///
  /// In en, this message translates to:
  /// **'Behavior of {eleve}'**
  String behavior_of(Object eleve);

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @select_item.
  ///
  /// In en, this message translates to:
  /// **'Select item'**
  String get select_item;

  /// No description provided for @father.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get father;

  /// No description provided for @mother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get mother;

  /// No description provided for @parents_contancts.
  ///
  /// In en, this message translates to:
  /// **'Parents contacts'**
  String get parents_contancts;

  /// No description provided for @student_infos.
  ///
  /// In en, this message translates to:
  /// **'Student infos'**
  String get student_infos;

  /// No description provided for @all_students.
  ///
  /// In en, this message translates to:
  /// **'All students'**
  String get all_students;

  /// No description provided for @empty_user_status_alert.
  ///
  /// In en, this message translates to:
  /// **'Please specify your user status'**
  String get empty_user_status_alert;

  /// No description provided for @logging_out.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get logging_out;

  /// No description provided for @session_expired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again'**
  String get session_expired;

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MonEkole'**
  String get welcome_title;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart school management'**
  String get welcome_subtitle;

  /// No description provided for @who_are_you.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get who_are_you;

  /// No description provided for @select_user_type.
  ///
  /// In en, this message translates to:
  /// **'Select your profile to continue'**
  String get select_user_type;

  /// No description provided for @administrative.
  ///
  /// In en, this message translates to:
  /// **'Administrative'**
  String get administrative;

  /// No description provided for @login_as_teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher Login'**
  String get login_as_teacher;

  /// No description provided for @login_as_parent.
  ///
  /// In en, this message translates to:
  /// **'Parent Login'**
  String get login_as_parent;

  /// No description provided for @login_as_student.
  ///
  /// In en, this message translates to:
  /// **'Student Login'**
  String get login_as_student;

  /// No description provided for @login_as_administrative.
  ///
  /// In en, this message translates to:
  /// **'Admin Login'**
  String get login_as_administrative;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'sw', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'sw':
      return AppLocalizationsSw();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
