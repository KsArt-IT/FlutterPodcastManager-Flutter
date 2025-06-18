import 'package:bloc/bloc.dart';
import 'package:core_domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'generate_text_event.dart';
part 'generate_text_state.dart';

class GenerateTextBloc extends Bloc<GenerateTextEvent, GenerateTextState> {
  final GenerateEpisodeUseCase _generateText;

  GenerateTextBloc({
    required GenerateEpisodeUseCase generateText,
    required Episode episode,
  }) : _generateText = generateText,
       super(GenerateTextState(episode: episode)) {
    on<SelectTargetEvent>(_onSelectTargetEvent);
    on<ChangePromptEvent>(_onChangePromptEvent);
    on<GenerateStringEvent>(_onGenerateTextEvent);
  }

  void _onChangePromptEvent(
    ChangePromptEvent event,
    Emitter<GenerateTextState> emit,
  ) {
    emit(state.copyWith(prompt: event.prompt, error: null));
  }

  void _onSelectTargetEvent(
    SelectTargetEvent event,
    Emitter<GenerateTextState> emit,
  ) {
    emit(state.copyWith(target: event.target, error: null));
  }

  void _onGenerateTextEvent(
    GenerateStringEvent event,
    Emitter<GenerateTextState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    String prompt = switch (state.target) {
      EpisodeTarget.title => state.episode.title,
      EpisodeTarget.description => state.episode.description,
    };
    prompt = '"$prompt" ${state.prompt}';
    final result = await _generateText(prompt);

    switch (result) {
      case Success(:final value):
        final episode = state.generatedEpisode ?? state.episode;
        final generatedEpisode = switch (state.target) {
          EpisodeTarget.title => episode.copyWith(title: value),
          EpisodeTarget.description => episode.copyWith(description: value),
        };
        emit(
          state.copyWith(generatedEpisode: generatedEpisode, isLoading: false),
        );
      case Failure(:final error):
        final appFailure = error as AppFailure;
        emit(state.copyWith(isLoading: false, error: appFailure.message));
    }
  }
}
