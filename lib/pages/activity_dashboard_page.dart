import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';

class ActivityDashboardPage extends StatefulWidget {
  final String userType;
  const ActivityDashboardPage({super.key, required this.userType});

  @override
  State<ActivityDashboardPage> createState() => _ActivityDashboardPageState();
}

class _ActivityDashboardPageState extends State<ActivityDashboardPage> {
  List<dynamic> activities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    String endpoint = "";
    switch (widget.userType) {
      case 'Teacher':
        endpoint = "teacher_tasks";
        break;
      case 'Parent':
        endpoint = "parent_operations";
        break;
      case 'Administrative':
        endpoint = "admin_postes";
        break;
      default:
        endpoint = "parent_operations";
    }

    try {
      final response = await http.get(
        Uri.parse("${OtherConstantes.baseUrl}$endpoint"),
        headers: {
          "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          activities = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching activities: $e");
      setState(() => isLoading = false);
    }
  }

  String _getLabel(dynamic item) {
    if (widget.userType == 'Teacher') return item['tache'] ?? '';
    if (widget.userType == 'Parent') return item['libelle_operation'] ?? '';
    if (widget.userType == 'Administrative') return item['poste'] ?? '';
    return '';
  }

  IconData _getIcon(dynamic item) {
    // Mapping icons based on labels or codes for variety
    String label = _getLabel(item).toLowerCase();
    
    if (label.contains('présence')) return Icons.how_to_reg_rounded;
    if (label.contains('note')) return Icons.grade_rounded;
    if (label.contains('communication')) return Icons.chat_bubble_rounded;
    if (label.contains('horaire') || label.contains('calendrier')) return Icons.calendar_month_rounded;
    if (label.contains('devoir')) return Icons.assignment_rounded;
    if (label.contains('examen')) return Icons.quiz_rounded;
    if (label.contains('bulletin')) return Icons.description_rounded;
    if (label.contains('discipline')) return Icons.gavel_rounded;
    if (label.contains('paiement')) return Icons.payments_rounded;
    if (label.contains('comptable')) return Icons.account_balance_wallet_rounded;
    if (label.contains('directeur')) return Icons.manage_accounts_rounded;
    if (label.contains('secrétaire')) return Icons.edit_note_rounded;
    if (label.contains('menu') || label.contains('cantine')) return Icons.restaurant_rounded;
    if (label.contains('transport')) return Icons.directions_bus_rounded;
    
    return Icons.grid_view_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final userColor = ColorConstantes.getColorForUserType(widget.userType);
    final user = AuthenticationProvider.instance.utilisateur;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorConstantes.primaryDark,
              userColor.withValues(alpha: 0.8),
              ColorConstantes.primaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(user, userColor),
              Expanded(
                child: _buildBody(userColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic user, Color userColor) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(Icons.person, color: Colors.white, size: 35),
          ).animate().scale(duration: 400.ms),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bonjour,",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
                ),
                Text(
                  "${user?.firstName ?? 'Utilisateur'} ${user?.lastName ?? ''}",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () => NavigationService.instance.navigateToReplacement('user_selection'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(Color userColor) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: isLoading 
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 16),
                    child: Text(
                      widget.userType == 'Parent' ? "Opérations disponibles" : "Mon Tableau de Bord",
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        return _buildActivityCard(activities[index], userColor, index);
                      },
                    ),
                  ),
                ],
              ),
        ),
      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildActivityCard(dynamic item, Color userColor, int index) {
    return GestureDetector(
      onTap: () {
        // Handle navigation based on activity
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: userColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(item), color: Colors.white, size: 30),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                _getLabel(item),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (400 + index * 50).ms).scale(begin: const Offset(0.9, 0.9));
  }
}
