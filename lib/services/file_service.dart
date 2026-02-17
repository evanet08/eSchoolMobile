import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/custom_widgets/loading_indicator_dialog.dart';
import 'package:eschoolmobile/services/snackbar_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:printing/printing.dart';

class FileService {
  static FileService instance = FileService();
  FileService();
  void downloadFile(BuildContext context, String fileName) async {
    if (context.mounted) {
      LoadingIndicatorDialog().show(
        context,
        text: AppLocalizations.of(context)!.wait,
      );
    }
    var url = Uri.parse(
      "${OtherConstantes.baseUrl}personnel/download_file/$fileName",
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File("${directory.path}/$fileName");
      await file.writeAsBytes(response.bodyBytes);
      if (context.mounted) {
        LoadingIndicatorDialog().dismiss();
      }
      if (fileName.split(".")[fileName.split(".").length - 1] == "pdf") {
        await Printing.layoutPdf(onLayout: (_) => file.readAsBytes());
      } else {
        if (context.mounted) {
          SnackBarService.instance.showSnackBarSuccess(
            "Fichier sauvegardé sur ${directory.path}/$fileName}",
          );
        }
      }
    } else {
      if (context.mounted) {
        LoadingIndicatorDialog().dismiss();
        dynamic data = jsonDecode(response.body);
        SnackBarService.instance.showSnackBarError(data['message']);
      }
    }
  }
}
