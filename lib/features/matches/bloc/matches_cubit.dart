import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:date_app/features/matches/models/match_item_model.dart';
import 'package:date_app/features/matches/repository/match_repository.dart';
import 'package:date_app/features/profile/repository/block_repository.dart';
import 'matches_state.dart';

@injectable
class MatchesCubit extends Cubit<MatchesState> {
  final MatchRepository _matchRepository;
  final BlockRepository _blockRepository;
  StreamSubscription? _subscription;

  MatchesCubit(
    this._matchRepository,
    this._blockRepository,
  ) : super(const MatchesState()) {
    init();
  }

  void init() {
    emit(state.copyWith(status: MatchesStatus.loading));
    _subscription?.cancel();
    _subscription = _matchRepository.streamMatches().listen(
      (users) {
        final filtered = users
            .where((u) => !_blockRepository.isBlocked(u.uid))
            .map((u) => MatchItemModel.fromUser(u))
            .toList();

        emit(state.copyWith(
          status: MatchesStatus.loaded,
          matches: filtered,
        ));
      },
      onError: (err) {
        emit(state.copyWith(
          status: MatchesStatus.error,
          errorMessage: err.toString(),
        ));
      },
    );
  }

  Future<void> refresh() async {
    final users = await _matchRepository.getMatches();
    final filtered = users
        .where((u) => !_blockRepository.isBlocked(u.uid))
        .map((u) => MatchItemModel.fromUser(u))
        .toList();

    emit(state.copyWith(
      status: MatchesStatus.loaded,
      matches: filtered,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
