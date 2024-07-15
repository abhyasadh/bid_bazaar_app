import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../config/themes/app_theme.dart';

class ImageSlider extends StatefulWidget {
  final List<dynamic> images;

  const ImageSlider({required this.images, super.key});

  @override
  State createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildUrlImage({required String imageUrl,}) {
    final width = MediaQuery.of(context).size.width - 40;
    final height = width * 3 / 4;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => SizedBox(
        height: height,
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: height,
        child: const Center(child: Icon(Iconsax.warning_2, color: AppTheme.errorColor,)),
      ),
      imageBuilder: (context, imageProvider) {
        return Image(
          image: imageProvider,
          fit: BoxFit.cover,
          width: width,
          height: height * 3 / 4,
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    final height = width * 3 / 4;

    if (widget.images.length == 1) {
      if (widget.images[0] is String) {
        return _buildUrlImage(imageUrl: widget.images[0]);
      } else {
        return Image.file(widget.images[0] as File, fit: BoxFit.cover, width: width, height: height * 3 / 4,);
      }
    } else {
      return Stack(
        children: [
          SizedBox(
            height: height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                if (widget.images[index] is String) {
                  return _buildUrlImage(imageUrl: widget.images[index]);
                } else {
                  return Image.file(widget.images[index] as File, fit: BoxFit.cover, width: width, height: height * 3 / 4,);
                }
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: width/2 - widget.images.length * 5 - 14,
            right: width/2 - widget.images.length * 5 - 14,
            child: Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: widget.images.map((media) {
                  int index = widget.images.indexOf(media);
                  return Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      );
    }
  }
}
