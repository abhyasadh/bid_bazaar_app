import 'package:bid_bazaar/core/common/widgets/custom_appbars.dart';
import 'package:bid_bazaar/features/settings/change_password/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/custom_text_field.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final oldPasswordKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final oldPasswordFocusNode = FocusNode();

  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();

  final cPasswordKey = GlobalKey<FormState>();
  final cPasswordController = TextEditingController();
  final cPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BranchPageAppBar('Change Password'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Form(
                key: oldPasswordKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextField(
                  label: 'Old Password',
                  hintText: 'Enter Current Password...',
                  icon: Iconsax.lock,
                  controller: oldPasswordController,
                  obscureText: true,
                  node: oldPasswordFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password can\'t be empty!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: passwordKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextField(
                  label: 'New Password',
                  hintText: 'Enter New Password...',
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
                height: 50,
              ),
              CustomButton(
                onPressed: () {
                  bool validated = true;
                  if (!oldPasswordKey.currentState!.validate()) {
                    validated = false;
                  }
                  if (!passwordKey.currentState!.validate()) {
                    validated = false;
                  }
                  if (!cPasswordKey.currentState!.validate()) {
                    validated = false;
                  }
                  if (validated) {
                    ref
                        .read(changePasswordViewModelProvider.notifier)
                        .changePassword(oldPasswordController.text,
                            passwordController.text);
                  }
                },
                child: ref.watch(changePasswordViewModelProvider).isLoading
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
            ],
          ),
        ),
      ),
    );
  }
}
