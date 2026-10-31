part of 'bottom_nav_cubit.dart';

class BottomNavState extends Equatable {
  final int currentIndex;
  final bool isLoading;

  /// 4 Pages stored in state (nullable for lazy loading)
  final List<Widget?> pages;

  const BottomNavState({
    this.currentIndex = 0,
    this.isLoading = false,
    this.pages = const [null, null, null, null],
  });

  BottomNavState copyWith({
    int? currentIndex,
    bool? isLoading,
    List<Widget?>? pages,
  }) {
    return BottomNavState(
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [currentIndex, isLoading, pages];
}
