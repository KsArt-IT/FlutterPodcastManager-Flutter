part of 'episode_edit_bloc.dart';

sealed class EpisodeEditEvent extends Equatable {
  const EpisodeEditEvent();
  @override
  List<Object?> get props => [];
}

final class CreateEpisodeEvent extends EpisodeEditEvent {}

final class EditEpisodeEvent extends EpisodeEditEvent {
  final String episodeId;

  const EditEpisodeEvent(this.episodeId);

  @override
  List<Object?> get props => [episodeId];
}

final class SaveEpisodeEvent extends EpisodeEditEvent {}
