import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eschoolmobile/services/parent_service.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/pages/parent_enfant_detail_page.dart';

class ParentEnfantsPage extends StatefulWidget {
  const ParentEnfantsPage({super.key});

  @override
  State<ParentEnfantsPage> createState() => _ParentEnfantsPageState();
}

class _ParentEnfantsPageState extends State<ParentEnfantsPage> {
  List<Map<String, dynamic>> enfants = [];
  bool isLoading = true;

  static const Color _accent = Color(0xFF00B894);
  static const Color _bg = Color(0xFF0F0F14);

  @override
  void initState() {
    super.initState();
    _loadEnfants();
  }

  Future<void> _loadEnfants() async {
    final data = await ParentService.instance.fetchEnfants(context);
    if (mounted) {
      setState(() {
        enfants = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthenticationProvider.instance.utilisateur;
    final userName =
        "${user?.noms ?? 'Parent'} ${user?.prenoms ?? ''}".trim();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(userName),
            const SizedBox(height: 4),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: _accent,
                        strokeWidth: 2,
                      ),
                    )
                  : enfants.isEmpty
                      ? Center(
                          child: Text(
                            "Aucun enfant trouvé",
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : _buildEnfantsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(String userName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withValues(alpha: 0.06),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white70, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mes Enfants",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  userName,
                  style: GoogleFonts.inter(
                    color: _accent.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildEnfantsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: enfants.length,
      itemBuilder: (context, index) {
        final enfant = enfants[index];
        return _EnfantCard(
          enfant: enfant,
          index: index,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ParentEnfantDetailPage(enfant: enfant),
              ),
            );
          },
        );
      },
    );
  }
}

class _EnfantCard extends StatelessWidget {
  final Map<String, dynamic> enfant;
  final int index;
  final VoidCallback onTap;

  const _EnfantCard({
    required this.enfant,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isGarcon = (enfant['genre'] ?? 'M') == 'M';
    final genderColor = isGarcon ? const Color(0xFF6C63FF) : const Color(0xFFFF6B9D);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: genderColor.withValues(alpha: 0.15),
                border: Border.all(
                  color: genderColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Icon(
                isGarcon ? Icons.boy_rounded : Icons.girl_rounded,
                color: genderColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${enfant['nom'] ?? ''} ${enfant['prenom'] ?? ''}",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _InfoChip(
                        label: enfant['classe'] ?? 'N/A',
                        color: const Color(0xFF00B894),
                      ),
                      const SizedBox(width: 6),
                      _InfoChip(
                        label: "${enfant['notes_count'] ?? 0} notes",
                        color: const Color(0xFF6C63FF),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.white30, size: 20),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (150 + index * 80).ms, duration: 400.ms)
        .slideX(begin: 0.1, delay: (150 + index * 80).ms);
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color.withValues(alpha: 0.12),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
