import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/storage/storage_manager.dart';
import 'package:date_app/features/auth/services/auth_storage_service.dart';
import 'package:date_app/features/global/models/user_model.dart';
part 'splash_state.dart';

@Injectable()
class SplashCubit extends Cubit<SplashState> {
  final AuthStorageService _storageService;

  SplashCubit(this._storageService) : super(const SplashState()) {
    initialize();
  }

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));

    final supaUser = Supabase.instance.client.auth.currentUser;
    final isStoredLoggedIn = await _storageService.isLoggedIn();
    final isLoggedIn = supaUser != null || isStoredLoggedIn;
    final user = await _storageService.getUser();
    final completed =
        await StorageManager().read(StorageKeys.onboardingCompleted);
    final isOnboardingCompleted = completed == 'true';

    emit(
      state.copyWith(
        isLoading: false,
        isLoggedIn: isLoggedIn,
        isOnboardingCompleted: isOnboardingCompleted,
        user: user,
      ),
    );
  }
}
