import 'package:flutter/material.dart';

import '../models/meat_type.dart';

class MeatTypeDropdown extends StatelessWidget {
  const MeatTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final MeatType value;
  final ValueChanged<MeatType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meat Type', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 2),
        Text(
          'Protein density changes how quickly heat penetrates the cut.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        SegmentedButton<MeatType>(
          showSelectedIcon: false,
          multiSelectionEnabled: false,
          segments: MeatType.values
              .map(
                (type) => ButtonSegment<MeatType>(
                  value: type,
                  label: Text(type.label),
                ),
              )
              .toList(),
          selected: {value},
          onSelectionChanged: (selection) => onChanged(selection.first),
        ),
      ],
    );
  }
}
