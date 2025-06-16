import 'dart:async';
import 'dart:collection';

import 'package:core_domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'episodes_event.dart';
part 'episodes_state.dart';

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final FetchEpisodesUseCase _fetchEpisodesUseCase;
  final DeleteEpisodeUseCase _deleteEpisodeUseCase;

  EpisodesBloc({
    required FetchEpisodesUseCase fetchEpisodes,
    required DeleteEpisodeUseCase deleteEpisode,
  }) : _fetchEpisodesUseCase = fetchEpisodes,
       _deleteEpisodeUseCase = deleteEpisode,
       super(EpisodesInitialState()) {
    on<FetchEpisodesEvent>(_onFetchEpisodesEvent);
    on<RefreshEpisodesEvent>(_onRefreshEpisodesEvent);
    on<CreatedEpisodeEvent>(_onCreatedEpisodeEvent);
    on<UpdatedEpisodeEvent>(_onUpdatedEpisodeEvent);
    on<DeleteEpisodeEvent>(_onDeleteEpisodeEvent);
  }

  void _onFetchEpisodesEvent(
    FetchEpisodesEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    final result = await _fetchEpisodesUseCase();
    switch (result) {
      case Success(:final value):
        emit(EpisodesLoadedState(value));
      case Failure(:final error):
        emit(EpisodesErrorState(error.toString()));
    }
  }

  void _onRefreshEpisodesEvent(
    RefreshEpisodesEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    final result = await _fetchEpisodesUseCase();
    event.completer.complete();
    switch (result) {
      case Success(:final value):
        emit(EpisodesLoadedState(value));
      case Failure(:final error):
        emit(EpisodesErrorState(error.toString()));
    }
  }

  void _onCreatedEpisodeEvent(
    CreatedEpisodeEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    if (state is EpisodesLoadedState) {
      emit(
        EpisodesLoadedState(
          (state as EpisodesLoadedState).episodes + [event.episode],
        ),
      );
    }
  }

  void _onUpdatedEpisodeEvent(
    UpdatedEpisodeEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    if (state is EpisodesLoadedState) {
      List<Episode> list = (state as EpisodesLoadedState).episodes;
      final index = list.indexWhere((e) => e.id == event.episode.id);
      list[index] = event.episode;
      emit(EpisodesLoadedState(UnmodifiableListView(list)));
    }
  }

  void _onDeleteEpisodeEvent(
    DeleteEpisodeEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    if (event.episodeId.isEmpty) return;
    if (state is EpisodesLoadedState) {
      final result = await _deleteEpisodeUseCase(event.episodeId);
      switch (result) {
        case Success():
          EpisodesLoadedState(
            (state as EpisodesLoadedState).episodes
                .skipWhile((e) => e.id == event.episodeId)
                .toList(),
          );
        case Failure(:final error):
          emit(EpisodesErrorState(error.toString()));
      }
    }
  }
}
