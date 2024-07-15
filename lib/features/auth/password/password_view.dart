import 'dart:io';

import 'package:bid_bazaar/core/common/widgets/common_scaffold.dart';
import 'package:bid_bazaar/features/auth/password/password_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/custom_text_field.dart';

class PasswordView extends ConsumerStatefulWidget {
  final Purpose purpose;
  final User user;
  final File? img;
  final String? firstName;
  final String? lastName;
  final String? email;
  const PasswordView({required this.purpose, required this.user, this.img, this.firstName, this.lastName, this.email, super.key});

  @override
  ConsumerState createState() => _PasswordViewState();
}

class _PasswordViewState extends ConsumerState<PasswordView> {
  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();

  final cPasswordKey = GlobalKey<FormState>();
  final cPasswordController = TextEditingController();
  final cPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final passwordState = ref.watch(passwordViewModelProvider);
    return CustomScaffold(
      backButton: true,
      title: widget.purpose == Purpose.signup ? 'Create a Password'  : 'Enter New Password',
      textFields: [
        Form(
          key: passwordKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextField(
            label: 'New Password',
            hintText: 'Enter Your Password...',
            icon: Iconsax.lock,
            controller: passwordController,
            obscureText: true,
            node: passwordFocusNode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password can\'t be empty!';
              }
              const requiredLength = 8;
              final missingRequirements = <String>[];

              if (value.length < requiredLength) {
                final missingLength = requiredLength - value.length;
                missingRequirements
                    .add('At least $missingLength more characters');
              }

              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                missingRequirements.add('An uppercase letter');
              }
              if (!RegExp(r'[a-z]').hasMatch(value)) {
                missingRequirements.add('A lowercase letter');
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                missingRequirements.add('A number');
              }
              if (!RegExp(r'[@$!%*?&]').hasMatch(value)) {
                missingRequirements.add('A special character');
              }

              if (missingRequirements.isEmpty) {
                return null;
              } else {
                return 'The password is missing:\n${missingRequirements.join(',\n')}';
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Form(
          key: cPasswordKey,
          child: CustomTextField(
            label: 'Confirm Password',
            hintText: 'Confirm Password...',
            icon: Iconsax.lock,
            controller: cPasswordController,
            obscureText: true,
            node: cPasswordFocusNode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password can\'t be empty!';
              } else if (value != passwordController.text) {
                return 'Passwords don\'t match!';
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
      button: CustomButton(
        onPressed: () {
          bool validated = true;
          if (!passwordKey.currentState!.validate()) {
            validated = false;
          }
          if (!cPasswordKey.currentState!.validate()) {
            validated = false;
          }
          if (validated) {
            widget.purpose == Purpose.signup ?
            ref.read(passwordViewModelProvider.notifier).register(user: widget.user, img: widget.img, firstName: widget.firstName, lastName: widget.lastName, email: widget.email, password: passwordController.text) :
            ref.read(passwordViewModelProvider.notifier).reset(user: widget.user, password: passwordController.text);
          }
        },
        child: passwordState.isLoading
            ? const ButtonCircularProgressIndicator()
            : const Text(
                'CONFIRM',
                style: TextStyle(
                  fontFamily: 'Blinker',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
