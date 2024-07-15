import 'dart:io';

import 'package:bid_bazaar/features/add/widget/add_step1.dart';
import 'package:bid_bazaar/features/add/widget/add_step2.dart';
import 'package:bid_bazaar/features/add/widget/add_step3.dart';
import 'package:bid_bazaar/features/add/widget/add_step4.dart';
import 'package:flutter/widgets.dart';

class AddState {
  final String? id;
  final String? title;
  final List<File> images;
  final List<String> imageUrls;
  final String? category;
  final Map<String, dynamic>? details;
  final String? condition;
  final String? description;
  final int? price;
  final int? increment;
  final int? time;
  final int bidCount;
  final int seen;
  final List<int> bidPrices;
  final List<String> bidUsers;
  final List<String> reports;
  final List<String> saved;

  final int index;
  final List<Widget> listWidgets;
  final bool isLoading;

  AddState({
    this.id,
    this.title,
    this.images = const [],
    this.imageUrls = const [],
    this.category,
    this.details,
    this.condition,
    this.description,
    this.price,
    this.increment,
    this.time = 10,
    this.bidCount = 0,
    this.seen = 0,
    this.bidPrices = const [],
    this.bidUsers = const [],
    this.reports = const [],
    this.saved = const [],

    required this.index,
    required this.listWidgets,
    this.isLoading = false,
  });

  AddState.initialState()
      : id = null,
        title = null,
        images = [],
        imageUrls = [],
        category = null,
        details = {},
        condition = null,
        description = null,
        price = null,
        increment = null,
        time = 10,
        bidCount = 0,
        seen = 0,
        bidPrices = [],
        bidUsers = [],
        reports = [],
        saved = [],
        index = 0,
        isLoading = false,
        listWidgets = [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AddStep1(),
          ),
          const AddStep2(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AddStep3(),
          ),
          const AddStep4(),
        ];

  AddState copyWith({
    String? id,
    String? title,
    List<File>? images,
    List<String>? imageUrls,
    String? category,
    Map<String, dynamic>? details,
    String? condition,
    String? description,
    int? price,
    int? increment,
    int? time,
    int? bidCount,
    int? seen,
    List<int>? bidPrices,
    List<String>? bidUsers,
    List<String>? reports,
    List<String>? saved,
    int? index,
    bool? isLoading,
  }) {
    return AddState(
      id: id ?? this.id,
      title: title ?? this.title,
      images: images ?? this.images,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      details: details ?? this.details,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      price: price ?? this.price,
      increment: increment ?? this.increment,
      time: time ?? this.time,
      bidCount: bidCount ?? this.bidCount,
      seen: seen ?? this.seen,
      bidPrices: bidPrices ?? this.bidPrices,
      bidUsers: bidUsers ?? this.bidUsers,
      reports: reports ?? this.reports,
      saved: saved ?? this.saved,
      index: index ?? this.index,
      listWidgets: listWidgets,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
