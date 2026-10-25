import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';
import 'package:date_app/features/global/models/user_model.dart';
import 'package:date_app/features/home/bloc/home_cubit.dart';
import 'gender_selection_state.dart';

class GenderSelectionCubit extends Cubit<GenderSelectionState> {
  final UserModel user;
  final GlobalCubit globalCubit;
  final HomeCubit homeCubit;

  GenderSelectionCubit({
    required this.user,
    required this.globalCubit,
    required this.homeCubit,
  }) : super(const GenderSelectionState());

  void selectGender(String gender) {
    if (state.status == GenderSelectionStatus.submitting) return;
    emit(state.copyWith(selectedGender: gender));
  }

  Future<void> submitGender() async {
    if (state.status == GenderSelectionStatus.submitting) return;

    emit(state.copyWith(status: GenderSelectionStatus.submitting));

    try {
      final gender = state.selectedGender.toLowerCase().trim();
      await Supabase.instance.client
          .from('users')
          .update({'gender': gender})
          .eq('uid', user.uid);

      final updatedUser = user.copyWith(gender: gender);
      await globalCubit.updateUser(user: updatedUser);
      homeCubit.loadUsers();

      emit(state.copyWith(status: GenderSelectionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: GenderSelectionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
