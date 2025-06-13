part of 'episode_edit_bloc.dart';

enum StateStatus { initial, loading, valid, success, error }

final class EpisodeEditState extends Equatable {
  final StateStatus status;

  final Episode? episode;

  final String title;
  final String description;
  final String host;

  final String error;

  bool get isValid =>
      (_isValidTitle() ?? _isValidDescription() ?? _isValidHost()) == null;

  const EpisodeEditState({
    this.status = StateStatus.loading,
    this.episode,

    this.title = '',
    this.description = '',
    this.host = '',

    this.error = '',
  });

  EpisodeEditState copyWith({
    StateStatus? status,

    Episode? episode,

    String? title,
    String? description,
    String? host,

    String? error,
  }) {
    final errorStr = _isValidTitle(title) ?? _isValidDescription(description) ?? _isValidHost(host) ?? '';
    return EpisodeEditState(
      status: status ?? (errorStr.isEmpty ? StateStatus.valid : StateStatus.error),
      episode: episode ?? this.episode,
      title: title ?? this.title,
      description: description ?? this.description,
      host: host ?? this.host,
      error: error ?? errorStr,
    );
  }

  String? _isValidTitle([String? title]) {
    title = title ?? this.title;
    if (title.length < 3) {
      return 'Title must be more than 3 characters!';
    }
    return null;
  }

  String? _isValidDescription([String? description]) {
    description = description ?? this.description;
    if (description.length < 3) {
      return 'Description must be more than 3 characters!';
    }
    return null;
  }

  String? _isValidHost([String? host]) {
    host = host ?? this.host;
    if (host.length < 3) {
      return 'Host must be more than 3 characters!';
    }
    return null;
  }

  @override
  List<Object?> get props => [status, episode, title, description, host, error];
}
