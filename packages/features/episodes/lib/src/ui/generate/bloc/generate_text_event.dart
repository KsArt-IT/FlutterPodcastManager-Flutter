part of 'generate_text_bloc.dart';

sealed class GenerateTextEvent {}

final class GenerateStringEvent extends GenerateTextEvent {}

final class ChangePromptEvent extends GenerateTextEvent {
  final String prompt;

  ChangePromptEvent(this.prompt);
}

final class SelectTargetEvent extends GenerateTextEvent {
  final EpisodeTarget target;

  SelectTargetEvent(this.target);
}
