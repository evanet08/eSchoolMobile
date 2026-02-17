import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/models/language.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/language_provider.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:provider/provider.dart';

class UserSelectionPage extends StatefulWidget {
  const UserSelectionPage({super.key});

  @override
  State<UserSelectionPage> createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2D1B69),  // Deep purple-blue
              Color(0xFF1E3A8A),  // Royal blue
              Color(0xFF3B82F6),  // Bright blue
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                // Language Selector at top left
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildLanguageSelector().animate().fadeIn(duration: 400.ms),
                ),
                
                const SizedBox(height: 16),
                
                // Main Glass Card Container with Logo on top
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Glass Card (starts at logo midpoint)
                      Positioned(
                        top: 60, // Half of logo height (120/2)
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Stack(
                          children: [
                            // Pink/Violet glow overlay on left side - INTENSE
                            Positioned(
                              left: -80,
                              top: 80,
                              bottom: 80,
                              width: 250,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFFFF0A78).withValues(alpha: 0.8),
                                      const Color(0xFFDB2777).withValues(alpha: 0.6),
                                      const Color(0xFFDB2777).withValues(alpha: 0.3),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.3, 0.6, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            
                            // Purple/Blue glow overlay on right side - INTENSE
                            Positioned(
                              right: -80,
                              top: 80,
                              bottom: 80,
                              width: 250,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFFBF40FF).withValues(alpha: 0.8),
                                      const Color(0xFF9333EA).withValues(alpha: 0.6),
                                      const Color(0xFF6366F1).withValues(alpha: 0.3),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.3, 0.6, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            
                            // Main glass card
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 2,
                                ),
                                boxShadow: [
                                  // Pink/Purple glow on edges (left side)
                                  BoxShadow(
                                    color: const Color(0xFFDB2777).withValues(alpha: 0.3),
                                    blurRadius: 100,
                                    spreadRadius: -20,
                                    offset: const Offset(-30, 0),
                                  ),
                                  // Pink/Purple glow on edges (right side)
                                  BoxShadow(
                                    color: const Color(0xFF9333EA).withValues(alpha: 0.3),
                                    blurRadius: 100,
                                    spreadRadius: -20,
                                    offset: const Offset(30, 0),
                                  ),
                                  // Enhanced outer blue glow effect
                                  BoxShadow(
                                    color: Colors.blue.withValues(alpha: 0.35),
                                    blurRadius: 100,
                                    spreadRadius: 10,
                                    offset: const Offset(0, 0),
                                  ),
                                  // Main shadow
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 60,
                                    offset: const Offset(0, 15),
                                  ),
                                  // Subtle inner depth
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 30,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                                child: Column(
                                  children: [
                                    // Welcome Text
                                    _buildWelcomeText().animate().fadeIn(delay: 400.ms),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // User Type Buttons (compact)
                                    _buildWhiteButton(
                                      userType: 'Teacher',
                                      label: AppLocalizations.of(context)!.teacher,
                                      icon: Icons.school_rounded,
                                      color: ColorConstantes.teacherColor,
                                      delay: 500,
                                    ),
                                    const SizedBox(height: 12),
                                    _buildWhiteButton(
                                      userType: 'Parent',
                                      label: AppLocalizations.of(context)!.parent,
                                      icon: Icons.family_restroom_rounded,
                                      color: ColorConstantes.parentColor,
                                      delay: 600,
                                    ),
                                    const SizedBox(height: 12),
                                    _buildWhiteButton(
                                      userType: 'Student',
                                      label: AppLocalizations.of(context)!.student,
                                      icon: Icons.backpack_rounded,
                                      color: ColorConstantes.studentColor,
                                      delay: 700,
                                    ),
                                    const SizedBox(height: 12),
                                    _buildWhiteButton(
                                      userType: 'Administrative',
                                      label: AppLocalizations.of(context)!.administrative,
                                      icon: Icons.settings_rounded,
                                      color: ColorConstantes.administrativeColor,
                                      delay: 800,
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Powered By Footer
                                    _buildFooter().animate().fadeIn(delay: 900.ms),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                          ],
                        ),
                      ),
                      
                      // Logo centered on top (overlapping)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _buildLogoSection().animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // Glass Language Button
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: PopupMenuButton<Language>(
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  elevation: 8,
                  itemBuilder: (ctx) => [
                    Language(AppLocalizations.of(context)!.french, "fr", "assets/images/france.png"),
                    Language(AppLocalizations.of(context)!.english, "en", "assets/images/angleterre.png"),
                    Language(AppLocalizations.of(context)!.swahili, "sw", "assets/images/tanzanie.png"),
                    Language(AppLocalizations.of(context)!.kirundi, "es", "assets/images/burundi.png"),
                    Language(AppLocalizations.of(context)!.lingala, "zh", "assets/images/drc.png"),
                  ].map((lang) => PopupMenuItem<Language>(
                    value: lang,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.asset(lang.imageSrc, height: 18, width: 26, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 10),
                        Text(lang.language, style: const TextStyle(color: ColorConstantes.blackColor, fontSize: 14)),
                      ],
                    ),
                  )).toList(),
                  onSelected: (language) {
                    languageProvider.changeLanguage(context, language);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Image.asset(
                          languageProvider.language.imageSrc,
                          height: 16,
                          width: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.language, size: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        languageProvider.language.code.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          // Enhanced large outer glow/halo effect
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.4),
            blurRadius: 70,
            spreadRadius: 15,
            offset: const Offset(0, 0),
          ),
          // Enhanced blue tint glow
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 60,
            spreadRadius: 8,
            offset: const Offset(0, 0),
          ),
          // Main shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          // Subtle close shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.welcome_title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppLocalizations.of(context)!.welcome_subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildWhiteButton({
    required String userType,
    required String label,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return GestureDetector(
      onTap: () {
        AccountCreationProvider.instance.setTypeUser(userType);
        NavigationService.instance.navigateTo("login");
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Colored Icon Circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            
            // Label
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: 0.08);
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.powered_by,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const Text(
            "ICT Group",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Particles painter for background effect
class ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Create random-looking particles
    final random = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.3, size.height * 0.25),
      Offset(size.width * 0.7, size.height * 0.1),
      Offset(size.width * 0.85, size.height * 0.3),
      Offset(size.width * 0.2, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.9, size.height * 0.55),
      Offset(size.width * 0.15, size.height * 0.65),
      Offset(size.width * 0.45, size.height * 0.7),
      Offset(size.width * 0.75, size.height * 0.75),
      Offset(size.width * 0.25, size.height * 0.85),
      Offset(size.width * 0.65, size.height * 0.9),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.65),
      Offset(size.width * 0.35, size.height * 0.55),
      Offset(size.width * 0.4, size.height * 0.12),
      Offset(size.width * 0.92, size.height * 0.42),
      Offset(size.width * 0.12, size.height * 0.78),
      Offset(size.width * 0.55, size.height * 0.82),
      Offset(size.width * 0.72, size.height * 0.25),
    ];

    for (var i = 0; i < random.length; i++) {
      final radius = (i % 3 == 0) ? 2.5 : ((i % 2 == 0) ? 1.5 : 1.0);
      paint.color = Colors.white.withValues(alpha: (i % 4 == 0) ? 0.6 : 0.3);
      canvas.drawCircle(random[i], radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
