enum MeatType {
  chicken(label: 'Chicken', conductionFactor: 0.95),
  beef(label: 'Beef', conductionFactor: 0.8),
  fish(label: 'Fish', conductionFactor: 1.15);

  const MeatType({
    required this.label,
    required this.conductionFactor,
  });

  final String label;
  final double conductionFactor;
}
