import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eschoolmobile/services/parent_service.dart';

class ParentEnfantDetailPage extends StatefulWidget {
  final Map<String, dynamic> enfant;

  const ParentEnfantDetailPage({super.key, required this.enfant});

  @override
  State<ParentEnfantDetailPage> createState() => _ParentEnfantDetailPageState();
}

class _ParentEnfantDetailPageState extends State<ParentEnfantDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> evaluations = [];
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> cours = [];
  Map<String, dynamic>? bulletin;

  bool loadingEvals = true;
  bool loadingNotes = true;
  bool loadingCours = true;
  bool loadingBulletin = true;

  static const Color _accent = Color(0xFF00B894);
  static const Color _bg = Color(0xFF0F0F14);
  static const Color _card = Color(0xFF1A1A24);

  int get _idEleve => widget.enfant['id_eleve'] ?? 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    _loadEvals();
    _loadNotes();
    _loadCours();
    _loadBulletin();
  }

  Future<void> _loadEvals() async {
    final data =
        await ParentService.instance.fetchEnfantEvaluations(context, _idEleve);
    if (mounted) setState(() { evaluations = data; loadingEvals = false; });
  }

  Future<void> _loadNotes() async {
    final data =
        await ParentService.instance.fetchEnfantNotes(context, _idEleve);
    if (mounted) setState(() { notes = data; loadingNotes = false; });
  }

  Future<void> _loadCours() async {
    final data =
        await ParentService.instance.fetchEnfantCours(context, _idEleve);
    if (mounted) setState(() { cours = data; loadingCours = false; });
  }

  Future<void> _loadBulletin() async {
    final data =
        await ParentService.instance.fetchEnfantBulletin(context, _idEleve);
    if (mounted) setState(() { bulletin = data; loadingBulletin = false; });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGarcon = (widget.enfant['genre'] ?? 'M') == 'M';
    final genderColor =
        isGarcon ? const Color(0xFF6C63FF) : const Color(0xFFFF6B9D);
    final nom =
        "${widget.enfant['nom'] ?? ''} ${widget.enfant['prenom'] ?? ''}";

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(nom, genderColor, isGarcon),
            // Compact Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withValues(alpha: 0.04),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                labelPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _accent.withValues(alpha: 0.2),
                ),
                dividerColor: Colors.transparent,
                labelColor: _accent,
                unselectedLabelColor: Colors.white38,
                labelStyle: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(height: 32, text: "Évaluations"),
                  Tab(height: 32, text: "Notes"),
                  Tab(height: 32, text: "Cours"),
                  Tab(height: 32, text: "Bulletin"),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEvaluationsTab(),
                  _buildNotesTab(),
                  _buildCoursTab(),
                  _buildBulletinTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String nom, Color genderColor, bool isGarcon) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
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
                  color: Colors.white70, size: 14),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: genderColor.withValues(alpha: 0.15),
            ),
            child: Icon(
              isGarcon ? Icons.boy_rounded : Icons.girl_rounded,
              color: genderColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nom,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    _MiniChip(
                      label: widget.enfant['classe'] ?? 'N/A',
                      color: _accent,
                    ),
                    const SizedBox(width: 4),
                    _MiniChip(
                      label: widget.enfant['annee'] ?? '',
                      color: const Color(0xFFFF6B6B),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }

  // ===========================
  // EVALUATIONS TAB
  // ===========================
  Widget _buildEvaluationsTab() {
    if (loadingEvals) return _loader();
    if (evaluations.isEmpty) return _emptyState("Aucune évaluation");

    // Group by course
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var ev in evaluations) {
      final cours = ev['cours'] ?? 'Autre';
      grouped.putIfAbsent(cours, () => []);
      grouped[cours]!.add(ev);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      children: grouped.entries.map((entry) {
        return _CoursEvalSection(
          coursName: entry.key,
          evaluations: entry.value,
          accent: _accent,
        );
      }).toList(),
    );
  }

  // ===========================
  // NOTES TAB
  // ===========================
  Widget _buildNotesTab() {
    if (loadingNotes) return _loader();
    if (notes.isEmpty) return _emptyState("Aucune note");

    // Group by course
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var n in notes) {
      final cours = n['cours'] ?? 'Autre';
      grouped.putIfAbsent(cours, () => []);
      grouped[cours]!.add(n);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      children: grouped.entries.map((entry) {
        return _CoursNotesSection(
          coursName: entry.key,
          notes: entry.value,
        );
      }).toList(),
    );
  }

  // ===========================
  // COURS TAB
  // ===========================
  Widget _buildCoursTab() {
    if (loadingCours) return _loader();
    if (cours.isEmpty) return _emptyState("Aucun cours");

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: cours.length,
      itemBuilder: (context, index) {
        final c = cours[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _card,
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accent.withValues(alpha: 0.12),
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: GoogleFonts.inter(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  c['cours'] ?? '',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                ),
                child: Text(
                  "/${c['ponderation'] ?? 0}",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6C63FF),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: (index * 60).ms, duration: 350.ms)
            .slideX(begin: 0.05);
      },
    );
  }

  // ===========================
  // BULLETIN TAB
  // ===========================
  Widget _buildBulletinTab() {
    if (loadingBulletin) return _loader();
    if (bulletin == null) return _emptyState("Bulletin non disponible");

    final moyenne = (bulletin!['moyenne_generale'] ?? 0).toDouble();
    final mention = bulletin!['mention'] ?? '';
    final coursList =
        List<Map<String, dynamic>>.from(bulletin!['cours'] ?? []);
    final delib = bulletin!['deliberation'] ?? {};

    final moyenneColor = moyenne >= 50
        ? _accent
        : moyenne >= 40
            ? const Color(0xFFFFA726)
            : const Color(0xFFFF6B6B);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      children: [
        // Moyenne card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                moyenneColor.withValues(alpha: 0.15),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: moyenneColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              // Circular gauge
              SizedBox(
                width: 54,
                height: 54,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: CircularProgressIndicator(
                        value: (moyenne / 100).clamp(0, 1),
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(moyenneColor),
                        strokeWidth: 4,
                      ),
                    ),
                    Text(
                      "${moyenne.toStringAsFixed(1)}%",
                      style: GoogleFonts.inter(
                        color: moyenneColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Moyenne Générale",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (mention.isNotEmpty)
                      Text(
                        mention,
                        style: GoogleFonts.inter(
                          color: moyenneColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _MiniChip(
                          label:
                              "${bulletin!['total_notes'] ?? 0} notes",
                          color: const Color(0xFF6C63FF),
                        ),
                        const SizedBox(width: 4),
                        _MiniChip(
                          label:
                              "${bulletin!['total_cours'] ?? 0} cours",
                          color: _accent,
                        ),
                        const SizedBox(width: 4),
                        if (delib['existe'] == true)
                          _MiniChip(
                            label: "Délibéré",
                            color: const Color(0xFFFFA726),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
        const SizedBox(height: 10),
        // Per-course breakdown
        ...coursList.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          final avg = (c['moyenne_generale'] ?? 0).toDouble();
          final cColor = avg >= 50
              ? _accent
              : avg >= 40
                  ? const Color(0xFFFFA726)
                  : const Color(0xFFFF6B6B);
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _card,
            ),
            child: Row(
              children: [
                // Mini gauge
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          value: (avg / 100).clamp(0, 1),
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.06),
                          valueColor: AlwaysStoppedAnimation<Color>(cColor),
                          strokeWidth: 2.5,
                        ),
                      ),
                      Text(
                        "${avg.toInt()}",
                        style: GoogleFonts.inter(
                          color: cColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c['cours'] ?? '',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${c['total_notes'] ?? 0} notes • /${c['ponderation'] ?? 0}",
                        style: GoogleFonts.inter(
                          color: Colors.white38,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${avg.toStringAsFixed(1)}%",
                  style: GoogleFonts.inter(
                    color: cColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: (i * 60).ms, duration: 350.ms)
              .slideX(begin: 0.05);
        }),
      ],
    );
  }

  // ===========================
  // HELPERS
  // ===========================
  Widget _loader() => Center(
        child: CircularProgressIndicator(color: _accent, strokeWidth: 2),
      );

  Widget _emptyState(String text) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded,
                color: Colors.white.withValues(alpha: 0.15), size: 48),
            const SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.inter(color: Colors.white38, fontSize: 13),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),
      );
}

// ===========================
// SECTION: Evaluations par cours
// ===========================
class _CoursEvalSection extends StatelessWidget {
  final String coursName;
  final List<Map<String, dynamic>> evaluations;
  final Color accent;

  const _CoursEvalSection({
    required this.coursName,
    required this.evaluations,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            coursName,
            style: GoogleFonts.inter(
              color: accent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...evaluations.asMap().entries.map((entry) {
          final i = entry.key;
          final ev = entry.value;
          final note = ev['note'];
          final pond = ev['ponderation'] ?? 0;
          final hasNote = note != null;
          final noteColor = hasNote
              ? (note / pond * 100 >= 50
                  ? const Color(0xFF00B894)
                  : note / pond * 100 >= 40
                      ? const Color(0xFFFFA726)
                      : const Color(0xFFFF6B6B))
              : Colors.white24;

          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF1A1A24),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: noteColor.withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    _evalIcon(ev['type_sigle'] ?? ''),
                    color: noteColor,
                    size: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ev['type_evaluation'] ?? '',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${ev['periode'] ?? ''} • ${ev['date_eval'] ?? ''}",
                        style: GoogleFonts.inter(
                          color: Colors.white30,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  hasNote ? "${note}/$pond" : "--/$pond",
                  style: GoogleFonts.inter(
                    color: noteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: (i * 40).ms, duration: 300.ms);
        }),
        const SizedBox(height: 4),
      ],
    );
  }

  IconData _evalIcon(String sigle) {
    switch (sigle.toUpperCase()) {
      case 'INT':
        return Icons.quiz_rounded;
      case 'TP':
        return Icons.build_rounded;
      case 'TD':
        return Icons.assignment_rounded;
      case 'EX':
        return Icons.school_rounded;
      default:
        return Icons.edit_note_rounded;
    }
  }
}

// ===========================
// SECTION: Notes par cours
// ===========================
class _CoursNotesSection extends StatelessWidget {
  final String coursName;
  final List<Map<String, dynamic>> notes;

  const _CoursNotesSection({
    required this.coursName,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate average
    double total = 0;
    int count = 0;
    for (var n in notes) {
      if (n['note'] != null && n['ponderation'] != null && n['ponderation'] > 0) {
        total += (n['note'] / n['ponderation'] * 100);
        count++;
      }
    }
    final avg = count > 0 ? (total / count) : 0.0;
    final avgColor = avg >= 50
        ? const Color(0xFF00B894)
        : avg >= 40
            ? const Color(0xFFFFA726)
            : const Color(0xFFFF6B6B);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1A1A24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course header
          Row(
            children: [
              Expanded(
                child: Text(
                  coursName,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: avgColor.withValues(alpha: 0.12),
                ),
                child: Text(
                  "Moy: ${avg.toStringAsFixed(1)}%",
                  style: GoogleFonts.inter(
                    color: avgColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Notes list
          ...notes.map((n) {
            final color = (n['note'] ?? 0) / (n['ponderation'] ?? 1) * 100 >= 50
                ? const Color(0xFF00B894)
                : (n['note'] ?? 0) / (n['ponderation'] ?? 1) * 100 >= 40
                    ? const Color(0xFFFFA726)
                    : const Color(0xFFFF6B6B);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${n['type_note_sigle'] ?? ''} • ${n['periode'] ?? ''}",
                      style: GoogleFonts.inter(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Text(
                    "${n['note'] ?? 0}/${n['ponderation'] ?? 0}",
                    style: GoogleFonts.inter(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05);
  }
}

// ===========================
// Common widget
// ===========================
class _MiniChip extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color.withValues(alpha: 0.12),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
