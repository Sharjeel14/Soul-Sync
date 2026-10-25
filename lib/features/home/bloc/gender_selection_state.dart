import 'package:equatable/equatable.dart';

enum GenderSelectionStatus { initial, submitting, success, failure }

class GenderSelectionState extends Equatable {
  final String selectedGender; // 'male' or 'female'
  final GenderSelectionStatus status;
  final String? errorMessage;

  const GenderSelectionState({
    this.selectedGender = 'male',
    this.status = GenderSelectionStatus.initial,
    this.errorMessage,
  });

  GenderSelectionState copyWith({
    String? selectedGender,
    GenderSelectionStatus? status,
    String? errorMessage,
  }) {
    return GenderSelectionState(
      selectedGender: selectedGender ?? this.selectedGender,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedGender, status, errorMessage];
}
