import 'package:equatable/equatable.dart';
import 'package:date_app/features/matches/models/match_item_model.dart';

enum MatchesStatus { initial, loading, loaded, error }

class MatchesState extends Equatable {
  final MatchesStatus status;
  final List<MatchItemModel> matches;
  final String? errorMessage;

  const MatchesState({
    this.status = MatchesStatus.initial,
    this.matches = const [],
    this.errorMessage,
  });

  bool get isLoading => status == MatchesStatus.loading || status == MatchesStatus.initial;

  MatchesState copyWith({
    MatchesStatus? status,
    List<MatchItemModel>? matches,
    String? errorMessage,
  }) {
    return MatchesState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, matches, errorMessage];
}
