
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/pages/parent_enfants_page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityDashboardPage extends StatefulWidget {
  final String userType;
  const ActivityDashboardPage({super.key, required this.userType});

  @override
  State<ActivityDashboardPage> createState() => _ActivityDashboardPageState();
}

class _ActivityDashboardPageState extends State<ActivityDashboardPage> {
  List<dynamic> activities = [];
  bool isLoading = true;

  // Minimal color scheme per user type
  Color get _accent {
    switch (widget.userType) {
      case 'Teacher':
        return const Color(0xFF6C63FF); // Soft indigo
      case 'Parent':
        return const Color(0xFF00B894); // Mint green
      case 'Administrative':
        return const Color(0xFFE17055); // Warm coral
      default:
        return const Color(0xFF6C63FF);
    }
  }

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
      debugPrint("Error fetching activities: $e");
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
    String label = _getLabel(item).toLowerCase();

    if (label.contains('présence')) return Icons.how_to_reg_outlined;
    if (label.contains('note')) return Icons.grade_outlined;
    if (label.contains('communication')) return Icons.chat_bubble_outline;
    if (label.contains('horaire') || label.contains('calendrier')) return Icons.calendar_month_outlined;
    if (label.contains('devoir')) return Icons.assignment_outlined;
    if (label.contains('examen')) return Icons.quiz_outlined;
    if (label.contains('bulletin')) return Icons.description_outlined;
    if (label.contains('discipline') || label.contains('conduite')) return Icons.gavel_outlined;
    if (label.contains('paiement') || label.contains('payment')) return Icons.payments_outlined;
    if (label.contains('comptable')) return Icons.account_balance_wallet_outlined;
    if (label.contains('directeur')) return Icons.manage_accounts_outlined;
    if (label.contains('superviseur') || label.contains('pédagogique')) return Icons.school_outlined;
    if (label.contains('secrétaire')) return Icons.edit_note_outlined;
    if (label.contains('préfet')) return Icons.admin_panel_settings_outlined;
    if (label.contains('proviseur')) return Icons.business_outlined;
    if (label.contains('intendant')) return Icons.inventory_outlined;
    if (label.contains('bibliothécaire')) return Icons.local_library_outlined;
    if (label.contains('animateur') || label.contains('culturel')) return Icons.palette_outlined;
    if (label.contains('menu') || label.contains('cantine')) return Icons.restaurant_outlined;
    if (label.contains('transport')) return Icons.directions_bus_outlined;
    if (label.contains('messagerie') || label.contains('chat')) return Icons.forum_outlined;
    if (label.contains('document')) return Icons.folder_outlined;
    if (label.contains('historique')) return Icons.receipt_long_outlined;
    if (label.contains('suivi')) return Icons.track_changes_outlined;
    return Icons.grid_view_outlined;
  }

  String _getUserTypeLabel() {
    switch (widget.userType) {
      case 'Teacher':
        return 'Enseignant';
      case 'Parent':
        return 'Parent';
      case 'Administrative':
        return 'Administratif';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthenticationProvider.instance.utilisateur;
    final userName = "${user?.noms ?? 'Utilisateur'} ${user?.prenoms ?? ''}".trim();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: SafeArea(
        child: Column(
          children: [
            // --- Top Bar ---
            _buildTopBar(userName),
            // --- Content ---
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: _accent,
                        strokeWidth: 2,
                      ),
                    )
                  : _buildGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(String userName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accent.withValues(alpha: 0.15),
              border: Border.all(color: _accent.withValues(alpha: 0.4), width: 1.5),
            ),
            child: Icon(Icons.person_outline, color: _accent, size: 18),
          ),
          const SizedBox(width: 10),
          // Name & Type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _getUserTypeLabel(),
                  style: GoogleFonts.inter(
                    color: _accent.withValues(alpha: 0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Logout
          GestureDetector(
            onTap: () => NavigationService.instance.navigateToReplacement('user_selection'),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withValues(alpha: 0.05),
              ),
              child: Icon(Icons.logout_rounded, color: Colors.white.withValues(alpha: 0.5), size: 16),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  void _handleActivityTap(dynamic item) {
    String label = _getLabel(item).toLowerCase();
    if (widget.userType == 'Parent') {
      if (label.contains('note') || label.contains('bulletin') || label.contains('suivi')) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentEnfantsPage()));
        return;
      }
      if (label.contains('enfant') || label.contains('élève')) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentEnfantsPage()));
        return;
      }
    }
    if (widget.userType == 'Teacher') {
      if (label.contains('note')) {
        NavigationService.instance.navigateTo('annees');
        return;
      }
    }
  }

  Widget _buildGrid() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section title
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 8, top: 4),
                child: Text(
                  "Tableau de bord",
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ).animate().fadeIn(delay: 150.ms),
              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return _HoverCard(
                      label: _getLabel(activities[index]),
                      icon: _getIcon(activities[index]),
                      accent: _accent,
                      index: index,
                      onTap: () => _handleActivityTap(activities[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Hover Card Widget (StatefulWidget for hover state) ---
class _HoverCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final int index;
  final VoidCallback onTap;

  const _HoverCard({
    required this.label,
    required this.icon,
    required this.accent,
    required this.index,
    required this.onTap,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _elevationAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _elevationAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnim.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color.lerp(
                    Colors.white.withValues(alpha: 0.04),
                    widget.accent.withValues(alpha: 0.12),
                    _elevationAnim.value,
                  ),
                  border: Border.all(
                    color: Color.lerp(
                      Colors.white.withValues(alpha: 0.07),
                      widget.accent.withValues(alpha: 0.35),
                      _elevationAnim.value,
                    )!,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accent.withValues(alpha: 0.12 * _elevationAnim.value),
                      blurRadius: 16 * _elevationAnim.value,
                      spreadRadius: 0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.lerp(
                          widget.accent.withValues(alpha: 0.08),
                          widget.accent.withValues(alpha: 0.18),
                          _elevationAnim.value,
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Color.lerp(
                          widget.accent.withValues(alpha: 0.65),
                          widget.accent,
                          _elevationAnim.value,
                        ),
                        size: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Label
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Color.lerp(
                            Colors.white.withValues(alpha: 0.55),
                            Colors.white.withValues(alpha: 0.95),
                            _elevationAnim.value,
                          ),
                          fontSize: 9.5,
                          fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(
      delay: (200 + widget.index * 50).ms,
      duration: 350.ms,
    ).slideY(
      begin: 0.1,
      delay: (200 + widget.index * 50).ms,
      duration: 350.ms,
      curve: Curves.easeOutCubic,
    );
  }
}
