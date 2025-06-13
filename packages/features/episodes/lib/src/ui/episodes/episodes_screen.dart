import 'package:feature_episodes/episodes.dart';
import 'package:feature_episodes/src/ui/episodes/widgets/episodes_list.dart';
import 'package:feature_episodes/src/ui/episodes/widgets/episodes_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EpisodesScreen extends StatelessWidget {
  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EpisodesBloc(fetchEpisodes: context.read())
            ..add(FetchEpisodesEvent()),
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
        onPressed: () {
          context.pushNamed('new');
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EpisodesBloc, EpisodesState>(
        builder: (context, state) => switch (state) {
          EpisodesLoadedState(:final episodes) => EpisodesList(list: episodes),
          EpisodesErrorState(:final message) => EpisodesRetry(message: message),
          EpisodesInitialState() => Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
