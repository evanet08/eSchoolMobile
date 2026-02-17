// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_name => 'MonEcole';

  @override
  String get authentication_msg =>
      'Ku bakozi b\'ishuri, banyeshuri n\'ababyeyi b\'abanyeshuri';

  @override
  String get authentication => 'Uthibitishaji';

  @override
  String get username => 'Jina la mtumiaji';

  @override
  String get password => 'Nenosiri';

  @override
  String get your_password => 'Mot de passe yanyu';

  @override
  String get create_account => 'Fungua akaunti';

  @override
  String get forgot_password => 'Nimesahau nenosiri';

  @override
  String get login => 'Ingia';

  @override
  String get remember_me => 'Nikumbuke';

  @override
  String get send_otp_msg =>
      'Nambari ya kuthibitisha itatumwa kwa nambari hii ya simu kwa hatua inayofuata';

  @override
  String get phone_number => 'Number ya simu ya mkononi';

  @override
  String get your_phone_number => 'Number ya simu yako ya mkononi';

  @override
  String get send_otp => 'Tuma nambari ya kuthibitisha';

  @override
  String get enter_phone_number_for_makin_account =>
      'Andika hapa chini nambari yako ya simu kwa akaunti yako';

  @override
  String get enter_phone_number_for_account_verification =>
      'Andika hapa chini nambari yako ya simu ili kuthibitisha akaunti yako';

  @override
  String get code_verification => 'Uthibitishaji wa msimbo';

  @override
  String get sending_otp_msg => 'Tumetuma uthibitishaji wa msimbo kwa ';

  @override
  String get ask_change_phone_number =>
      'Ungependa kubadilisha nambari ya simu?';

  @override
  String get resend_code_after => 'Tuma tena msimbo baada ya ';

  @override
  String get ask_code_not_received => 'Msimbo haujapokelewa?';

  @override
  String get resend => 'Tuma tena';

  @override
  String get english => 'Kingereza';

  @override
  String get french => 'Kifaransa';

  @override
  String get swahili => 'Kiswahili';

  @override
  String get kirundi => 'Kirundi';

  @override
  String get lingala => 'Lingala';

  @override
  String get user_identity => 'Utambulisho wa mtumiaji';

  @override
  String get name => 'Jina';

  @override
  String get your_name => 'Jina yako';

  @override
  String get lastname => 'Jina ya kwanza';

  @override
  String get your_lastname => 'Jina yako ya kwanza';

  @override
  String get place_birth => 'Mahali pakuzaliwa';

  @override
  String get your_place_birth => 'Mahali yako ya kuzaliwa';

  @override
  String get date_of_birth => 'Tariki ya kuzaliwa';

  @override
  String get send => 'Tuma';

  @override
  String get day => 'Siku';

  @override
  String get month => 'Mwezi';

  @override
  String get year => 'Mwaka';

  @override
  String get address => 'Anwani';

  @override
  String get country => 'Nchi';

  @override
  String get city => 'Jiji';

  @override
  String get state => 'Jimbo';

  @override
  String get id => 'Kitambulisho/Pasipoti';

  @override
  String get capture => 'Nasa';

  @override
  String get browse => 'Vinjari';

  @override
  String get profile_picture => 'Picha ya wasifu';

  @override
  String get new_password => 'Nenosiri mpya';

  @override
  String get your_new_password => 'Nenosiri mpya lako';

  @override
  String get conf_password => 'Uthibitishaji wa nenosiri';

  @override
  String get conf_new_password => 'Uthibitishaji wa nenosiri lako jipya';

  @override
  String get success => 'Mafanikio';

  @override
  String get account_username => 'Jina la mtumiaji ya akaunti';

  @override
  String get account_password => 'Nenosiri ya akaunti';

  @override
  String get menus => 'Menyu';

  @override
  String get powered_by => 'Inaendeshwa na ';

  @override
  String get reset_password_success_msg =>
      'Nenosiri lako limebadilishwa kwa mafanikio';

  @override
  String get picture => 'Picha';

  @override
  String get wait => 'Tafadhali subiri...';

  @override
  String get my_profile => 'Wasifu Wangu';

  @override
  String get logout => 'Toka nje';

  @override
  String get empty_email_alert => 'Tafadhali weka anwani yako ya barua pepe';

  @override
  String get invalid_email_alert =>
      'Tafadhali weka anwani halali ya barua pepe';

  @override
  String get empty_password_alert => 'Tafadhali weka nenosiri lako';

  @override
  String get success_login => 'Mafanikio ya kuingia';

  @override
  String get failed_login => 'Hitilafu ya Kuingia';

  @override
  String get language => 'Luga';

  @override
  String get empty_conf_password_alert => 'Tafadhali thibitisha nenosiri lako';

  @override
  String get all_classes => 'Amashure yose';

  @override
  String get save => 'Bika';

  @override
  String get logging_out_success => 'Umetoka nje kwa Mafanikio';

  @override
  String get error_logging_out => 'Hitilafu katika Kuondoka';

  @override
  String get excellent => 'Bora kabisa';

  @override
  String get optional => 'Hiari';

  @override
  String get comment => 'Maoni';

  @override
  String get your_comment => 'Maoni yako';

  @override
  String get research => 'Tafuta';

  @override
  String get phone => 'Simu';

  @override
  String get no_have_account => 'Nta nkonti mufise? :';

  @override
  String get email => 'E-mail';

  @override
  String get your_email => 'Adresse mail yanyu';

  @override
  String get all_courses => 'Amasomo yose';

  @override
  String enregistrement_note_title(Object classe, Object cours) {
    return 'Kwandika amanota y\'abanyeshuri muri $classe kuri $cours';
  }

  @override
  String get maximum => 'Maximum';

  @override
  String get schedules => 'Imikorero';

  @override
  String get schedule => 'Ikorero';

  @override
  String get grades => 'Amanoti';

  @override
  String get students => 'Abanyesheri';

  @override
  String get student => 'Munyeshuri';

  @override
  String get teacher => 'Mwigisha';

  @override
  String get parent => 'Umubyeyi';

  @override
  String get your_status => 'Uko ugaragara';

  @override
  String get behaviors => 'Ngeso';

  @override
  String get behavior => 'Ngeso';

  @override
  String get apply => 'Bika';

  @override
  String behavior_of(Object eleve) {
    return 'Ngeso ya $eleve';
  }

  @override
  String get ratings => 'Manota';

  @override
  String get rating => 'Amanota';

  @override
  String get select_item => 'Select item';

  @override
  String get father => 'Papa';

  @override
  String get mother => 'Maman';

  @override
  String get parents_contancts => 'Contancts parents';

  @override
  String get student_infos => 'Informations de l\'élève';

  @override
  String get all_students => 'Abanyeshuri bose';

  @override
  String get empty_user_status_alert => 'Nimenyeshe ico uri';

  @override
  String get logging_out => 'Kuvayo...';

  @override
  String get session_expired =>
      'Igihe cawe c\'ukwezi cararangiye. Nyabuna winjire ukundi';

  @override
  String get welcome_title => 'Murakaza neza MonEkole';

  @override
  String get welcome_subtitle => 'Gucunga ishure neza';

  @override
  String get who_are_you => 'Uri nde?';

  @override
  String get select_user_type => 'Hitamwo icuri';

  @override
  String get administrative => 'Umuyobozi';

  @override
  String get login_as_teacher => 'Kwinjira Mwigisha';

  @override
  String get login_as_parent => 'Kwinjira Umubyeyi';

  @override
  String get login_as_student => 'Kwinjira Munyeshuri';

  @override
  String get login_as_administrative => 'Kwinjira Umuyobozi';
}
