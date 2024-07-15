import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/core/common/widgets/common_scaffold.dart';
import 'package:bid_bazaar/features/auth/phone/phone_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/custom_text_field.dart';

class PhoneView extends ConsumerStatefulWidget {
  final Purpose purpose;

  const PhoneView(this.purpose, {super.key});

  @override
  ConsumerState createState() => _PhoneViewState();
}

class _PhoneViewState extends ConsumerState<PhoneView> {
  final phoneKey = GlobalKey<FormState>();
  final phoneController = TextEditingController(text: "9860267909");
  final phoneFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final phoneState = ref.watch(phoneViewModelProvider);

    return CustomScaffold(
      backButton: true,
      title: widget.purpose == Purpose.signup
          ? 'Enter Your Number'
          : 'Forgot Password?',
      subtitle: widget.purpose == Purpose.signup
          ? 'An OTP will be sent to this number for verification.'
          : 'Enter your registered number for the OTP.',
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
            focusOnLoad: true,
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
          height: 20,
        ),
      ],
      button: CustomButton(
        onPressed: () {
          if (phoneKey.currentState!.validate()) {
            ref.read(phoneViewModelProvider.notifier).sendOTP(phoneController.text, widget.purpose);
          }
        },
        child: phoneState.isLoading
            ? const ButtonCircularProgressIndicator()
            : const Text(
          'CONTINUE',
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
