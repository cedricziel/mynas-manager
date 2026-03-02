import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mynas_frontend/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _serverUrlController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _serverUrlFocusNode = FocusNode();
  bool _isLoading = false;
  bool _showPassword = false;
  String? _errorMessage;
  bool _showAdvancedSettings = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    // Set default server URL
    _serverUrlController.text = 'ws://localhost/api/current';

    // Auto-focus username field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _serverUrlController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _serverUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a username';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authNotifier = ref.read(authProvider.notifier);
      final success = await authNotifier.login(
        username: _usernameController.text,
        password: _passwordController.text,
        serverUrl: _showAdvancedSettings ? _serverUrlController.text : null,
      );

      if (success && mounted) {
        context.go('/desktop');
      } else {
        setState(() {
          _errorMessage =
              'Authentication failed. Please check your credentials.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection failed: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background with gradient (replace with image when available)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.purple.shade900],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),

          // Login content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'MyNAS Manager',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Sign in with your TrueNAS credentials',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Username field
                      TextField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          _passwordFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Username',
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: !_showPassword,
                        enabled: !_isLoading,
                        onSubmitted: (_) => _handleLogin(),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                              width: 2,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () {
                              setState(() => _showPassword = !_showPassword);
                            },
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),

                      // Advanced settings
                      if (_showAdvancedSettings) ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: _serverUrlController,
                          focusNode: _serverUrlFocusNode,
                          enabled: !_isLoading,
                          onSubmitted: (_) => _handleLogin(),
                          decoration: InputDecoration(
                            hintText: 'TrueNAS WebSocket URL',
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.dns_outlined,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            helperText: 'e.g., ws://192.168.1.100/api/current',
                            helperStyle: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],

                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Additional options
                      TextButton.icon(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _showAdvancedSettings =
                                      !_showAdvancedSettings;
                                });
                              },
                        icon: Icon(
                          _showAdvancedSettings
                              ? Icons.expand_less
                              : Icons.expand_more,
                          size: 20,
                        ),
                        label: Text(
                          _showAdvancedSettings
                              ? 'Hide Advanced Settings'
                              : 'Show Advanced Settings',
                          style: TextStyle(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom info
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
