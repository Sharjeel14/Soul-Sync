enum GenderType { unknown, male, female }

extension GenderTypeExtension on GenderType {
  String get value => name;

  static GenderType fromString(String value) {
    return GenderType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => GenderType.male,
    );
  }
}
