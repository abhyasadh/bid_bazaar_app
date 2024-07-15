import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../config/navigation/navigation_service.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/common/widgets/common_scaffold.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/custom_text_field.dart';
import '../../../core/utils/image_picker_util.dart';
import '../password/password_view.dart';
import 'details_view_model.dart';

class DetailsView extends ConsumerStatefulWidget {
  final User user;

  const DetailsView({super.key, required this.user});

  @override
  ConsumerState createState() => _DetailsViewState();
}

class _DetailsViewState extends ConsumerState<DetailsView> {
  final nameKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();

  final surnameKey = GlobalKey<FormState>();
  final surnameController = TextEditingController();
  final surnameFocusNode = FocusNode();

  final emailKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  File? _img;

  @override
  Widget build(BuildContext context) {
    final personalDetailsState = ref.watch(detailsViewModelProvider);

    return CustomScaffold(
      backButton: true,
      backFunction: () {
        widget.user.delete();
        ref.read(navigationServiceProvider).goBack();
      },
      title: 'Personal Details',
      textFields: [
        InkWell(
          onTap: () {
            ImagePickerUtil.showImagePickerOptions(context: context, ref: ref, onImagePicked: (image) {
              setState(() {
                _img = image;
                if (image != null) {
                  ref
                      .read(detailsViewModelProvider.notifier)
                      .uploadImage(_img!);
                }
              });
            }, existingImage: _img);
          },
          child: Stack(
            children: [
              SizedBox(
                height: 116,
                width: 116,
                child: _img != null
                    ? CircleAvatar(
                        radius: 58, backgroundImage: FileImage(_img!))
                    : Container(
                        width: 116,
                        height: 116,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            borderRadius: BorderRadius.circular(58)),
                        child: SvgPicture.asset(
                          'assets/images/svg/profile-circle.svg',
                        ),
                      ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 34,
                  height: 34,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.grey,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/svg/camera.svg',
                    colorFilter: const ColorFilter.mode(
                        Color(0xffffffff), BlendMode.srcIn),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: nameKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Expanded(
                child: CustomTextField(
                  label: 'Name',
                  hintText: 'First Name...',
                  icon: Iconsax.user,
                  controller: nameController,
                  node: nameFocusNode,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name can\'t be empty!';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.trim() != value) {
                      nameController.text = value.trim();
                      surnameFocusNode.requestFocus();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Form(
              key: surnameKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Expanded(
                child: CustomTextField(
                    label: ' ',
                    hintText: 'Last Name...',
                    icon: Iconsax.user,
                    controller: surnameController,
                    node: surnameFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name can\'t be empty!';
                      }
                      return null;
                    }),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Form(
          key: emailKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextField(
            label: 'Email',
            hintText: 'Enter Your Email...',
            icon: Iconsax.sms,
            controller: emailController,
            keyBoardType: TextInputType.emailAddress,
            node: emailFocusNode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email can\'t be empty!';
              } else {
                RegExp regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!regex.hasMatch(value)) {
                  return 'Invalid email address!';
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
          bool validated = true;
          if (!nameKey.currentState!.validate()) {
            validated = false;
          }
          if (!surnameKey.currentState!.validate()) {
            validated = false;
          }
          if (!emailKey.currentState!.validate()) {
            validated = false;
          }
          if (validated) {
            ref.read(navigationServiceProvider).navigateTo(
                    page: PasswordView(
                  purpose: Purpose.signup,
                  user: widget.user,
                  img: _img,
                  firstName: nameController.text,
                  lastName: surnameController.text,
                  email: emailController.text,
                ));
          }
        },
        child: personalDetailsState.isLoading
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
