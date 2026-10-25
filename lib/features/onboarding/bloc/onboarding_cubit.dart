import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/storage/storage_manager.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final StorageManager _storageManager;

  OnboardingCubit({StorageManager? storageManager})
      : _storageManager = storageManager ?? StorageManager(),
        super(const OnboardingState());

  void setPage(int page) {
    if (page < 0 || page > 2) return;
    emit(state.copyWith(currentPage: page));
  }

  Future<void> completeOnboarding() async {
    await _storageManager.write(StorageKeys.onboardingCompleted, 'true');
    emit(state.copyWith(isCompleted: true));
  }
}
