import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/core/common/widgets/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/custom_text_field.dart';
import 'otp_view_model.dart';

class OTPView extends ConsumerStatefulWidget {
  final String phone;
  final Purpose purpose;
  final String? verificationId;

  const OTPView(
      {required this.phone,
      required this.purpose,
      this.verificationId,
      super.key});

  @override
  ConsumerState createState() => _OTPViewState();
}

class _OTPViewState extends ConsumerState<OTPView> {
  final List<GlobalKey<FormState>> keys =
      List.generate(6, (_) => GlobalKey<FormState>());
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> nodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(otpViewModelProvider.notifier).startCountdownTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    var otpState = ref.watch(otpViewModelProvider);

    return CustomScaffold(
      title: 'Enter the OTP',
      subtitle: 'OTP was sent to ${widget.phone}.',
      subtitleLink: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Change',
          style: TextStyle(
            fontFamily: 'Blinker',
            color: Color(0xff37B5DF),
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w600,
            decorationColor: Color(0xff37B5DF),
          ),
        ),
      ),
      textFields: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) => Form(
              key: keys[index],
              child: Expanded(
                child: Focus(
                  onFocusChange: (focus) {
                    if (focus) {
                      for (int i = 0; i < 6; i++) {
                        if (controllers[i].text == '') {
                          nodes[i].requestFocus();
                          return;
                        }
                      }
                    }
                  },
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace &&
                        index > 0 &&
                        controllers[index].text == '') {
                      controllers[index - 1].text = '';
                      nodes[index - 1].requestFocus();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: CustomTextField(
                    label: index == 0 ? 'OTP' : '',
                    keyBoardType: TextInputType.number,
                    focusOnLoad: index == 0,
                    controller: controllers[index],
                    node: nodes[index],
                    validator: (value) {
                      return null;
                    },
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 5) {
                          nodes[index + 1].requestFocus();
                        } else {
                          nodes[index].unfocus();
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          )
              .expand((widget) => [
                    widget,
                    if (widget.key != keys.last) const SizedBox(width: 8),
                  ])
              .toList(),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
      button: CustomButton(
        onPressed: () async {
          String otp = '';
          for (TextEditingController controller in controllers) {
            otp += controller.text;
          }

          bool? success = await ref
              .watch(otpViewModelProvider.notifier)
              .verifyOTP(widget.phone, widget.verificationId!, otp, widget.purpose);
          if (success != null && !success) {
            for (TextEditingController controller in controllers) {
              controller.text = '';
            }
          }
        },
        child: otpState.isLoading
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
      afterButton: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 26,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                otpState.isResendButtonDisabled
                    ? 'OTP Expires in  '
                    : 'OTP Expired!  ',

                style: const TextStyle(
                  fontFamily: 'Blinker',
                ),
              ),
              InkWell(
                onTap: otpState.isResendButtonDisabled
                    ? null
                    : () {
                        ref.read(otpViewModelProvider.notifier).resetTimer();
                        ref.read(otpViewModelProvider.notifier).startCountdownTimer();
                      },
                child: Text(
                  otpState.isResendButtonDisabled
                      ? '${otpState.timerCountDown} s'
                      : 'Resend?',
                  style: TextStyle(
                    fontFamily: 'Blinker',
                    color: otpState.isResendButtonDisabled
                        ? Colors.grey
                        : const Color(0xff37B5DF),
                    decoration: otpState.isResendButtonDisabled
                        ? TextDecoration.none
                        : TextDecoration.underline,
                    decorationColor: const Color(0xff37B5DF),
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
