import 'package:bid_bazaar/features/auth/phone/phone_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/widgets/common_scaffold.dart';
import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/core/common/widgets/custom_button.dart';
import 'package:bid_bazaar/core/common/widgets/custom_text_field.dart';
import 'package:iconsax/iconsax.dart';

import 'login_view_model.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final phoneKey = GlobalKey<FormState>();
  late TextEditingController phoneController = TextEditingController(text: '');
  final phoneFocusNode = FocusNode();

  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController(text: null);
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    ref.read(loginViewModelProvider.notifier).updateNumber(phoneController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loginState = ref.watch(loginViewModelProvider);

    return CustomScaffold(
      logo: true,
      title: 'Welcome Back!',
      textFields: [
        Form(
          key: phoneKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextField(
            label: 'Phone',
            hintText: 'Enter Your Phone Number...',
            icon: Iconsax.call,
            controller: phoneController,
            keyBoardType: TextInputType.phone,
            node: phoneFocusNode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number can\'t be empty!';
              } else {
                RegExp regex = RegExp(
                    r'^(\+\d{1,3}\s?)?1?-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
                if (!regex.hasMatch(value)) {
                  return 'Invalid phone number!';
                }
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Form(
          key: passwordKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextField(
            label: 'Password',
            hintText: 'Enter Your Password...',
            icon: Iconsax.lock,
            controller: passwordController,
            obscureText: true,
            node: passwordFocusNode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password can\'t be empty!';
              }
              return null;
            },
          ),
        ),
      ],
      afterTextFields: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              InkWell(
                onTap: () {
                  ref.read(loginViewModelProvider.notifier).rememberMe();
                },
                child: Container(
                  width: 16.0,
                  height: 16.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      width: 1.5,
                      color: loginState.rememberMe
                          ? AppTheme.primaryColor
                          : Colors.grey,
                    ),
                    color: loginState.rememberMe
                        ? AppTheme.primaryColor
                        : Colors.white.withOpacity(0),
                  ),
                  child: loginState.rememberMe
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12.0,
                        )
                      : Container(),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Remember Me',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(navigationServiceProvider)
                  .navigateTo(page: const PhoneView(Purpose.reset));
            },
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(16.0),
              ),
            ),
            child: const Text(
              'Recover Password',
              style: TextStyle(
                color: AppTheme.linkColor,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.linkColor,
              ),
            ),
          )
        ],
      ),
      buttonRow: Row(
        children: [
          Expanded(
            child: CustomButton(
              onPressed: () {
                bool validated = true;
                if (!phoneKey.currentState!.validate()) {
                  validated = false;
                }
                if (!passwordKey.currentState!.validate()) {
                  validated = false;
                }
                if (validated) {
                  ref
                      .read(loginViewModelProvider.notifier)
                      .login(phoneController.text, passwordController.text);
                }
              },
              child: loginState.isLoading
                  ? const ButtonCircularProgressIndicator()
                  : const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          if (loginState.biometric)...{
            const SizedBox(width: 8,),
            CustomButton(
                onPressed: () {
                  ref.read(loginViewModelProvider.notifier).authenticateWithBiometrics();
                },
                child: Icon(Icons.fingerprint, color: Theme.of(context).colorScheme.tertiary, size: 28,)
            ),
          }
        ],
      ),
      afterButton: [
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account?  ',
              ),
              InkWell(
                onTap: () {
                  ref
                      .read(navigationServiceProvider)
                      .navigateTo(page: const PhoneView(Purpose.signup));
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: AppTheme.linkColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.linkColor,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
