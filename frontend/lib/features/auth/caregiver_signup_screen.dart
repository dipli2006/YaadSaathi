import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/services/auth_service.dart';

class CaregiverSignupScreen extends StatefulWidget {
  const CaregiverSignupScreen({super.key});

  @override
  State<CaregiverSignupScreen> createState() => _CaregiverSignupScreenState();
}

class _CaregiverSignupScreenState extends State<CaregiverSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _caregiverNameController = TextEditingController();
  final _caregiverEmailController = TextEditingController();
  final _caregiverPasswordController = TextEditingController();
  String _relationship = 'Family member';
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _patientNameController.dispose();
    _caregiverNameController.dispose();
    _caregiverEmailController.dispose();
    _caregiverPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createLinkedAccounts() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final created = await AuthService.signUp(
      patientName: _patientNameController.text,
      caregiverName: _caregiverNameController.text,
      caregiverEmail: _caregiverEmailController.text,
      caregiverPassword: _caregiverPasswordController.text,
      relationship: _relationship,
    );
    if (!mounted) return;
    if (created) {
      Navigator.pushReplacementNamed(context, AppRoutes.caregiverDashboard);
    } else {
      setState(() {
        _isLoading = false;
        _error = 'A linked care account already exists in this demo session.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
            ),
            const SizedBox(height: 8),
            const Icon(Icons.diversity_1_outlined, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Set up a care circle',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'One signup creates a caregiver account and a safe, password-free patient account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Person receiving care', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _patientNameController,
                        decoration: const InputDecoration(
                          labelText: 'Patient name',
                          prefixIcon: Icon(Icons.favorite_outline),
                        ),
                        validator: (value) => value == null || value.trim().length < 2
                            ? 'Enter the patient name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _relationship,
                        decoration: const InputDecoration(
                          labelText: 'Your relationship to the patient',
                          prefixIcon: Icon(Icons.family_restroom),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Family member', child: Text('Family member')),
                          DropdownMenuItem(value: 'Son', child: Text('Son')),
                          DropdownMenuItem(value: 'Daughter', child: Text('Daughter')),
                          DropdownMenuItem(value: 'Spouse', child: Text('Spouse')),
                          DropdownMenuItem(value: 'Friend', child: Text('Friend')),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _relationship = value);
                        },
                      ),
                      const SizedBox(height: 26),
                      Text('Trusted caregiver account', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _caregiverNameController,
                        decoration: const InputDecoration(
                          labelText: 'Caregiver name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) => value == null || value.trim().length < 2
                            ? 'Enter the caregiver name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _caregiverEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Caregiver email',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (value) => value == null || !value.contains('@')
                            ? 'Enter a valid caregiver email'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _caregiverPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Caregiver password',
                          prefixIcon: Icon(Icons.key_outlined),
                        ),
                        validator: (value) => value == null || value.length < 6
                            ? 'Use at least 6 characters'
                            : null,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(_error!, style: const TextStyle(color: AppColors.primary)),
                      ],
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createLinkedAccounts,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Create both accounts'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.caregiverLogin,
                        ),
                        child: const Text('Already set up? Caregiver log in'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
