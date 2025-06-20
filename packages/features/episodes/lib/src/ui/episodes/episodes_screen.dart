import 'dart:async';

import 'package:core_domain/domain.dart';
import 'package:feature_episodes/episodes.dart';
import 'package:feature_episodes/src/ui/episodes/widgets/dismissible_list_tile.dart';
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
      ),
      child: _EpisodesBody(),
    );
  }
}

class _EpisodesBody extends StatefulWidget {
  const _EpisodesBody({super.key});

  @override
  State<_EpisodesBody> createState() => _EpisodesBodyState();
}

class _EpisodesBodyState extends State<_EpisodesBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<EpisodesBloc>().add(FetchEpisodesEvent());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<EpisodesBloc>().add(FetchEpisodesEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Podcast Manager")),
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
        builder: (context, state) {
          if (state.episodes.isEmpty) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state.isError.isNotEmpty) {
              return EpisodesRetry(message: state.isError);
            }
            return Center(child: Text('Episode list is empty'));
          }
          return RefreshIndicator(
            onRefresh: () {
              final completer = Completer<void>();
              context.read<EpisodesBloc>().add(RefreshEpisodesEvent(completer));
              return completer.future;
            },
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: state.episodes.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < state.episodes.length) {
                  final episode = state.episodes[index];
                  return DismissibleListTile(
                    id: episode.id,
                    title: episode.title,
                    description: episode.description,
                    host: episode.host,
                    onEdit: () async {
                      final newEpisode = await context.pushNamed(
                        'edit',
                        pathParameters: {'episodeId': episode.id},
                      );
                      if (context.mounted) {
                        _updateAndShowSnackBar(context, newEpisode);
                      }
                    },
                    onDelete: () => context.read<EpisodesBloc>().add(
                      DeleteEpisodeEvent(episode.id),
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: episode.host));
                      _showSnackBar(context, 'Host copy to Clipboard!');
                    },
                    onGenerate: () async {
                      final newEpisode = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => GenerateScreen(episode: episode),
                      );
                      if (context.mounted) {
                        _updateAndShowSnackBar(context, newEpisode);
                      }
                    },
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: state.isError.isEmpty
                          ? const CircularProgressIndicator()
                          : EpisodesRetry(message: state.isError),
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          );
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
