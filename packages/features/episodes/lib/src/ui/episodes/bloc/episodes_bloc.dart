import 'dart:async';

import 'package:core_domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'episodes_event.dart';
part 'episodes_state.dart';

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final FetchEpisodesUseCase _fetchEpisodesUseCase;

  EpisodesBloc({required FetchEpisodesUseCase fetchEpisodes})
    : _fetchEpisodesUseCase = fetchEpisodes,
      super(EpisodesInitialState()) {
    on<FetchEpisodesEvent>(_onFetchEpisodesEvent);
    on<RefreshEpisodesEvent>(_onRefreshEpisodesEvent);
    on<CreatedEpisodeEvent>(_onCreatedEpisodeEvent);
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
}
