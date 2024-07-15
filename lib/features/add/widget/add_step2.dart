import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/widgets/custom_button.dart';
import 'package:bid_bazaar/core/common/widgets/custom_dropdown_field.dart';
import 'package:bid_bazaar/core/common/widgets/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../add_view_model.dart';

class AddStep2 extends ConsumerStatefulWidget {
  const AddStep2({super.key});

  @override
  ConsumerState createState() => _AddStep2State();
}

class _AddStep2State extends ConsumerState<AddStep2> {
  late TextEditingController descController;
  final descNode = FocusNode();
  final descKey = GlobalKey<FormState>();

  final categoryKey = GlobalKey<FormState>();
  final conditionKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> fields = [];
  List<TextEditingController> controllers = [];
  List<FocusNode> nodes = [];
  List<GlobalKey<FormState>> keys = [];

  @override
  void initState() {
    super.initState();
    final category = ref.read(addViewModelProvider).category;
    if (category != null) {
      initializeFields(category);
    }
    final description = ref.read(addViewModelProvider).description;
    descController = TextEditingController(text: description);
  }

  @override
  void didUpdateWidget(covariant AddStep2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    final category = ref.read(addViewModelProvider).category;
    if (category != null) {
      initializeFields(category);
    }
  }

  void initializeFields(String category) {
    fields = getCategorySpecificFields(category);
    controllers = List.generate(fields.length, (index) => TextEditingController(text: ref.read(addViewModelProvider).details?[fields[index]['label']].toString() ?? ''));
    nodes = List.generate(fields.length, (index) => FocusNode());
    keys = List.generate(fields.length, (index) => GlobalKey<FormState>());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: categoryKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: CustomDropdownField(
                label: 'Category',
                hintText: 'Select Category...',
                icon: Iconsax.category,
                items: const [
                  'Electronics',
                  'Vehicles',
                  'Jewelry',
                  'Real Estate',
                  'Furniture',
                  'Fashion',
                  'Antiques',
                  'Collectibles',
                  'Sculptures',
                  'Decor',
                  'Drinks',
                  'Art',
                  'Memorabilia'
                ],
                initiallySelected: ref.read(addViewModelProvider).category,
                width: MediaQuery.of(context).size.width - 40,
                validator: (value) {
                  if (value == null) {
                    return "Please select a category!";
                  }
                  return null;
                },
                onChanged: (value) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      Future.delayed(const Duration(milliseconds: 1300), () {
                        Navigator.of(context).pop();
                        ref
                            .read(addViewModelProvider.notifier)
                            .copyWith(category: value, details: {});
                        initializeFields(value!);
                      });

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(25),
                            width: 90,
                            height: 90,
                            child: const CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            if (ref.watch(addViewModelProvider).category != null && ref.watch(addViewModelProvider).category != 'Collectibles' && ref.watch(addViewModelProvider).category != 'Memorabilia') ...{
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Specifications',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 8),
                child: Text(
                  '(Fields with * are compulsory!)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.withOpacity(0.7)),
                ),
              ),
              CustomTable(category: ref.read(addViewModelProvider).category!, fields: fields, controllers: controllers, nodes: nodes, keys: keys,)
            },
            const SizedBox(
              height: 16,
            ),
            Form(
              key: conditionKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: CustomDropdownField(
                label: 'Condition',
                hintText: 'Select Condition...',
                icon: Iconsax.award,
                items: const ['Brand New', 'Like New', 'Used', 'Not Working'],
                width: MediaQuery.of(context).size.width - 40,
                initiallySelected: ref.read(addViewModelProvider).condition,
                onChanged: (value) {
                  ref
                      .read(addViewModelProvider.notifier)
                      .copyWith(condition: value);
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select the condition!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 8),
              child: Text(
                'Description',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Form(
                key: descKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: descController,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Theme.of(context).primaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide an item description!';
                    }
                    return null;
                  },
                  focusNode: descNode,
                  maxLines: null,
                  minLines: 4,
                  decoration: InputDecoration(
                    hintText: 'A short description of the product...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTapOutside: (e) {
                    descNode.unfocus();
                  },
                  onChanged: (value){
                    ref.read(addViewModelProvider.notifier).copyWith(description: value);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomButton(
              onPressed: () {
                bool isCategoryValid = categoryKey.currentState?.validate() ?? false;
                bool isConditionValid = conditionKey.currentState?.validate() ?? false;
                bool isDescriptionValid = descKey.currentState?.validate() ?? false;
                bool areSpecificationsValid = true;

                for (GlobalKey<FormState> key in keys){
                  bool value = key.currentState!.validate();
                  if (!value){
                    areSpecificationsValid = false;
                  }
                }

                if (isCategoryValid && isConditionValid && isDescriptionValid && areSpecificationsValid) {
                  ref.read(addViewModelProvider.notifier).changeIndex(2);
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
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getCategorySpecificFields(String category) {
    switch (category) {
      case 'Electronics':
        return [
          {
            'label': 'Brand',
            'type': 'text',
            'hint': 'Apple',
            'required': true,
          },
          {
            'label': 'Model',
            'type': 'text',
            'hint': 'iPhone 15 Pro Max',
            'required': true,
          },
          {
            'label': 'Manufacture Year',
            'type': 'number',
            'hint': '2023',
            'required': false,
          },
          {
            'label': 'Warranty Available',
            'type': 'text',
            'hint': 'Yes',
            'required': false,
          },
        ];
      case 'Vehicles':
        return [
          {
            'label': 'Brand',
            'type': 'text',
            'hint': 'Hyundai',
            'required': true,
          },
          {
            'label': 'Model',
            'type': 'text',
            'hint': 'Creta',
            'required': true,
          },
          {
            'label': 'Manufacture Year',
            'type': 'number',
            'hint': '2020',
            'required': true,
          },
          {
            'label': 'Odometer (KM)',
            'type': 'number',
            'hint': '60,000',
            'required': true,
          },
          {
            'label': 'Fuel Type',
            'type': 'dropdown',
            'options': ['Petrol', 'Diesel', 'Electric', 'Hybrid'],
            'hint': 'Petrol',
            'required': true,
          },
          {
            'label': 'Transmission',
            'type': 'dropdown',
            'options': ['Manual', 'Automatic'],
            'hint': 'Manual',
            'required': true,
          },
        ];
      case 'Jewelry':
        return [
          {
            'label': 'Purchased From',
            'type': 'text',
            'hint': 'Dev Corner',
            'required': true,
          },
          {
            'label': 'Material',
            'type': 'text',
            'hint': 'Gold',
            'required': true,
          },
          {
            'label': 'Weight',
            'type': 'text',
            'hint': '15 tola',
            'required': true,
          },
          {
            'label': 'Gemstones\n(if any)',
            'type': 'text',
            'hint': 'Diamond',
            'required': false,
          },
        ];
      case 'Real Estate':
        return [
          {
            'label': 'Location',
            'type': 'text',
            'hint': 'Kathmandu',
            'required': true,
          },
          {
            'label': 'Property Type',
            'type': 'dropdown',
            'options': ['House', 'Apartment', 'Land', 'Commercial'],
            'hint': 'House',
            'required': true,
          },
          {
            'label': 'Size',
            'type': 'text',
            'hint': '8 Aana',
            'required': true,
          },
          {
            'label': 'Bedrooms',
            'type': 'number',
            'hint': '3',
            'required': false,
          },
          {
            'label': 'Bathrooms',
            'type': 'number',
            'hint': '2',
            'required': false,
          },
          {
            'label': 'Year Built',
            'type': 'number',
            'hint': '2005',
            'required': false,
          },
          {
            'label': 'Additional Amenities',
            'type': 'text',
            'hint': 'Swimming Pool, Gym',
            'required': false,
          },
        ];
      case 'Furniture':
        return [
          {
            'label': 'Brand',
            'type': 'text',
            'hint': 'Ikea',
            'required': false,
          },
          {
            'label': 'Material',
            'type': 'text',
            'hint': 'Wood',
            'required': true,
          },
          {
            'label': 'Dimensions',
            'type': 'text',
            'hint': '200cm x 150cm x 75cm',
            'required': false,
          },
        ];
      case 'Fashion':
        return [
          {
            'label': 'Brand',
            'type': 'text',
            'hint': 'Gucci',
            'required': true,
          },
          {
            'label': 'Size',
            'type': 'dropdown',
            'options': ['XS', 'S', 'M', 'L', 'XL'],
            'hint': 'M',
            'required': true,
          },
          {
            'label': 'Material',
            'type': 'text',
            'hint': 'Cotton',
            'required': true,
          },
        ];
      case 'Antiques':
        return [
          {
            'label': 'Age',
            'type': 'number',
            'hint': '100',
            'required': true,
          },
          {
            'label': 'Origin',
            'type': 'text',
            'hint': 'France',
            'required': false,
          },
        ];
      case 'Sculptures':
        return [
          {
            'label': 'Artist',
            'type': 'text',
            'hint': 'Auguste Rodin',
            'required': false,
          },
          {
            'label': 'Material',
            'type': 'text',
            'hint': 'Bronze',
            'required': true,
          },
          {
            'label': 'Dimensions',
            'type': 'text',
            'hint': '50cm x 30cm x 20cm',
            'required': true,
          },
        ];
      case 'Decor':
        return [
          {
            'label': 'Material',
            'type': 'text',
            'hint': 'Ceramic',
            'required': true,
          },
        ];
      case 'Drinks':
        return [
          {
            'label': 'Brand',
            'type': 'text',
            'hint': 'Jack Daniels',
            'required': true,
          },
          {
            'label': 'Type',
            'type': 'text',
            'hint': 'Whiskey',
            'required': true,
          },
          {
            'label': 'Volume (ml)',
            'type': 'number',
            'hint': '750',
            'required': true,
          },
          {
            'label': 'Age (Years)',
            'type': 'number',
            'hint': '10',
            'required': true,
          },
          {
            'label': 'Alcohol %',
            'type': 'number',
            'hint': '40',
            'required': true,
          },
        ];
      case 'Art':
        return [
          {
            'label': 'Title',
            'type': 'text',
            'hint': 'Mona Lisa',
            'required': true,
          },
          {
            'label': 'Artist',
            'type': 'text',
            'hint': 'Leonardo da Vinci',
            'required': true,
          },
          {
            'label': 'Year',
            'type': 'number',
            'hint': '1503',
            'required': false,
          },
          {
            'label': 'Medium',
            'type': 'text',
            'hint': 'Oil on Wood Panel',
            'required': true,
          },
          {
            'label': 'Dimensions',
            'type': 'text',
            'hint': '73.7 cm x 92.1 cm',
            'required': true,
          },
        ];
      default:
        return [];
    }
  }
}
