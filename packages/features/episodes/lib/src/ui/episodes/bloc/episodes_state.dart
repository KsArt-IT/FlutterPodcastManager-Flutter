part of 'episodes_bloc.dart';

sealed class EpisodesState extends Equatable {
  const EpisodesState();

  @override
  List<Object?> get props => [];
}

final class EpisodesInitialState extends EpisodesState {}

final class EpisodesErrorState extends EpisodesState {
  final String message;
  const EpisodesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

final class EpisodesLoadedState extends EpisodesState {
  final List<Episode> episodes;
  const EpisodesLoadedState(this.episodes);

  @override
  List<Object?> get props => [episodes];
}
