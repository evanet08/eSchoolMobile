import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/custom_widgets/modern_button.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  bool _obscurePassword = true;
  String _email = "";
  String _password = "";
  late AuthenticationProvider auth;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String get _userType => AccountCreationProvider.instance.typeUser ?? 'Student';

  String _getLoginTitle() {
    switch (_userType) {
      case 'Teacher':
        return AppLocalizations.of(context)!.login_as_teacher;
      case 'Parent':
        return AppLocalizations.of(context)!.login_as_parent;
      case 'Student':
        return AppLocalizations.of(context)!.login_as_student;
      case 'Administrative':
        return AppLocalizations.of(context)!.login_as_administrative;
      default:
        return AppLocalizations.of(context)!.login;
    }
  }

  IconData _getUserIcon() {
    switch (_userType) {
      case 'Teacher':
        return Icons.school_rounded;
      case 'Parent':
        return Icons.family_restroom_rounded;
      case 'Student':
        return Icons.backpack_rounded;
      case 'Administrative':
        return Icons.settings_rounded;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);
    final userColor = ColorConstantes.getColorForUserType(_userType);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF283593),
              Color(0xFF3949AB),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    
                    // Back Button
                    _buildBackButton().animate().fadeIn(duration: 300.ms),
                    
                    const SizedBox(height: 20),
                    
                    // Logo
                    _buildLogo().animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9)),
                    
                    const SizedBox(height: 16),
                    
                    // App Name & Message
                    _buildHeader().animate().fadeIn(delay: 300.ms),
                    
                    const SizedBox(height: 25),
                    
                    // Login Card (Glass)
                    _buildLoginCard(userColor).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 20),
                    
                    // Create Account
                    _buildCreateAccount().animate().fadeIn(delay: 600.ms),
                    
                    const SizedBox(height: 25),
                    
                    // Powered By
                    _buildPoweredBy().animate().fadeIn(delay: 700.ms),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => NavigationService.instance.navigateToReplacement("user_selection"),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Image.asset(
            "assets/images/logo.png",
            height: 60,
            width: 60,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.app_name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context)!.authentication_msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(Color userColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              // User Type Badge
              _buildUserTypeBadge(userColor),
              
              const SizedBox(height: 24),
              
              // Email Field
              _buildTextField(
                label: AppLocalizations.of(context)!.email,
                hint: AppLocalizations.of(context)!.your_email,
                icon: Icons.email_outlined,
                color: userColor,
                onChanged: (val) => _email = val,
                validator: (input) {
                  if (input == null || input.isEmpty) return AppLocalizations.of(context)!.empty_email_alert;
                  // Validation assouplie pour permettre téléphone, email ou username
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Password Field
              _buildTextField(
                label: AppLocalizations.of(context)!.password,
                hint: AppLocalizations.of(context)!.your_password,
                icon: Icons.lock_outline_rounded,
                color: userColor,
                obscure: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.white70,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                onChanged: (val) => _password = val,
                validator: (input) {
                  if (input == null || input.isEmpty) return AppLocalizations.of(context)!.empty_password_alert;
                  return null;
                },
              ),
              
              const SizedBox(height: 14),
              
              // Remember & Forgot
              _buildRememberForgot(userColor),
              
              const SizedBox(height: 24),
              
              // Login Button
              _buildLoginButton(userColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeBadge(Color userColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: userColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: userColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getUserIcon(), color: userColor, size: 18),
          const SizedBox(width: 8),
          Text(
            _getLoginTitle(),
            style: TextStyle(
              color: userColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    bool obscure = false,
    Widget? suffixIcon,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
        prefixIcon: Icon(icon, color: color, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ColorConstantes.errorRed),
        ),
        errorStyle: const TextStyle(color: Colors.orangeAccent),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildRememberForgot(Color userColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => setState(() => isChecked = !isChecked),
          child: Row(
            children: [
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: isChecked ? userColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: isChecked ? userColor : Colors.white60),
                ),
                child: isChecked ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.remember_me,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => NavigationService.instance.navigateToReplacement("check_phone_number", args: "forgot password"),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text(
            AppLocalizations.of(context)!.forgot_password,
            style: TextStyle(color: userColor, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(Color userColor) {
    return SizedBox(
      width: double.infinity,
      child: ModernButton(
        text: AppLocalizations.of(context)!.login,
        isLoading: auth.status == AuthenticationStatus.Authenticating,
        backgroundColor: userColor,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            UtilisateurService.instance.login(context, _email, _password, _userType, "");
          }
        },
      ),
    );
  }

  Widget _buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.no_have_account,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () => NavigationService.instance.navigateToReplacement("check_phone_number", args: OtherConstantes.creatingAccount),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text(
            AppLocalizations.of(context)!.create_account,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPoweredBy() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.powered_by,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
        ),
        const Text(
          "ICT Group",
          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
