import 'package:date_app/features/matches/presentation/matches_page.dart';
import 'package:date_app/features/messages/presentation/message_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:date_app/features/home/presentation/home_page.dart';
import 'package:date_app/features/profile/presentation/profile_page.dart';

part 'bottom_nav_state.dart';

@Injectable()
class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState());

  void init(BuildContext context) {
    updateIndex(0);
  }

  Widget _createPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const MatchesPage();
      case 2:
        return const MessagePage();
      case 3:
        return const ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  void updateIndex(int index) {
    if (index < 0 || index >= 4) return;
    final updatedPages = List<Widget?>.from(state.pages);

    if (updatedPages[index] == null) {
      updatedPages[index] = _createPage(index);
    }

    emit(
      state.copyWith(
        currentIndex: index,
        pages: updatedPages,
        isLoading: false,
      ),
    );
  }

  void logout() {
    emit(
      state.copyWith(pages: const [null, null, null, null], currentIndex: 0),
    );
  }
}
