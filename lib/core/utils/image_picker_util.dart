import 'dart:io';
import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/themes/app_theme.dart';

class ImagePickerUtil {
  static Future<File?> pickAndCropImage({
    required BuildContext context,
    required ImageSource source,
    required bool crop,
  }) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        return null;
      }
    }

    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;

      CroppedFile? croppedFile;

      if (crop) {
        croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: AppTheme.primaryColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: true),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
          ],
        );
      }

      if (croppedFile == null) return File(image.path);
      return File(croppedFile.path);
    } catch (e) {
      // Handle error
      return null;
    }
  }

  static void showImagePickerOptions({
    required BuildContext context,
    required WidgetRef ref,
    required Function(File?) onImagePicked,
    File? existingImage,
    bool crop = false,
  }) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () async {
                final image = await pickAndCropImage(
                    context: context, source: ImageSource.camera, crop: crop);
                onImagePicked(image);
                ref.read(navigationServiceProvider).goBack();
              },
              style: ButtonStyle(
                foregroundColor:
                    WidgetStateProperty.all(Theme.of(context).primaryColor),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/svg/camera.svg',
                    colorFilter: const ColorFilter.mode(
                        AppTheme.primaryColor, BlendMode.srcIn),
                    width: 20,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Camera',
                    style: TextStyle(
                        fontFamily: 'Blinker',
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () async {
                final image = await pickAndCropImage(
                    context: context, source: ImageSource.gallery, crop: crop);
                onImagePicked(image);
                ref.read(navigationServiceProvider).goBack();
              },
              style: ButtonStyle(
                foregroundColor:
                    WidgetStateProperty.all(Theme.of(context).primaryColor),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/svg/gallery.svg',
                    colorFilter: const ColorFilter.mode(
                        AppTheme.primaryColor, BlendMode.srcIn),
                    width: 20,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Gallery',
                    style: TextStyle(
                        fontFamily: 'Blinker',
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            if (existingImage != null) ...[
              const SizedBox(height: 8),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              FilledButton(
                onPressed: () {
                  onImagePicked(null);
                  ref.read(navigationServiceProvider).goBack();
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.red.withOpacity(0.2))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/svg/trash.svg',
                      colorFilter:
                          const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                      width: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Remove',
                      style: TextStyle(
                        fontFamily: 'Blinker',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
