extension AppStringExtension on String {
  String get titleCase => split(' ')
      .map((e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1)}')
      .join(' ');

  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

extension StringExtension on String {
  bool get validValue => trim().isNotEmpty && this != "-";
}
