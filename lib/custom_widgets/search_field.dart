import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class SearchField extends StatelessWidget {
  final Function(dynamic) onChange;
  const SearchField({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      onChanged: onChange,
      label: AppLocalizations.of(context)!.research,
      placeholder: AppLocalizations.of(context)!.research,
      width: MediaQuery.of(context).size.width,
      prefixIcon: Icon(Icons.search, size: IconSizeConstantes.medium),
    );
  }
}
