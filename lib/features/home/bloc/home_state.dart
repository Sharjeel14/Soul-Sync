part of 'home_cubit.dart';

enum HomeViewMode { swipe, list }

class HomeState extends Equatable {
  final bool isLoading;
  final List<UserModel> users;
  final String? errorMessage;
  final String? selectedGenderFilter;
  final Set<String> likedUserIds;
  final Set<String> swipedUserIds;
  final Set<String> blockedUserIds;
  final UserModel? lastMatchedUser;
  final int selectedIndex;
  final HomeViewMode viewMode;

  const HomeState({
    this.isLoading = false,
    this.users = const [],
    this.errorMessage,
    this.selectedGenderFilter,
    this.likedUserIds = const {},
    this.swipedUserIds = const {},
    this.blockedUserIds = const {},
    this.lastMatchedUser,
    this.selectedIndex = 0,
    this.viewMode = HomeViewMode.swipe,
  });

  List<UserModel> get filteredUsers {
    final list = users.where((u) => !blockedUserIds.contains(u.uid)).toList();
    if (selectedGenderFilter == null ||
        selectedGenderFilter!.isEmpty ||
        selectedGenderFilter == 'all') {
      return list;
    }
    return list
        .where(
          (u) => u.gender.toLowerCase() == selectedGenderFilter!.toLowerCase(),
        )
        .toList();
  }

  HomeState copyWith({
    bool? isLoading,
    List<UserModel>? users,
    String? errorMessage,
    bool clearError = false,
    String? selectedGenderFilter,
    Set<String>? likedUserIds,
    Set<String>? swipedUserIds,
    Set<String>? blockedUserIds,
    UserModel? lastMatchedUser,
    bool clearLastMatched = false,
    int? selectedIndex,
    HomeViewMode? viewMode,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedGenderFilter: selectedGenderFilter ?? this.selectedGenderFilter,
      likedUserIds: likedUserIds ?? this.likedUserIds,
      swipedUserIds: swipedUserIds ?? this.swipedUserIds,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      lastMatchedUser:
          clearLastMatched ? null : (lastMatchedUser ?? this.lastMatchedUser),
      selectedIndex: selectedIndex ?? this.selectedIndex,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    users,
    errorMessage,
    selectedGenderFilter,
    likedUserIds,
    swipedUserIds,
    blockedUserIds,
    lastMatchedUser,
    selectedIndex,
    viewMode,
  ];
}
