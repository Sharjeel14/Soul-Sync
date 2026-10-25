import 'package:equatable/equatable.dart';

class HomeFilterModel extends Equatable {
  final String? gender;
  final double? maxDistanceKm;
  final int? minAge;
  final int? maxAge;

  const HomeFilterModel({
    this.gender,
    this.maxDistanceKm,
    this.minAge,
    this.maxAge,
  });

  const HomeFilterModel.all()
      : gender = null,
        maxDistanceKm = null,
        minAge = null,
        maxAge = null;

  HomeFilterModel copyWith({
    String? gender,
    bool clearGender = false,
    double? maxDistanceKm,
    int? minAge,
    int? maxAge,
  }) {
    return HomeFilterModel(
      gender: clearGender ? null : (gender ?? this.gender),
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
    );
  }

  @override
  List<Object?> get props => [gender, maxDistanceKm, minAge, maxAge];
}
