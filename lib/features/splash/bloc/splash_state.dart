part of 'splash_cubit.dart';

class SplashState extends Equatable {
  final bool isLoading;
  final bool isLoggedIn;
  final bool isOnboardingCompleted;
  final UserModel? user;

  const SplashState({
    this.isLoading = true,
    this.isLoggedIn = false,
    this.isOnboardingCompleted = false,
    this.user,
  });

  SplashState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    bool? isOnboardingCompleted,
    UserModel? user,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoggedIn, isOnboardingCompleted, user];
}
