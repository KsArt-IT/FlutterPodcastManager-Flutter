part of 'generate_text_bloc.dart';

final class GenerateTextState extends Equatable {
  final Episode episode;
  final Episode? generatedEpisode;
  final EpisodeTarget target;
  final String prompt;
  final bool isLoading;
  final String? error;

  const GenerateTextState({
    required this.episode,
    this.generatedEpisode,
    this.target = EpisodeTarget.title,
    this.prompt = '',
    this.isLoading = false,
    this.error,
  });

  GenerateTextState copyWith({
    Episode? episode,
    Episode? generatedEpisode,
    EpisodeTarget? target,
    String? prompt,
    bool? isLoading,
    String? error,
  }) {
    return GenerateTextState(
      episode: episode ?? this.episode,
      generatedEpisode: generatedEpisode ?? this.generatedEpisode,
      target: target ?? this.target,
      prompt: prompt ?? this.prompt,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    episode,
    generatedEpisode,
    target,
    prompt,
    isLoading,
    error,
  ];
}

enum EpisodeTarget { title, description }

extension EpisodeTargetExtension on EpisodeTarget {
  String get label {
    switch (this) {
      case EpisodeTarget.title:
        return 'Title';
      case EpisodeTarget.description:
        return 'Description';
    }
  }
}
