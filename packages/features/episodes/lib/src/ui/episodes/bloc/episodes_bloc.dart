import 'dart:async';

import 'package:core_domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'episodes_event.dart';
part 'episodes_state.dart';

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final FetchEpisodesUseCase _fetchEpisodesUseCase;
  final DeleteEpisodeUseCase _deleteEpisodeUseCase;

  int _page = 1;
  final int _limit = 20;

  EpisodesBloc({
    required FetchEpisodesUseCase fetchEpisodes,
    required DeleteEpisodeUseCase deleteEpisode,
  }) : _fetchEpisodesUseCase = fetchEpisodes,
       _deleteEpisodeUseCase = deleteEpisode,
       super(EpisodesState.initial()) {
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
    if (state.isLoading || !state.hasMore) return;
    emit(state.copyWith(isLoading: true, isError: ''));

    final result = await _fetchEpisodesUseCase(page: _page, limit: _limit);
    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            isLoading: false,
            episodes: _mergeEpisodesUniqueById(state.episodes, value),
            hasMore: value.length == _limit,
          ),
        );
        _page++;
      case Failure(:final error):
        emit(state.copyWith(isLoading: false, isError: error.toString()));
    }
  }

  List<Episode> _mergeEpisodesUniqueById(
    List<Episode> oldEpisodes,
    List<Episode> newEpisodes,
  ) {
    final all = [...oldEpisodes, ...newEpisodes];

    final Map<String, Episode> uniqueById = {for (var e in all) e.id: e};

    return uniqueById.values.toList();
  }

  void _onRefreshEpisodesEvent(
    RefreshEpisodesEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    _page = 1;
    emit(state.copyWith(isLoading: true, isError: ''));

    final result = await _fetchEpisodesUseCase(page: _page, limit: _limit);
    event.completer.complete();
    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            isLoading: false,
            episodes: value,
            hasMore: value.length == _limit,
          ),
        );
        _page++;
      case Failure(:final error):
        emit(state.copyWith(isLoading: false, isError: error.toString()));
    }
  }

  void _onCreatedEpisodeEvent(
    CreatedEpisodeEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    if (state.isLoading) return;

    emit(
      state.copyWith(
        isLoading: false,
        episodes: [...state.episodes, event.episode],
        isError: '',
      ),
    );
  }

  void _onUpdatedEpisodeEvent(
    UpdatedEpisodeEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    if (state.isLoading) return;

    List<Episode> list = List.from(state.episodes);
    final index = list.indexWhere((e) => e.id == event.episode.id);
    list[index] = event.episode;
    emit(state.copyWith(isLoading: false, episodes: list, isError: ''));
  }

  void _onDeleteEpisodeEvent(
    DeleteEpisodeEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    if (event.episodeId.isEmpty) return;

    final result = await _deleteEpisodeUseCase(event.episodeId);
    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isLoading: false,
            episodes: state.episodes
                .where((e) => e.id != event.episodeId)
                .toList(),
            isError: '',
          ),
        );
      case Failure(:final error):
        emit(state.copyWith(isLoading: false, isError: error.toString()));
    }
  }
}
