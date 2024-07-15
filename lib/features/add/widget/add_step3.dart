import 'package:bid_bazaar/core/common/widgets/custom_button.dart';
import 'package:bid_bazaar/core/common/widgets/custom_dropdown_field.dart';
import 'package:bid_bazaar/core/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../add_view_model.dart';

class AddStep3 extends ConsumerStatefulWidget {
  const AddStep3({super.key});

  @override
  ConsumerState createState() => _AddStep3State();
}

class _AddStep3State extends ConsumerState<AddStep3> {
  late TextEditingController priceController;
  final priceNode = FocusNode();
  final priceKey = GlobalKey<FormState>();

  late TextEditingController minIncController;
  final minIncNode = FocusNode();
  final minIncKey = GlobalKey<FormState>();

  final timeKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final price = ref.read(addViewModelProvider).price;
    priceController = TextEditingController(text: price !=null ? price.toString():'');

    final increment = ref.read(addViewModelProvider).increment;
    minIncController = TextEditingController(text: increment !=null ? increment.toString():'');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: priceKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Expanded(
                child: CustomTextField(
                  label: 'Price',
                  hintText: 'Starting Price...',
                  keyBoardType: const TextInputType.numberWithOptions(),
                  prefix: const Text(
                    'Rs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  controller: priceController,
                  node: priceNode,
                  obscureText: false,
                  validator: (value) {
                    try{
                      if (value!=null) int.parse(value);
                    } catch (e){
                      return 'Invalid Amount!';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (priceKey.currentState!.validate()) {
                      int price = int.parse(value);
                      int minIncrement = (price * 0.02).ceil();

                      if (minIncrement % 5 != 0) {
                        minIncrement = ((minIncrement / 5).ceil()) * 5;
                      }

                      ref.read(addViewModelProvider.notifier).copyWith(price: price);
                      minIncController.text = minIncrement.toString();
                      ref.read(addViewModelProvider.notifier).copyWith(increment: minIncrement);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Form(
              key: minIncKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Expanded(
                child: CustomTextField(
                    label: 'Minimum Raise',
                    hintText: 'Raise...',
                    keyBoardType: TextInputType.number,
                    prefix: const Text(
                      'Rs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    controller: minIncController,
                    node: minIncNode,
                    validator: (value) {
                      try{
                        if (value!=null) int.parse(value);
                      } catch (e){
                        return 'Invalid Amount!';
                      }
                      return null;
                    },
                  onChanged: (value) {
                    if (minIncKey.currentState!.validate()) {
                      ref.read(addViewModelProvider.notifier).copyWith(increment: int.parse(value));
                    }
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
          key: timeKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomDropdownField(
            label: 'Ends In',
            icon: Iconsax.timer_1,
            items: const [
              '3 Days',
              '5 Days',
              '7 Days',
              '10 Days',
              '15 Days',
              '20 Days',
              '25 Days',
              '30 Days'
            ],
            width: MediaQuery.of(context).size.width - 40,
            initiallySelected: ref.read(addViewModelProvider).time != null ? '${ref.read(addViewModelProvider).time} Days' : '10 Days',
            onChanged: (value) {
              ref.read(addViewModelProvider.notifier).copyWith(time: int.parse((value![0] + value[1]).trim()));
              },
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        CustomButton(
          onPressed: () {
            bool isPriceValid = priceKey.currentState?.validate() ?? false;
            bool isIncrementValid = minIncKey.currentState?.validate() ?? false;
            bool isTimeValid = timeKey.currentState?.validate() ?? false;

            if (isPriceValid && isIncrementValid && isTimeValid) {
              ref.read(addViewModelProvider.notifier).changeIndex(3);
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
    );
  }
}
