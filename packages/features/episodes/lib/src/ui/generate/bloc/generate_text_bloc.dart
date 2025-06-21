import 'package:bloc/bloc.dart';
import 'package:core_domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'generate_text_event.dart';
part 'generate_text_state.dart';

class GenerateTextBloc extends Bloc<GenerateTextEvent, GenerateTextState> {
  final GenerateEpisodeUseCase _generateText;
  final UpdateEpisodeUseCase _updateEpisodeUseCase;

  GenerateTextBloc({
    required GenerateEpisodeUseCase generateText,
    required UpdateEpisodeUseCase updateEpisodes,
    required Episode episode,
  }) : _generateText = generateText,
       _updateEpisodeUseCase = updateEpisodes,
       super(GenerateTextState(episode: episode)) {
    on<SelectTargetEvent>(_onSelectTargetEvent);
    on<ChangePromptEvent>(_onChangePromptEvent);
    on<ChangeTextEvent>(_onChangeTextEvent);
    on<GenerateStringEvent>(_onGenerateTextEvent);
    on<ApplyEpisodeEvent>(_onApplyEpisodeEvent);
  }

  void _onChangePromptEvent(
    ChangePromptEvent event,
    Emitter<GenerateTextState> emit,
  ) {
    emit(state.copyWith(prompt: event.prompt, error: null));
  }

  void _onChangeTextEvent(
    ChangeTextEvent event,
    Emitter<GenerateTextState> emit,
  ) {
    if (state.generatedEpisode == null) return;

    emit(
      state.copyWith(
        generatedEpisode: _getEpisodeByTarget(
          state.generatedEpisode!,
          event.text,
        ),
        isLoading: false,
        error: null,
      ),
    );
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

    final result = await _generateText(state.prompt);
    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            generatedEpisode: _getEpisodeByTarget(
              state.generatedEpisode ?? state.episode,
              _cleanText(value),
            ),
            isLoading: false,
          ),
        );
      case Failure(:AppFailure error):
        emit(state.copyWith(isLoading: false, error: error.message));
      case Failure(:final error):
        emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  void _onApplyEpisodeEvent(
    ApplyEpisodeEvent event,
    Emitter<GenerateTextState> emit,
  ) async {
    if (state.generatedEpisode == null) return;
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _updateEpisodeUseCase(state.generatedEpisode!);
    switch (result) {
      case Success(:final value):
        emit(state.copyWith(generatedEpisode: value, isSuccess: true));
      case Failure(:AppFailure error):
        emit(state.copyWith(isLoading: false, error: error.message));
      case Failure(:final error):
        emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Episode _getEpisodeByTarget(Episode episode, String text) {
    return switch (state.target) {
      EpisodeTarget.title => episode.copyWith(title: text),
      EpisodeTarget.description => episode.copyWith(description: text),
    };
  }

  String _cleanText(String text) {
    return text.replaceAll(RegExp(r"""^[\s'"“”‘’]+|[\s'"“”‘’․․..]+$"""), '');
  }
}
