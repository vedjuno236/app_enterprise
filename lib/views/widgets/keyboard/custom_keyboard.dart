import 'package:flutter/material.dart';

import '../../../components/models/keyboard_model/number_model.dart';

class CustomKeyboard extends StatefulWidget {
  final bool? isHorizontal;
  final void Function(String) onKeyTap;
  final void Function(String) onDelete;
  final FocusNode? focusedField;

  const CustomKeyboard(
      {super.key,
      required this.onKeyTap,
      this.focusedField,
      required this.onDelete,
      this.isHorizontal = false});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  late List<List<dynamic>> keys;
  late String number;

  @override
  void initState() {
    super.initState();
    keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      [
        '0',
        '000',
        const Icon(
          Icons.close,
          color: Colors.black,
        )
      ],
    ];
    number = '';
  }

  onKeyTap(val) {
    widget.onKeyTap(val);
  }

  // onKeyTap(val) {
  //   // print("val :$val");
  //   // if (val == '0' && number.isEmpty) {
  //   //   return;
  //   // }
  //   setState(() {
  //     number = number + val;
  //   });
  // }

  // onBackspacePress() {
  //   if (number.isEmpty) {
  //     return;
  //   }
  //
  //   setState(() {
  //     number = number.substring(0, number.length - 1);
  //   });
  // }

  renderKeyboard() {
    return keys
        .map(
          (x) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              children: x.map(
                (y) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        color: Colors.grey.shade200,
                        child: KeyboardKey(
                          isHorizontal: widget.isHorizontal!,
                          label: y,
                          value: y,
                          onTap: (val) {
                            if (val is Widget) {
                              widget.onDelete("delete");
                            } else {
                              onKeyTap(val);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // renderAmount(),
          ...renderKeyboard(),

          // renderConfirmButton(),
        ],
      ),
    );
  }
}
