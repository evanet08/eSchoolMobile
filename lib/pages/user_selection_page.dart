import 'dart:math';
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

class _UserSelectionPageState extends State<UserSelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
              Color(0xFF0F0C29),
              Color(0xFF1A1A4E),
              Color(0xFF24243E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Language Selector at top
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildLanguageSelector()
                      .animate()
                      .fadeIn(duration: 400.ms),
                ),
              ),

              // Main content - Circle layout
              Expanded(
                child: _buildCircleLayout(),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildFooter().animate().fadeIn(delay: 1200.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final centerY = constraints.maxHeight / 2;
        // Radius of the circle on which buttons are placed
        final circleRadius = min(centerX, centerY) * 0.60;
        // Logo size
        const logoSize = 100.0;
        // Button size
        const buttonSize = 80.0;

        // 4 menu items placed at top, right, bottom, left (like a compass)
        final menuItems = [
          _MenuItemData(
            userType: 'Teacher',
            labelKey: 'teacher',
            icon: Icons.school_rounded,
            color: ColorConstantes.teacherColor,
            angle: -pi / 2, // Top (12 o'clock)
          ),
          _MenuItemData(
            userType: 'Parent',
            labelKey: 'parent',
            icon: Icons.family_restroom_rounded,
            color: ColorConstantes.parentColor,
            angle: 0, // Right (3 o'clock)
          ),
          _MenuItemData(
            userType: 'Student',
            labelKey: 'student',
            icon: Icons.backpack_rounded,
            color: ColorConstantes.studentColor,
            angle: pi / 2, // Bottom (6 o'clock)
          ),
          _MenuItemData(
            userType: 'Administrative',
            labelKey: 'administrative',
            icon: Icons.settings_rounded,
            color: ColorConstantes.administrativeColor,
            angle: pi, // Left (9 o'clock)
          ),
        ];

        return Stack(
          children: [
            // Animated ring/circle around the logo
            Positioned(
              left: centerX - circleRadius - 2,
              top: centerY - circleRadius - 2,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final pulse = 1.0 + _pulseController.value * 0.03;
                  return Transform.scale(
                    scale: pulse,
                    child: CustomPaint(
                      size: Size(
                          (circleRadius + 2) * 2, (circleRadius + 2) * 2),
                      painter: _OrbitRingPainter(
                        progress: _pulseController.value,
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 800.ms),

            // Connecting lines from center to each menu item
            ...menuItems.asMap().entries.map((entry) {
              final item = entry.value;
              final ix = centerX + circleRadius * cos(item.angle);
              final iy = centerY + circleRadius * sin(item.angle);
              return Positioned.fill(
                child: CustomPaint(
                  painter: _ConnectorLinePainter(
                    start: Offset(centerX, centerY),
                    end: Offset(ix, iy),
                    color: item.color.withValues(alpha: 0.25),
                  ),
                ),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: 400 + entry.key * 150),
                    duration: const Duration(milliseconds: 600),
                  );
            }),

            // Logo at center
            Positioned(
              left: centerX - logoSize / 2,
              top: centerY - logoSize / 2,
              child: _buildCenterLogo(logoSize),
            ),

            // Menu items on the circle's circumference
            ...menuItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final ix = centerX + circleRadius * cos(item.angle);
              final iy = centerY + circleRadius * sin(item.angle);

              String label;
              switch (item.labelKey) {
                case 'teacher':
                  label = AppLocalizations.of(context)!.teacher;
                  break;
                case 'parent':
                  label = AppLocalizations.of(context)!.parent;
                  break;
                case 'student':
                  label = AppLocalizations.of(context)!.student;
                  break;
                case 'administrative':
                  label = AppLocalizations.of(context)!.administrative;
                  break;
                default:
                  label = item.labelKey;
              }

              return Positioned(
                left: ix - buttonSize / 2,
                top: iy - buttonSize / 2,
                child: _buildCircleMenuItem(
                  userType: item.userType,
                  label: label,
                  icon: item.icon,
                  color: item.color,
                  size: buttonSize,
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 500 + index * 150),
                    duration: 500.ms,
                  )
                  .scale(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(1.0, 1.0),
                    delay: Duration(milliseconds: 500 + index * 150),
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  );
            }),

            // Welcome text below the circle
            Positioned(
              left: 0,
              right: 0,
              top: centerY + circleRadius + buttonSize / 2 + 20,
              child: _buildWelcomeText(),
            ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
          ],
        );
      },
    );
  }

  Widget _buildCenterLogo(double size) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final glowIntensity = 0.3 + _pulseController.value * 0.2;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              // Outward glow
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: glowIntensity),
                blurRadius: 50,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: glowIntensity * 0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 200.ms).scale(
          begin: const Offset(0.5, 0.5),
          duration: 600.ms,
          curve: Curves.elasticOut,
        );
  }

  Widget _buildCircleMenuItem({
    required String userType,
    required String label,
    required IconData icon,
    required Color color,
    required double size,
  }) {
    return GestureDetector(
      onTap: () {
        AccountCreationProvider.instance.setTypeUser(userType);
        NavigationService.instance.navigateTo("login");
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color.withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: size * 0.4),
          ),
          const SizedBox(height: 8),
          // Label below
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: PopupMenuButton<Language>(
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              elevation: 8,
              itemBuilder: (ctx) => [
                Language(AppLocalizations.of(context)!.french, "fr",
                    "assets/images/france.png"),
                Language(AppLocalizations.of(context)!.english, "en",
                    "assets/images/angleterre.png"),
                Language(AppLocalizations.of(context)!.swahili, "sw",
                    "assets/images/tanzanie.png"),
                Language(AppLocalizations.of(context)!.kirundi, "es",
                    "assets/images/burundi.png"),
                Language(AppLocalizations.of(context)!.lingala, "zh",
                    "assets/images/drc.png"),
              ]
                  .map((lang) => PopupMenuItem<Language>(
                        value: lang,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Image.asset(lang.imageSrc,
                                  height: 18, width: 26, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 10),
                            Text(lang.language,
                                style: const TextStyle(
                                    color: ColorConstantes.blackColor,
                                    fontSize: 14)),
                          ],
                        ),
                      ))
                  .toList(),
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
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.language,
                              size: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    languageProvider.language.code.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          AppLocalizations.of(context)!.welcome_subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.powered_by,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
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
    );
  }
}

// Data holder for each menu item
class _MenuItemData {
  final String userType;
  final String labelKey;
  final IconData icon;
  final Color color;
  final double angle; // Position angle in radians

  _MenuItemData({
    required this.userType,
    required this.labelKey,
    required this.icon,
    required this.color,
    required this.angle,
  });
}

// Painter for the orbital ring around the logo
class _OrbitRingPainter extends CustomPainter {
  final double progress;

  _OrbitRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Dashed circle ring
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12 + progress * 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, radius, ringPaint);

    // Second subtle inner ring
    final innerRingPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius * 0.7, innerRingPaint);

    // Small dots at cardinal points on the ring
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3 + progress * 0.2);

    for (int i = 0; i < 4; i++) {
      final angle = (i * pi / 2) - pi / 2;
      final dotX = center.dx + radius * cos(angle);
      final dotY = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(dotX, dotY), 3, dotPaint);
    }

    // Tiny decorative dots around the ring
    final tinyDotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15);

    for (int i = 0; i < 24; i++) {
      final angle = (i * pi / 12);
      if (i % 6 != 0) {
        // Skip cardinal positions
        final dotX = center.dx + radius * cos(angle);
        final dotY = center.dy + radius * sin(angle);
        canvas.drawCircle(Offset(dotX, dotY), 1.2, tinyDotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Painter for connector lines between center and menu items
class _ConnectorLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  _ConnectorLinePainter({
    required this.start,
    required this.end,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color,
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromPoints(start, end))
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw dashed line
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectorLinePainter oldDelegate) => false;
}
