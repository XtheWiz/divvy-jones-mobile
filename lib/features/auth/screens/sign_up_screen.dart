import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/app_title_bar.dart';
import '../../../shared/widgets/social_login_button.dart';

/// Sign Up Screen - Matching Figma Design
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.register(
        _emailController.text.trim(),
        _passwordController.text,
        _fullNameController.text.trim(),
      );

      if (mounted) {
        setState(() => _isLoading = false);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Welcome aboard, Captain!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.go('/home');
        } else {
          setState(() {
            _errorMessage = authProvider.error ?? 'Registration failed. Please try again.';
          });
        }
      }
    }
  }

  void _navigateToSignIn() {
    context.pop();
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);
    // TODO: Implement Google OAuth
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Sign-Up coming soon!'),
          backgroundColor: AppColors.primaryPurple,
        ),
      );
    }
  }

  Future<void> _handleFacebookSignUp() async {
    setState(() => _isLoading = true);
    // TODO: Implement Facebook OAuth
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Facebook Sign-Up coming soon!'),
          backgroundColor: AppColors.primaryPurple,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Title Bar with Back Button
              AppTitleBar(
                onBackPressed: _navigateToSignIn,
                showBackButton: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mascot Image
                        Center(
                          child: Image.asset(
                            'assets/images/mascot_signup.png',
                            width: 240,
                            height: 220,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 240,
                                height: 220,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.sailing,
                                  size: 80,
                                  color: AppColors.primaryPurple,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Title
                        Text('Sign Up', style: AppTypography.heading2),
                        const SizedBox(height: 24),
                        // Social Login Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialLoginButton.google(
                              onPressed: _handleGoogleSignUp,
                            ),
                            const SizedBox(width: 20),
                            SocialLoginButton.facebook(
                              onPressed: _handleFacebookSignUp,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Divider
                        Center(
                          child: Text(
                            'Or, register with email',
                            style: AppTypography.caption,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Error message
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 16,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Full Name Input
                        AppTextField(
                          label: 'Full Name',
                          hintText: 'Enter your name',
                          controller: _fullNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Email Input
                        AppTextField(
                          label: 'Email',
                          hintText: 'Enter Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Password Input
                        AppTextField(
                          label: 'Password',
                          hintText: 'Enter Password',
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        // Sign Up Button
                        AppButton(
                          text: 'Join the Crew',
                          onPressed: _isLoading ? null : _handleSignUp,
                          isLoading: _isLoading,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 24),
                        // Sign In Link
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: AppTypography.bodyMedium,
                              children: [
                                const TextSpan(
                                  text: 'Already have an account? ',
                                ),
                                TextSpan(
                                  text: 'Sign In',
                                  style: AppTypography.link.copyWith(
                                    fontSize: 14,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _navigateToSignIn,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
