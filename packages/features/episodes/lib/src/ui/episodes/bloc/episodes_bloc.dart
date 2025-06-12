import 'package:core_domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'episodes_event.dart';
part 'episodes_state.dart';

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final FetchEpisodesUseCase _fetchEpisodesUseCase;

  EpisodesBloc({
    required FetchEpisodesUseCase fetchEpisodes,
    }) : _fetchEpisodesUseCase = fetchEpisodes,
      super(EpisodesInitialState()) {
    on<FetchEpisodesEvent>(_onFetchEpisodesEvent);
  }

  void _onFetchEpisodesEvent(
    FetchEpisodesEvent event,
    Emitter<EpisodesState> emit,
  ) async {
    // emit(EpisodesLoadingState());
    final result = await _fetchEpisodesUseCase();
    switch (result) {
      case Success(:final value):
        emit(EpisodesLoadedState(value));
      case Failure(:final error):
        emit(EpisodesErrorState(error.toString()));
    }
  }
}
