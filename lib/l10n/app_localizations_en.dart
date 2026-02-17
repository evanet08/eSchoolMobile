// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'MonEcole';

  @override
  String get authentication_msg =>
      'For school staff, students and parents of students';

  @override
  String get authentication => 'Authentication';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get your_password => 'Your password';

  @override
  String get create_account => 'Create my account';

  @override
  String get forgot_password => 'Forgot password';

  @override
  String get login => 'Login';

  @override
  String get remember_me => 'Remember me';

  @override
  String get send_otp_msg =>
      'A validation code will be send to this phone number for the next step';

  @override
  String get phone_number => 'Phone number';

  @override
  String get your_phone_number => 'Your phone number';

  @override
  String get send_otp => 'Send the code';

  @override
  String get enter_phone_number_for_makin_account =>
      'Enter below your phone number for your account';

  @override
  String get enter_phone_number_for_account_verification =>
      'Enter below your phone number to verify your account';

  @override
  String get code_verification => 'Code verification';

  @override
  String get sending_otp_msg => 'We have sent the code verification to';

  @override
  String get ask_change_phone_number => 'Change phone number?';

  @override
  String get resend_code_after => 'Resend code after';

  @override
  String get ask_code_not_received => 'Code not received?';

  @override
  String get resend => 'Resend';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get swahili => 'Swahili';

  @override
  String get kirundi => 'Kirundi';

  @override
  String get lingala => 'Lingala';

  @override
  String get user_identity => 'User identity';

  @override
  String get name => 'Name';

  @override
  String get your_name => 'Your name';

  @override
  String get lastname => 'Last name';

  @override
  String get your_lastname => 'Your last name';

  @override
  String get place_birth => 'Place of birth';

  @override
  String get your_place_birth => 'Your place of birth';

  @override
  String get date_of_birth => 'Date of birth';

  @override
  String get send => 'Submit';

  @override
  String get day => 'Day';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get address => 'Address';

  @override
  String get country => 'Country';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get id => 'Identity card/Passport';

  @override
  String get capture => 'Capture';

  @override
  String get browse => 'Browse';

  @override
  String get profile_picture => 'Profile picture';

  @override
  String get new_password => 'New password';

  @override
  String get your_new_password => 'Your new password';

  @override
  String get conf_password => 'Password confirmation';

  @override
  String get conf_new_password => 'Your new password confirmation';

  @override
  String get success => 'Success';

  @override
  String get account_username => 'Account username';

  @override
  String get account_password => 'Account password';

  @override
  String get menus => 'Menus';

  @override
  String get powered_by => 'Powered by ';

  @override
  String get reset_password_success_msg =>
      'Your password has been changed successfully';

  @override
  String get picture => 'Picture';

  @override
  String get wait => 'Please wait...';

  @override
  String get my_profile => 'My Profile';

  @override
  String get logout => 'Log out';

  @override
  String get empty_email_alert => 'Please enter your e-mail address';

  @override
  String get invalid_email_alert => 'Please enter a valid e-mail address';

  @override
  String get empty_password_alert => 'Please enter your password';

  @override
  String get success_login => 'Login success';

  @override
  String get failed_login => 'Login Error. Please verify your credentials';

  @override
  String get language => 'Language';

  @override
  String get empty_conf_password_alert => 'Please confirm your password';

  @override
  String get all_classes => 'My all classes';

  @override
  String get save => 'Save';

  @override
  String get logging_out_success => 'Logged Out Successfully';

  @override
  String get error_logging_out => 'Error Logging Out';

  @override
  String get excellent => 'Excellent';

  @override
  String get optional => 'Optional';

  @override
  String get comment => 'Comment';

  @override
  String get your_comment => 'Your comment';

  @override
  String get research => 'Research';

  @override
  String get phone => 'Phone';

  @override
  String get no_have_account => 'Don\'t you have an account? :';

  @override
  String get email => 'E-mail';

  @override
  String get your_email => 'Your e-mail address';

  @override
  String get all_courses => 'My all courses';

  @override
  String enregistrement_note_title(Object classe, Object cours) {
    return 'Recording of students\'s notes in $classe class on $cours course';
  }

  @override
  String get maximum => 'Maximum';

  @override
  String get schedules => 'Schedules';

  @override
  String get schedule => 'Schedule';

  @override
  String get grades => 'Grades';

  @override
  String get students => 'Students';

  @override
  String get student => 'Student';

  @override
  String get teacher => 'Teacher';

  @override
  String get parent => 'Parent';

  @override
  String get your_status => 'Your status';

  @override
  String get behaviors => 'Behaviors';

  @override
  String get behavior => 'Behavior';

  @override
  String get apply => 'Apply';

  @override
  String behavior_of(Object eleve) {
    return 'Behavior of $eleve';
  }

  @override
  String get ratings => 'Ratings';

  @override
  String get rating => 'Rating';

  @override
  String get select_item => 'Select item';

  @override
  String get father => 'Father';

  @override
  String get mother => 'Mother';

  @override
  String get parents_contancts => 'Parents contacts';

  @override
  String get student_infos => 'Student infos';

  @override
  String get all_students => 'All students';

  @override
  String get empty_user_status_alert => 'Please specify your user status';

  @override
  String get logging_out => 'Logging out...';

  @override
  String get session_expired => 'Your session has expired. Please log in again';

  @override
  String get welcome_title => 'Welcome to MonEkole';

  @override
  String get welcome_subtitle => 'Smart school management';

  @override
  String get who_are_you => 'Who are you?';

  @override
  String get select_user_type => 'Select your profile to continue';

  @override
  String get administrative => 'Administrative';

  @override
  String get login_as_teacher => 'Teacher Login';

  @override
  String get login_as_parent => 'Parent Login';

  @override
  String get login_as_student => 'Student Login';

  @override
  String get login_as_administrative => 'Admin Login';
}
