import 'package:core_domain/domain.dart';
import 'package:feature_episodes/episodes.dart';
import 'package:feature_episodes/src/ui/episodes/widgets/episodes_list.dart';
import 'package:feature_episodes/src/ui/episodes/widgets/episodes_retry.dart';
import 'package:feature_episodes/src/ui/generate/generate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EpisodesScreen extends StatelessWidget {
  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EpisodesBloc(
        fetchEpisodes: context.read(),
        deleteEpisode: context.read(),
      )..add(FetchEpisodesEvent()),
      child: _EpisodesBody(),
    );
  }
}

class _EpisodesBody extends StatelessWidget {
  const _EpisodesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Episodes")),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        key: const Key('episodes_add_floatingActionButton'),
        onPressed: () async {
          final episode = await context.pushNamed('new');
          if (context.mounted) {
            _updateAndShowSnackBar(context, episode, true);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EpisodesBloc, EpisodesState>(
        builder: (context, state) => switch (state) {
          EpisodesLoadedState(:final episodes) => EpisodesList(
            list: episodes,
            onRefresh: (value) =>
                context.read<EpisodesBloc>().add(RefreshEpisodesEvent(value)),
            onEdit: (value) async {
              final episode = await context.pushNamed(
                'edit',
                pathParameters: {'episodeId': value},
              );
              if (context.mounted) _updateAndShowSnackBar(context, episode);
            },
            onDelete: (value) =>
                context.read<EpisodesBloc>().add(DeleteEpisodeEvent(value)),
            onTap: (value) {
              // TODO: open host value
              Clipboard.setData(ClipboardData(text: value));
              _showSnackBar(context, 'Host copy to Clipboard!');
            },
            onGenerate: (value) async {
              final episode = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => GenerateScreen(episode: value),
              );
              if (context.mounted) _updateAndShowSnackBar(context, episode);
            },
          ),
          EpisodesErrorState(:final message) => EpisodesRetry(message: message),
          EpisodesInitialState() => Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }

  void _updateAndShowSnackBar(
    BuildContext context,
    Object? episode, [
    bool isCreated = false,
  ]) {
    if (episode != null && episode is Episode) {
      context.read<EpisodesBloc>().add(
        isCreated ? CreatedEpisodeEvent(episode) : UpdatedEpisodeEvent(episode),
      );
      _showSnackBar(
        context,
        "Episode ${isCreated ? 'created' : 'updated'}: '${episode.title}'",
      );
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
  }
}
