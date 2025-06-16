part of 'episode_edit_bloc.dart';

sealed class EpisodeEditEvent extends Equatable {
  const EpisodeEditEvent();
  @override
  List<Object?> get props => [];
}

final class EditEpisodeEvent extends EpisodeEditEvent {
  final String episodeId;

  const EditEpisodeEvent(this.episodeId);

  @override
  List<Object?> get props => [episodeId];
}

final class ChangeTitleEpisodeEvent extends EpisodeEditEvent {
  final String value;

  const ChangeTitleEpisodeEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class ChangeDescriptionEpisodeEvent extends EpisodeEditEvent {
  final String value;

  const ChangeDescriptionEpisodeEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class ChangeHostEpisodeEvent extends EpisodeEditEvent {
  final String value;

  const ChangeHostEpisodeEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class SaveEpisodeEvent extends EpisodeEditEvent {}
