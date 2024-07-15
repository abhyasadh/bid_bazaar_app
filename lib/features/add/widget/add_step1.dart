import 'dart:io';

import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/widgets/custom_button.dart';
import 'package:bid_bazaar/core/common/widgets/custom_text_field.dart';
import 'package:bid_bazaar/features/add/add_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'dashed_border_container/dashed_border_container.dart';
import '../../../core/utils/image_picker_util.dart';

class AddStep1 extends ConsumerStatefulWidget {
  const AddStep1({super.key});

  @override
  ConsumerState createState() => _AddStep1State();
}

class _AddStep1State extends ConsumerState<AddStep1> {
  late TextEditingController titleController;
  final titleNode = FocusNode();
  final titleKey = GlobalKey<FormState>();

  File? _img;
  bool flagged = false;

  @override
  void initState() {
    super.initState();
    final title = ref.read(addViewModelProvider).title;
    titleController = TextEditingController(text: title);
  }

  Future<void> _pickImage(BuildContext context) async {
    ImagePickerUtil.showImagePickerOptions(context: context, ref: ref, onImagePicked: (image) {
      ref.read(addViewModelProvider.notifier).addImage(image!);
    }, existingImage: _img, crop: true);
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(addViewModelProvider).images;
    final oldImages = ref.watch(addViewModelProvider).imageUrls;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: titleKey,
            child: CustomTextField(
              controller: titleController,
              node: titleNode,
              hintText: 'Product Name...',
              icon: Iconsax.text,
              label: 'Title',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Product name can\'t be empty!';
                }
                return null;
              },
              onChanged: (value){
                ref.read(addViewModelProvider.notifier).copyWith(title: value);
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: Text(
              'Images',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...oldImages.map((imageUrl) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Image.network(
                        imageUrl,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        height: (MediaQuery.of(context).size.width / 3 - 20) * 3 / 4,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () {
                            ref.read(addViewModelProvider.notifier).removeImage(Right(imageUrl));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.black54,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 16,),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              ...images.map((imagePath) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Image.file(
                        imagePath,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        height: (MediaQuery.of(context).size.width / 3 - 20) * 3 / 4,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () {
                            ref.read(addViewModelProvider.notifier).removeImage(Left(imagePath));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.black54,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 16,),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (images.length + oldImages.length < 5)
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 20,
                  height: (MediaQuery.of(context).size.width / 3 - 20) * 3 / 4,
                  child: InkWell(
                    onTap: () => _pickImage(context),
                    child: DashedBorderContainer(
                      borderColor: Colors.grey,
                      borderWidth: 2.0,
                      dashWidth: 6.0,
                      dashSpace: 5.0,
                      child: Column(
                        children: [
                          Expanded(
                            child: SvgPicture.asset(
                              'assets/images/svg/add.svg',
                              colorFilter: const ColorFilter.mode(
                                  Colors.grey, BlendMode.srcIn),
                            ),
                          ),
                          Text(
                            "${images.length + 1} of 5 Images",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Visibility(
            visible: flagged && (images.isEmpty || oldImages.isEmpty),
            child: const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 14),
              child: Text('Minimum of 1 image is required!', style: TextStyle(fontSize: 12, color: AppTheme.errorColor),),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          CustomButton(
            onPressed: () {
              if (titleKey.currentState!.validate() && (images.isNotEmpty || oldImages .isNotEmpty)) {
                ref.read(addViewModelProvider.notifier).copyWith(title: titleController.text);
                ref.read(addViewModelProvider.notifier).changeIndex(1);
              } else if (images.isEmpty) {
                setState(() {
                  flagged = true;
                });
              }
            },
            child: const Text(
              'NEXT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
