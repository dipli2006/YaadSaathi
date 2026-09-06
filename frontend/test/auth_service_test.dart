import 'package:flutter_test/flutter_test.dart';
import 'package:yaadsaathi_app/shared/services/auth_service.dart';

void main() {
  test('one signup creates linked caregiver and patient accounts', () async {
    final created = await AuthService.signUp(
      patientName: 'Maya',
      caregiverName: 'Ravi',
      caregiverEmail: 'ravi@example.com',
      caregiverPassword: 'secret123',
      relationship: 'Son',
    );

    expect(created, isTrue);
    expect(AuthService.hasLinkedAccounts, isTrue);
    expect(AuthService.patientName, 'Maya');
    expect(AuthService.caregiverName, 'Ravi');
    expect(AuthService.patientRelationship, 'Son');
    expect(
      await AuthService.login(email: 'ravi@example.com', password: 'secret123'),
      isTrue,
    );
    expect(
      await AuthService.login(email: 'maya@example.com', password: 'secret123'),
      isFalse,
    );
  });
}