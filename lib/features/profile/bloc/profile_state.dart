part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isSaving;
  final bool isSuccess;
  final String? errorMessage;
  final String? successMessage;
  final UserModel? user;
  final File? selectedImage;
  final GenderType selectedGender;

  const ProfileState({
    this.isLoading = false,
    this.isSaving = false,
    this.isSuccess = false,
    this.errorMessage,
    this.successMessage,
    this.user,
    this.selectedImage,
    this.selectedGender = GenderType.male,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
    UserModel? user,
    File? selectedImage,
    GenderType? selectedGender,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
      user: user ?? this.user,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSaving,
        isSuccess,
        errorMessage,
        successMessage,
        user,
        selectedImage,
        selectedGender,
      ];
}
