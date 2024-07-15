import 'dart:io';

import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/widgets/custom_appbars.dart';
import 'package:bid_bazaar/core/common/widgets/custom_button.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../config/navigation/navigation_service.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/common/messages/snackbar.dart';
import '../../../core/common/widgets/custom_text_field.dart';
import '../../../core/utils/biometric_setting.dart';
import '../../../core/utils/image_picker_util.dart';
import '../../bottom_navigation/nav_view_model.dart';
import 'account_settings_view_model.dart';

class AccountSettingsView extends ConsumerStatefulWidget {
  const AccountSettingsView({super.key});

  @override
  ConsumerState createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends ConsumerState<AccountSettingsView> {
  final nameKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  final nameFocusNode = FocusNode();

  final surnameKey = GlobalKey<FormState>();
  late TextEditingController surnameController;
  final surnameFocusNode = FocusNode();

  final emailKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  final emailFocusNode = FocusNode();

  Either<File?, String?>? _img;
  late bool _biometricLogin;

  @override
  void initState() {
    super.initState();
    _biometricLogin = ref.read(getBiometricSettingProvider);

    final state = ref.read(navViewModelProvider);

    nameController =
        TextEditingController(text: state.userData?['firstName'] ?? '');
    surnameController =
        TextEditingController(text: state.userData?['lastName'] ?? '');
    emailController =
        TextEditingController(text: state.userData?['email'] ?? '');
    if (state.userData?['profileImageUrl'] != null) {
      _img = Right(state.userData?['profileImageUrl']);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();

    nameFocusNode.dispose();
    surnameFocusNode.dispose();
    emailFocusNode.dispose();

    super.dispose();
  }

  void _onImagePicked(File? image) {
    setState(() {
      _img = Left(image);
      if (image != null) {
        ref.read(accountSettingsViewModelProvider.notifier).uploadImage(image);
      }
    });
  }

  void _onSaveChanges() {
    if (nameKey.currentState?.validate() ?? false) {
      ref.read(accountSettingsViewModelProvider.notifier).updateUser(
            image: _img,
            firstName: nameController.text,
            lastName: surnameController.text,
            email: emailController.text,
          );
      setState(() {
        ref.read(accountSettingsViewModelProvider.notifier).markAsChanged();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountSettingsViewModelProvider);

    return Scaffold(
      appBar: const BranchPageAppBar('Account Settings'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  ImagePickerUtil.showImagePickerOptions(
                    context: context,
                    ref: ref,
                    onImagePicked: _onImagePicked,
                    existingImage: _img?.fold((l) => l, (r) => null),
                  );
                },
                child: Stack(
                  children: [
                    SizedBox(
                      height: 116,
                      width: 116,
                      child: _img != null
                          ? CircleAvatar(
                              radius: 58,
                              backgroundImage: _img?.fold(
                                (l) => FileImage(l!),
                                (r) => NetworkImage(r!) as ImageProvider,
                              ),
                            )
                          : Container(
                              width: 116,
                              height: 116,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                borderRadius: BorderRadius.circular(58),
                              ),
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
                          ref.read(accountSettingsViewModelProvider.notifier).markAsChanged(fName: value);
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
                        },
                        onChanged: (value) {
                          ref.read(accountSettingsViewModelProvider.notifier).markAsChanged(lName: value);
                        },
                      ),
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
                  onChanged: (value) {
                    ref.read(accountSettingsViewModelProvider.notifier).markAsChanged(email: value);
                  },
                ),
              ),
              if (state.isChanged) ...{
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                  onPressed: _onSaveChanges,
                  child: state.isLoading ? const ButtonCircularProgressIndicator() : const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontFamily: 'Blinker',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              },
              const SizedBox(
                height: 30,
              ),
              ListTile(
                title: const Text(
                  'Change Password',
                  style: TextStyle(
                    fontFamily: 'Blinker',
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                ),
                contentPadding: const EdgeInsets.only(right: 18, left: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  ref
                      .read(navigationServiceProvider)
                      .navigateTo(routeName: AppRoutes.changePasswordRoute);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                title: const Text(
                  'Biometric Login',
                  style: TextStyle(
                    fontFamily: 'Blinker',
                    fontSize: 16,
                  ),
                ),
                trailing: Switch(
                  value: _biometricLogin,
                  onChanged: (bool value) {
                    if (value && state.canCheckBiometrics) {
                      final passwordKey = GlobalKey<FormState>();
                      final passwordController = TextEditingController();
                      final passwordFocusNode = FocusNode();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              titlePadding: EdgeInsets.zero,
                              actionsPadding: const EdgeInsets.only(bottom: 14),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              clipBehavior: Clip.hardEdge,
                              shadowColor:
                              Theme.of(context).colorScheme.tertiary,
                              title: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 18),
                                child: Text(
                                  'Confirmation',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontFamily: 'Blinker',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Form(
                                      key: passwordKey,
                                      child: CustomTextField(
                                        label: 'Password',
                                        hintText: 'Enter Your Password...',
                                        icon: Icons.lock_outline_rounded,
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
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontFamily: 'Blinker',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      User currentUser = FirebaseAuth.instance.currentUser!;

                                      final userCredential = EmailAuthProvider
                                          .credential(
                                        email: '${ref
                                            .read(navViewModelProvider)
                                            .userData?['phone']}@bidbazaar.com',
                                        password: passwordController.text,
                                      );

                                      await currentUser.reauthenticateWithCredential(userCredential).then((value){
                                        ref
                                            .read(getBiometricSettingProvider
                                            .notifier)
                                            .updateBiometricSetting([
                                          'true',
                                          ref
                                              .read(navViewModelProvider)
                                              .userData?['phone'],
                                          passwordController.text
                                        ]);
                                        setState(() {
                                          _biometricLogin = true;
                                        });
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      String? message;

                                      if (e.code=='invalid-credential'){
                                        message = 'Incorrect Password!';
                                      } else if (e.code == 'network-request-failed'){
                                        message = 'No Internet Connection!';
                                      } else if (e.code == 'too-many-requests'){
                                        message = 'All requests from this device are blocked due to unusual activity. Please try again later!';
                                      }

                                      showSnackBar(
                                          context:
                                          ref.read(navigationServiceProvider).navigatorKey.currentContext!,
                                          error: true,
                                          message: message ?? e.message ?? 'Could not set up biometrics!'
                                      );
                                    }
                                    ref.read(navigationServiceProvider).goBack();
                                  },
                                  child: Text(
                                    'Proceed',
                                    style: TextStyle(
                                      fontFamily: 'Blinker',
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ]
                          );
                        },
                      );
                    } else if (!state.canCheckBiometrics) {
                      showSnackBar(
                          message: 'An error occurred!',
                          context: context,
                          error: true);
                    } else {
                      setState(() {
                        _biometricLogin = false;
                      });
                      ref
                          .read(getBiometricSettingProvider.notifier)
                          .updateBiometricSetting(['false']);
                    }
                  },
                  activeTrackColor: AppTheme.primaryColor,
                  inactiveTrackColor: Colors.grey[700],
                  // inactiveTrackColor: Theme.of(context).colorScheme.primary,
                  thumbColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                  trackOutlineColor: WidgetStateColor.transparent,
                ),
                contentPadding: const EdgeInsets.only(left: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
