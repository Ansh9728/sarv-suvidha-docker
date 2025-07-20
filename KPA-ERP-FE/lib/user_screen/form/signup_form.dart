import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/services/authentication_services/auth_service.dart';
import 'package:kpa_erp/services/train_service_signup.dart';
import 'package:kpa_erp/types/zone_division_type.dart';
import 'package:kpa_erp/user_screen/widgets/login_page/password_field.dart';
import 'package:kpa_erp/user_screen/widgets/login_page/privacy_policies.dart';
import 'package:kpa_erp/user_screen/widgets/signup_page/depot_dropdown.dart';
import 'package:kpa_erp/user_screen/widgets/signup_page/division_dropdown.dart';
import 'package:kpa_erp/user_screen/widgets/signup_page/email_field.dart';
import 'package:kpa_erp/user_screen/widgets/signup_page/emp_number_field.dart';
import 'package:kpa_erp/user_screen/widgets/signup_page/mobile_field_signup.dart';
import 'package:kpa_erp/user_screen/widgets/signup_page/re_password.dart';
import 'package:kpa_erp/user_screen/widgets/signup_page/roles_dropdown.dart';
import 'package:kpa_erp/user_screen/widgets/signup_page/zone_dropdown.dart';
import 'package:kpa_erp/widgets/error_modal.dart';
import 'package:kpa_erp/widgets/loader.dart';
import 'package:kpa_erp/widgets/success_modal.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  // Form field values
  late String _mobileNumber = '',
      _firstName = '',
      _middleName = '',
      _lastName = '',
      _email = '',
      _password = '',
      _rePassword = '',
      _empNumber = '';
  late String _whatsappNumber = '';
  late String _secondaryPhoneNumber = '';
  late String _division = '',
      _depot = '',
      _role = 'coach attendent',
      _selectedZones = '';
  List<String> depots = [];
  List<String> trainList = [];
  List<String> EmpNumberList = [];
  List<String> coachList = [];
  List<String> _trainNumber = [];
  List<String> _coachNumber = [];
  List<String> division_codes = [];

  // Form completion flags
  bool _isLoading = false;
  bool _isEmailVerified = false;
  bool _isPhoneVerified = false;
  bool _isWhatsappVerified = false;
  bool _wasClicked = false;
  bool _sameAsPhone = false;

  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;
  bool _isEmailEditable = false;
  bool _isPhoneEditable = false;
  bool _isWhatsappEditable = false;
  bool _isPasswordEditable = false;
  bool _isRoleEditable = false;
  bool _isStaffFieldsEditable = false;
  bool _isSubmitButtonEnabled = false;
  bool _isButtonEnabled = false;

  // Field controllers to validate input
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _secondaryPhoneController =
      TextEditingController();

  bool get _isPassenger => _role.toLowerCase() == 'passenger';

  @override
  void initState() {
    super.initState();
    // Add listeners to controllers to check field validity
    _firstNameController.addListener(_validateFirstName);
    _lastNameController.addListener(_validateLastName);
    _secondaryPhoneController.addListener(_validateSecondaryPhone);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _secondaryPhoneController.dispose();
    super.dispose();
  }

  // Validation methods to control form flow
  void _validateFirstName() {
    final value = _firstNameController.text;
    setState(() {
      _isFirstNameValid = value.isNotEmpty;
      _firstName = value;
    });
  }

  void _validateLastName() {
    final value = _lastNameController.text;
    setState(() {
      _isLastNameValid = value.isNotEmpty;
      _lastName = value;
      // Enable email when both first and last name are valid
      _isEmailEditable = _isFirstNameValid && _isLastNameValid;
    });
  }

  void _validateSecondaryPhone() {
    final value = _secondaryPhoneController.text;
    setState(() {
      _secondaryPhoneNumber = value;
    });
  }

  void _validateEmail(bool isVerified) {
    setState(() {
      _isEmailVerified = isVerified;
      if (isVerified) {
        _isPhoneEditable = true; // Enable phone field when email is verified
      }
    });
  }

  void _validatePhone(bool isVerified) {
    setState(() {
      _isPhoneVerified = isVerified;
      if (isVerified) {
        _isWhatsappEditable = true;
      }
    });
  }

  void _validateWhatsapp() {
    setState(() {
      if (_sameAsPhone) {
        _whatsappNumber = _mobileNumber;
        _isWhatsappVerified = true;
      } else if (_whatsappNumber.length == 10 &&
          RegExp(r'^[0-9]+$').hasMatch(_whatsappNumber)) {
        _isWhatsappVerified = true;
      } else {
        _isWhatsappVerified = false;
      }

      if (_isWhatsappVerified) {
        _isPasswordEditable = true;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _password = value;
    });
    _checkPasswordMatch();
  }

  void _validateRePassword(String value) {
    setState(() {
      _rePassword = value;
    });
    _checkPasswordMatch();
  }

  void _checkPasswordMatch() {
    if (_password.isNotEmpty &&
        _rePassword.isNotEmpty &&
        _password == _rePassword) {
      setState(() {
        _isRoleEditable = true;
      });
    } else {
      setState(() {
        _isRoleEditable = false;
      });
    }
  }

  void _updateButtonState() {
    setState(() {
      bool whatsappValid = _sameAsPhone ||
          (!_sameAsPhone && !_wasClicked) ||
          (_wasClicked && _isWhatsappVerified);

      _isButtonEnabled = _isPhoneVerified && whatsappValid;
    });
  }

  // Validation method for secondary phone
  String? _validateSecondaryPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // It's optional, so empty is allowed
    }

    if (value.length != 10) {
      return 'Secondary phone number must be exactly 10 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter only numbers';
    }

    if (value == _mobileNumber) {
      return 'Phone number and Secondary phone number must be different';
    }

    return null;
  }

  Future getDepot() async {
    try {
      final getData = await TrainServiceSignup.getDepot(_division);
      setState(() {
        depots = getData;
      });
    } catch (e) {
      showErrorModal(context, '$e', "Error", () {});
      if (e is StateError && e.toString().contains('mounted')) {
        print('Widget disposed before operation completes');
      } else {
        print('Get Depot Failed : $e');
      }
    }
  }

  Future getTrainList() async {
    try {
      final getData = await TrainServiceSignup.getTrainList(_depot);
      setState(() {
        trainList = getData['trains'];
        EmpNumberList = getData['emp_numbers'];
      });
    } catch (e) {
      showErrorModal(context, '$e', "Error", () {});
      if (e is StateError && e.toString().contains('mounted')) {
        print('Widget disposed before operation completes');
      } else {
        print('Get Train List Failed : $e');
      }
    }
  }

  Future getCoachList() async {
    try {
      final getData =
          await TrainServiceSignup.getCoaches(_trainNumber.join(','));
      setState(() {
        coachList = getData;
      });
    } catch (e) {
      showErrorModal(context, '$e', "Error", () {});
      if (e is StateError && e.toString().contains('mounted')) {
        print('Get Coach List Failed : $e');
      } else {
        print('Get Coach List Failed : $e');
      }
    }
  }

  // Handle the selected zones
  void _handleZoneSelection(String selectedZones) async {
    setState(() {
      _selectedZones = selectedZones;
    });

    if (_selectedZones.isNotEmpty) {
      try {
        List<ZoneDivision> divisions =
            await TrainServiceSignup.getDivisions(_selectedZones);

        List<String> divisionCodes =
            divisions.map((division) => division.code).toList();

        setState(() {
          division_codes = divisionCodes;
        });
      } catch (e) {
        print("Error fetching divisions: $e");
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      loader(context, "Submitting Data. Please Wait!");

      try {
        // Set default values for passenger
        final submitZones = _isPassenger ? '' : _selectedZones;
        final submitDivision = _isPassenger ? '' : _division;
        final submitDepot = _isPassenger ? '' : _depot;
        final submitEmpNumber = _isPassenger ? '' : _empNumber;

        final response = await AuthService.signup(
            _mobileNumber,
            _firstName,
            _middleName,
            _lastName,
            _email,
            _password,
            _rePassword,
            _role,
            submitDivision,
            _trainNumber.join(','),
            _coachNumber.join(','),
            submitDepot,
            submitEmpNumber,
            submitZones,
            _whatsappNumber,
            _secondaryPhoneNumber);
        Navigator.of(context).pop();
        showSuccessModal(context, response, "Success", () {
          Navigator.pushNamed(context, Routes.login);
        });
      } catch (e) {
        Navigator.of(context).pop();
        if (e is SignupDetailsException) {
          showErrorModal(context, '$e', "Error", () {});
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // If validation fails, show validation errors
      showErrorModal(context, "Please complete all required fields correctly",
          "Form Incomplete", () {});
    }
  }

  Widget _buildNameFields() {
    return Column(
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            labelText: 'First Name *',
            hintText: 'Enter your first name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _middleNameController,
          decoration: const InputDecoration(
            labelText: 'Middle Name (Optional)',
            hintText: 'Enter your middle name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _middleName = value;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _lastNameController,
          decoration: const InputDecoration(
            labelText: 'Last Name *',
            hintText: 'Enter your last name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    // If user clicked "I don't have email", don't show email section at all
    if (_email == 'noemail@gmail.com') {
      return const SizedBox.shrink(); // This removes the widget completely
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        Opacity(
          opacity: _isEmailEditable ? 1.0 : 0.6,
          child: AbsorbPointer(
            absorbing: !_isEmailEditable,
            child: EmailField(
              onSavedAndVerified: (value, isVerified) {
                _email = value;
                _validateEmail(isVerified);
                setState(() {
                  _isEmailVerified = isVerified;
                  if (isVerified) {
                    _isPhoneEditable = true;
                  }
                  _updateButtonState();
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: _isEmailEditable
              ? () {
                  setState(() {
                    _email = 'noemail@gmail.com';
                    _isEmailVerified = true;
                    _isPhoneEditable = true;
                    _updateButtonState();
                  });
                }
              : null,
          child: const Text("I don't have an email"),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Opacity(
          opacity: _isPhoneEditable ? 1.0 : 0.6,
          child: AbsorbPointer(
            absorbing: !_isPhoneEditable,
            child: MobileFieldSignup(
              onSavedAndVerified: (value, isVerified) {
                _mobileNumber = value;
                setState(() {
                  _isPhoneVerified = isVerified;
                  if (isVerified) {
                    // Immediately enable WhatsApp field when phone is verified
                    _isWhatsappEditable = true;
                    // Trigger validation for secondary phone if it has a value
                    if (_secondaryPhoneController.text.isNotEmpty) {
                      _formKey.currentState?.validate();
                    }
                  }
                  _updateButtonState();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryPhone() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Opacity(
          opacity: _isPhoneEditable ? 1.0 : 0.6,
          child: AbsorbPointer(
            absorbing: !_isPhoneEditable,
            child: TextFormField(
              controller: _secondaryPhoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                labelText: 'Secondary Phone Number (Optional)',
                hintText: 'Enter 10-digit secondary phone number',
                border: OutlineInputBorder(),
                counterText: '', // Hide character counter
              ),
              validator: _validateSecondaryPhoneNumber,
              onSaved: (value) {
                _secondaryPhoneNumber = value ?? '';
                _updateButtonState();
              },
              onChanged: (value) {
                _secondaryPhoneNumber = value;
                _updateButtonState();
                // Trigger real-time validation
                _formKey.currentState?.validate();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsAppFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: _isPhoneVerified
              ? () {
                  setState(() {
                    _sameAsPhone = !_sameAsPhone;
                    if (_sameAsPhone) {
                      _whatsappNumber = _mobileNumber;
                      _isWhatsappVerified = true;
                      // Automatically enable password fields when WhatsApp is verified
                      _isPasswordEditable = true;
                    } else {
                      _whatsappNumber = '';
                      _isWhatsappVerified = false;
                    }
                    _wasClicked = true;
                    _updateButtonState();
                  });
                }
              : null,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            side:
                BorderSide(color: _isPhoneVerified ? Colors.blue : Colors.grey),
          ),
          child: Text(
            _sameAsPhone
                ? 'WhatsApp number is same as phone number'
                : 'Use same number for WhatsApp?',
            style: TextStyle(
              fontSize: 14.0,
              color: _isPhoneVerified ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        if (_sameAsPhone)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _mobileNumber,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (!_sameAsPhone && _wasClicked)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'WhatsApp Number',
                hintText: 'Enter 10-digit WhatsApp number',
                border: OutlineInputBorder(),
                counterText: '', // Hide character counter
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter WhatsApp number';
                }
                if (value.length != 10) {
                  return 'WhatsApp number must be exactly 10 digits';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Please enter only numbers';
                }
                return null;
              },
              onSaved: (value) {
                _whatsappNumber = value ?? '';
              },
              onChanged: (value) {
                setState(() {
                  _whatsappNumber = value;
                  // Auto-verify when exactly 10 digits are entered
                  _isWhatsappVerified =
                      value.length == 10 && RegExp(r'^[0-9]+$').hasMatch(value);
                  if (_isWhatsappVerified) {
                    // Enable password fields when WhatsApp is manually verified
                    _isPasswordEditable = true;
                  }
                  _updateButtonState();
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Opacity(
          opacity: _isPasswordEditable ? 1.0 : 0.6,
          child: AbsorbPointer(
            absorbing: !_isPasswordEditable,
            child: PasswordField(
              onSaved: (value) {
                _password = value;
                _validatePassword(value);
              },
              onChanged: (value) {
                _validatePassword(value);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Opacity(
          opacity: _isPasswordEditable ? 1.0 : 0.6,
          child: AbsorbPointer(
            absorbing: !_isPasswordEditable,
            child: RePassword(
              onSaved: (value) {
                _rePassword = value;
                _validateRePassword(value);
              },
              onChanged: (value) {
                _validateRePassword(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleField() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Opacity(
          opacity: _isRoleEditable ? 1.0 : 0.6,
          child: AbsorbPointer(
            absorbing: !_isRoleEditable,
            child: RolesDropdown(
              onSaved: (value) {
                setState(() {
                  _role = value;
                  if (!_isPassenger) {
                    _isStaffFieldsEditable = true;
                  } else {
                    _isStaffFieldsEditable = false;
                    _isSubmitButtonEnabled = true;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaffFields() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Opacity(
          opacity: _isStaffFieldsEditable ? 1.0 : 0.6,
          child: AbsorbPointer(
            absorbing: !_isStaffFieldsEditable,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Zone dropdown
                Flexible(
                  child: ZoneDropdown(
                    onSaved: (value) {
                      _handleZoneSelection(value);
                    },
                  ),
                ),
                const SizedBox(width: 5),
                // Division dropdown
                Flexible(
                  child: DivisionDropdown(
                    divisions: division_codes
                      ..sort(
                          (a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
                    onSaved: (value) {
                      setState(() {
                        _division = value;
                        _depot = '';
                      });
                      getDepot();
                    },
                  ),
                ),
                const SizedBox(width: 5),
                // Depot dropdown
                Flexible(
                  child: DepotDropdown(
                    depots: depots
                      ..sort(
                          (a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
                    onSaved: (value) {
                      setState(() {
                        _depot = value;
                        _isSubmitButtonEnabled = true;
                      });
                      getTrainList();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Opacity(
          opacity: _isStaffFieldsEditable ? 1.0 : 0.6,
          child: AbsorbPointer(
            absorbing: !_isStaffFieldsEditable,
            child: EmpNumberField(
              onSaved: (value) {
                setState(() {
                  _empNumber = value;
                  _isSubmitButtonEnabled = true;
                });
              },
              userType: _role,
              empNumberList: EmpNumberList,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.9;

    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: _isSubmitButtonEnabled ? 1.0 : 0.6,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  fixedSize: Size(buttonWidth * 0.8, 50),
                ),
                onPressed: _isSubmitButtonEnabled ? _submitForm : null,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Request For Sign Up'),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.blue),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Information'),
                    content: const Text(
                      'Please complete all the fields in order. Each field will be enabled only after the previous field is properly filled and validated.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.9;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildNameFields(),
            _buildEmailField(),
            _buildPhoneField(),
            _buildWhatsAppFields(),
            _buildSecondaryPhone(),
            _buildPasswordFields(),
            _buildRoleField(),
            if (!_isPassenger || !_isRoleEditable) _buildStaffFields(),
            _buildSubmitButton(),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                fixedSize: Size(buttonWidth, 50),
              ),
              onPressed: () => Navigator.pushNamed(context, Routes.login),
              child: const Text(
                'Already have an account? login',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            privacyPolicyRender(context), // Added privacy policy widget
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
