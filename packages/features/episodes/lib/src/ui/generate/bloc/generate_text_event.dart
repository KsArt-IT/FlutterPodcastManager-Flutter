part of 'generate_text_bloc.dart';

sealed class GenerateTextEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class GenerateStringEvent extends GenerateTextEvent {}

final class ApplyEpisodeEvent extends GenerateTextEvent {}

final class ChangePromptEvent extends GenerateTextEvent {
  final String prompt;

  ChangePromptEvent(this.prompt);

  @override
  List<Object?> get props => [prompt];
}

final class ChangeTextEvent extends GenerateTextEvent {
  final String text;

  ChangeTextEvent(this.text);
  @override
  List<Object?> get props => [text];
}

final class SelectTargetEvent extends GenerateTextEvent {
  final EpisodeTarget target;

  SelectTargetEvent(this.target);
  @override
  List<Object?> get props => [target];
}
