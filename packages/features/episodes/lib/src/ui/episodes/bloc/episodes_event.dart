part of 'episodes_bloc.dart';

sealed class EpisodesEvent extends Equatable {
  const EpisodesEvent();
  @override
  List<Object?> get props => [];
}

final class FetchEpisodesEvent extends EpisodesEvent {}

final class RefreshEpisodesEvent extends EpisodesEvent {
  final Completer completer;
  const RefreshEpisodesEvent(this.completer);

  @override
  List<Object?> get props => [completer];
}

final class CreatedEpisodeEvent extends EpisodesEvent {
  final Episode episode;
  const CreatedEpisodeEvent(this.episode);

  @override
  List<Object?> get props => [episode];
}

final class UpdatedEpisodeEvent extends EpisodesEvent {
  final Episode episode;
  const UpdatedEpisodeEvent(this.episode);

  @override
  List<Object?> get props => [episode];
}

final class DeleteEpisodeEvent extends EpisodesEvent {
  final String episodeId;
  const DeleteEpisodeEvent(this.episodeId);

  @override
  List<Object?> get props => [episodeId];
}
