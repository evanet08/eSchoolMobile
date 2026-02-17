import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/pages/conduites_enfants_parent_page.dart';
import 'package:eschoolmobile/pages/conduites_page.dart';
import 'package:eschoolmobile/pages/creneaux_enfants_parent_page.dart';
import 'package:eschoolmobile/pages/creneaux_page.dart';
import 'package:eschoolmobile/pages/eleves_page.dart';
import 'package:eschoolmobile/pages/notes_enfants_parent_page.dart';
import 'package:eschoolmobile/pages/notes_page.dart';
import 'package:eschoolmobile/pages/profile_page.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/pages/rapports_page.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:provider/provider.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AuthenticationProvider authenticationProvider;
  bool _isTabBarVisible = true;
  void _updateTabBarVisibility(bool isVisible) {
    setState(() {
      _isTabBarVisible = isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: MyAppBar(
        onSelectAnnee: (value) {
          setState(() {
            AccountCreationProvider.instance.anneeScolaire = value;
          });
          NavigationService.instance.navigateToReplacement("principal");
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _tabBarPages()),
          _isTabBarVisible ? _tabBar() : SizedBox(),
        ],
      ),
    );
  }

  PreferredSizeWidget _tabBar() {
    return TabBar(
      unselectedLabelColor: Colors.grey,
      controller: _tabController,
      tabs:
          AccountCreationProvider.instance.typeUser == "Teacher"
              ? [
                Tab(
                  icon: Icon(Icons.schedule, size: 23.0),
                  text: AppLocalizations.of(context)!.schedules,
                ),
                Tab(
                  icon: Icon(Icons.percent_outlined, size: 23.0),
                  text: AppLocalizations.of(context)!.grades,
                ),
                Tab(
                  icon: Icon(Icons.group, size: 23.0),
                  text: AppLocalizations.of(context)!.students,
                ),
                Tab(
                  icon: Icon(Icons.timeline_outlined, size: 23.0),
                  text: AppLocalizations.of(context)!.behaviors,
                ),
                Tab(
                  icon: Icon(Icons.person_outline, size: 23.0),
                  text: AppLocalizations.of(context)!.my_profile,
                ),
              ]
              : [
                Tab(
                  icon: Icon(Icons.schedule, size: 23.0),
                  text: AppLocalizations.of(context)!.schedules,
                ),
                Tab(
                  icon: Icon(Icons.percent_outlined, size: 23.0),
                  text: AppLocalizations.of(context)!.grades,
                ),
                Tab(
                  icon: Icon(Icons.timeline_outlined, size: 23.0),
                  text: AppLocalizations.of(context)!.behaviors,
                ),
                Tab(
                  icon: Icon(Icons.person_outline, size: 23.0),
                  text: "Rapport",
                ),
                Tab(
                  icon: Icon(Icons.person_outline, size: 23.0),
                  text: AppLocalizations.of(context)!.my_profile,
                ),
              ],
    );
  }

  Widget _tabBarPages() {
    return TabBarView(
      controller: _tabController,
      children:
          AccountCreationProvider.instance.typeUser == "Teacher"
              ? [Creneaux(), Notes(), Eleves(), Conduites(), Profile()]
              : [
                CreneauxEnfantsparent(onScroll: _updateTabBarVisibility),
                NotesEnfantsParent(onScroll: _updateTabBarVisibility),
                ConduitesEntantsParent(onScroll: _updateTabBarVisibility),
                RapportsPage(onScroll: _updateTabBarVisibility),
                Profile(),
              ],
    );
  }
}
