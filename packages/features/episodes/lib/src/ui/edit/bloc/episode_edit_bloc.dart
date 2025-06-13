import 'package:bloc/bloc.dart';
import 'package:core_domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'episode_edit_event.dart';
part 'episode_edit_state.dart';

class EpisodeEditBloc extends Bloc<EpisodeEditEvent, EpisodeEditState> {
  final FetchEpisodeUseCase _fetchEpisodeUseCase;
  final CreateEpisodeUseCase _createEpisodeUseCase;
  final UpdateEpisodeUseCase _updateEpisodeUseCase;

  EpisodeEditBloc({
    required FetchEpisodeUseCase fetchEpisode,
    required CreateEpisodeUseCase createEpisode,
    required UpdateEpisodeUseCase updateEpisodes,
  }) : _fetchEpisodeUseCase = fetchEpisode,
       _createEpisodeUseCase = createEpisode,
       _updateEpisodeUseCase = updateEpisodes,
       super(const EpisodeEditState()) {
    on<CreateEpisodeEvent>(_onCreateEpisodeEvent);
    on<EditEpisodeEvent>(_onEditEpisodeEvent);
    on<SaveEpisodeEvent>(_onSaveEpisodeEvent);
  }

  void _onCreateEpisodeEvent(
    CreateEpisodeEvent event,
    Emitter<EpisodeEditState> emit,
  ) {
    emit(state.copyWith(status: StateStatus.initial));
  }

  void _onEditEpisodeEvent(
    EditEpisodeEvent event,
    Emitter<EpisodeEditState> emit,
  ) async {
    final result = await _fetchEpisodeUseCase(event.episodeId);
    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            status: StateStatus.initial,
            episode: value,
            title: value.title,
            description: value.description,
            host: value.host,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(status: StateStatus.error, error: error.toString()),
        );
    }
  }

  void _onSaveEpisodeEvent(
    SaveEpisodeEvent event,
    Emitter<EpisodeEditState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: StateStatus.initial));
    final result = state.episode != null
        ? await _updateEpisodeUseCase(
            state.episode!.copyWith(
              title: state.title,
              description: state.description,
              host: state.host,
            ),
          )
        : await _createEpisodeUseCase(
            Episode(
              title: state.title,
              description: state.description,
              host: state.host,
            ),
          );
    switch (result) {
      case Success(:final value):
        emit(state.copyWith(status: StateStatus.success, episode: value));
      case Failure(:final error):
        emit(
          state.copyWith(status: StateStatus.error, error: error.toString()),
        );
    }
  }
}
