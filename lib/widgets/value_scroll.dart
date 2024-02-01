import 'package:flutter/material.dart';

class ValueScroll extends StatelessWidget {
  const ValueScroll({
    super.key,
    this.color = const Color(0xFF2DBD3A),
    required this.length,
    required this.setValue,
    required this.value,
    this.child,
  });

  final int length;
  final Function setValue;
  final int value;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      itemExtent: 50,
      controller: FixedExtentScrollController(initialItem: value),

      // diameterRatio: 1.6,
      // offAxisFraction: -0.4,
      // squeeze: 0.8,

      // DEPRECATED : clipToSize does not exist anymore.
      // USe clipBehaviour instead.

      // clipToSize: true,

      clipBehavior: Clip.antiAlias,
      children: List.generate(length, (index) => Text(index.toString())),
      onSelectedItemChanged: (index) {
        setValue(index);
      },
    );
    // ListWheelScrollView(
    //   itemExtent: 40,
    //   diameterRatio: 2.0,
    //   offAxisFraction: -0.5,
    //   useMagnifier: true,
    //   magnification: 1.5,
    //   children: List.generate(
    //     10, // Number of values in the wheel
    //     (index) => Center(
    //       child: Text(
    //         '${index + 1} minutes',
    //         style: TextStyle(fontSize: 16),
    //       ),
    //     ),
    //   ),
    //   // onSelectedItemChanged: (index) {
    //   //   setTime(Duration(seconds: index + 1));
    //   // },
    // );
  }
}
