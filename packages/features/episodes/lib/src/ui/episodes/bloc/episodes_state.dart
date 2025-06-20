part of 'episodes_bloc.dart';

class EpisodesState extends Equatable {
  final List<Episode> episodes;
  final bool hasMore;
  final bool isLoading;
  final String isError;

  const EpisodesState({
    required this.episodes,
    required this.hasMore,
    required this.isLoading,
    required this.isError,
  });

  factory EpisodesState.initial() => const EpisodesState(
    episodes: [],
    hasMore: true,
    isLoading: false,
    isError: '',
  );

  EpisodesState copyWith({
    List<Episode>? episodes,
    bool? hasMore,
    bool? isLoading,
    String? isError,
  }) {
    return EpisodesState(
      episodes: episodes ?? this.episodes,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [episodes, hasMore, isLoading, isError];
}
