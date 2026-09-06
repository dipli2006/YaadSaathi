# Linked Account Onboarding

YaadSaathi is designed for a person living with dementia and their trusted
caregiver. The patient should not be asked to manage a repeated password.

## One signup

The caregiver completes one setup form containing:

- Patient name
- Caregiver name
- Caregiver relationship to the patient
- Caregiver email
- Caregiver password

The frontend creates two linked records in the demo auth service:

```text
Caregiver account
  email + password + caregiver profile

Patient account
  patient profile + trusted caregiver relationship
  no repeated patient password
```

After setup, the caregiver enters the caregiver dashboard. The patient enters
through the trusted-session flow and sees the elderly home experience.

## Backend integration requirement

The local `AuthService` is a coordination seam only. The FastAPI implementation
must create the caregiver user, patient user, and authorized relationship in one
transaction, then return the appropriate session information. It must validate
that the caregiver may access the linked patient data.