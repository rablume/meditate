import 'package:flutter/material.dart';

class CountdownPicker extends StatefulWidget {
  const CountdownPicker({super.key});

  @override
  _CountdownPickerState createState() => _CountdownPickerState();
}

class _CountdownPickerState extends State<CountdownPicker> {
  int selectedValue = 5; // Default value

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Select Starting Countdown Timer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListWheelScrollView(
            itemExtent: 40,
            diameterRatio: 2.0,
            offAxisFraction: -0.5,
            useMagnifier: true,
            magnification: 1.5,
            children: List.generate(
              10, // Number of values in the wheel
              (index) => Center(
                child: Text(
                  '${index + 1} minutes',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedValue = index + 1;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Use the selectedValue for the countdown timer
              Navigator.pop(context);
            },
            child: const Text('Start Countdown'),
          ),
        ],
      ),
    );
  }
}
