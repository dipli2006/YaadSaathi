import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/trusted_session_service.dart';

class ElderlyLoginScreen extends StatefulWidget {
  const ElderlyLoginScreen({super.key});

  @override
  State<ElderlyLoginScreen> createState() => _ElderlyLoginScreenState();
}

class _ElderlyLoginScreenState extends State<ElderlyLoginScreen> {
  bool _isLoading = false;

  Future<void> _continueWithTrustedSession() async {
    setState(() => _isLoading = true);
    await TrustedSessionService.restore();
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.elderlyHome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome back')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.waving_hand, size: 80),
              const SizedBox(height: 24),
              Text(
                AuthService.hasLinkedAccounts
                    ? 'You are connected to ${AuthService.caregiverName}, your trusted caregiver.'
                    : 'Your caregiver will connect your trusted account during setup.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _continueWithTrustedSession,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}