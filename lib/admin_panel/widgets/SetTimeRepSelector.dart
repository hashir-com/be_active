// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SetTimeRepSelector extends StatefulWidget {
  final TextEditingController setsController;
  final TextEditingController modeController;
  final TextEditingController valueController;

  const SetTimeRepSelector({
    super.key,
    required this.setsController,
    required this.modeController,
    required this.valueController,
  });

  @override
  State<SetTimeRepSelector> createState() => _SetTimeRepSelectorState();
}

class _SetTimeRepSelectorState extends State<SetTimeRepSelector> {
  String? selectedSet;
  String? selectedMode;

  final List<String> setOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];
  final List<String> modeOptions = ['Time', 'Reps'];

  @override
  void initState() {
    super.initState();
    selectedSet = widget.setsController.text;
    selectedMode = widget.modeController.text;
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        widget.valueController.text = '${picked.hour} hr ${picked.minute} min';
      });
    }
  }

  Future<void> _enterReps() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Enter Reps"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "e.g. 12"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      widget.valueController.text = '${controller.text} reps';
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> options,
    required String? selectedValue,
    required Function(String) onChanged,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.primaryColorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButton<String>(
            value: selectedValue!.isNotEmpty ? selectedValue : null,
            isExpanded: true,
            underline: Container(),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(50),
            iconEnabledColor: theme.iconTheme.color,
            items:
                options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(color: theme.primaryColorLight),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultDisplay() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Selected Value:',
          style: TextStyle(
            color: theme.primaryColorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 255, 255, 255),
            borderRadius: BorderRadius.circular(46),
            border: Border.all(color: theme.highlightColor, width: 0.3),
          ),
          child: Text(
            widget.valueController.text.isEmpty
                ? 'None'
                : widget.valueController.text,
            style: TextStyle(color: theme.primaryColorLight),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          label: 'Sets',
          options: setOptions,
          selectedValue: selectedSet,
          onChanged: (value) {
            setState(() {
              selectedSet = value;
              widget.setsController.text = value;
            });
          },
        ),
        const SizedBox(height: 20),
        _buildDropdown(
          label: 'Choose Mode',
          options: modeOptions,
          selectedValue: selectedMode,
          onChanged: (value) {
            setState(() {
              selectedMode = value;
              widget.modeController.text = value;
              if (value == 'Time') {
                _pickTime();
              } else {
                _enterReps();
              }
            });
          },
        ),
        _buildResultDisplay(),
      ],
    );
  }
}
