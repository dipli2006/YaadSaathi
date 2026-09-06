import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';

class CaregiverLoginScreen extends StatefulWidget {
	const CaregiverLoginScreen({super.key});

	@override
	State<CaregiverLoginScreen> createState() => _CaregiverLoginScreenState();
}

class _CaregiverLoginScreenState extends State<CaregiverLoginScreen> {
	final _formKey = GlobalKey<FormState>();
	final _emailController = TextEditingController();
	final _passwordController = TextEditingController();
	bool _isLoading = false;

	@override
	void dispose() {
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	Future<void> _login() async {
		if (!_formKey.currentState!.validate()) {
			return;
		}

		setState(() => _isLoading = true);
		await Future<void>.delayed(const Duration(milliseconds: 400));
		if (!mounted) {
			return;
		}
		Navigator.pushReplacementNamed(context, AppRoutes.caregiverDashboard);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Caregiver login')),
			body: SafeArea(
				child: Form(
					key: _formKey,
					child: ListView(
						padding: const EdgeInsets.all(24),
						children: [
							const SizedBox(height: 24),
							const Icon(Icons.lock, size: 64),
							const SizedBox(height: 24),
							TextFormField(
								controller: _emailController,
								keyboardType: TextInputType.emailAddress,
								decoration: const InputDecoration(labelText: 'Email'),
								validator: (value) => value == null || !value.contains('@')
										? 'Enter a valid email'
										: null,
							),
							const SizedBox(height: 16),
							TextFormField(
								controller: _passwordController,
								obscureText: true,
								decoration: const InputDecoration(labelText: 'Password'),
								validator: (value) => value == null || value.length < 6
										? 'Password must be at least 6 characters'
										: null,
							),
							const SizedBox(height: 28),
							ElevatedButton(
								onPressed: _isLoading ? null : _login,
								child: _isLoading
										? const SizedBox(
												height: 24,
												width: 24,
												child: CircularProgressIndicator(strokeWidth: 2),
											)
										: const Text('Log in'),
							),
						],
					),
				),
			),
		);
	}
}
