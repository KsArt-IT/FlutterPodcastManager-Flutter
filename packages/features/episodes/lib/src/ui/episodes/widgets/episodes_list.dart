import 'dart:async';

import 'package:core_domain/domain.dart';
import 'package:feature_episodes/episodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodesList extends StatelessWidget {
  final List<Episode> list;

  const EpisodesList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        final completer = Completer<void>();
        context.read<EpisodesBloc>().add(RefreshEpisodesEvent(completer));
        return completer.future;
      },
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return ListTile(
            key: item.id.isNotEmpty ? ValueKey(item.id) : null,
            title: Text(item.title),
            subtitle: Text(item.description),
            onTap: () {
              // TODO: open host
              item.host;
            },
          );
        },
      ),
    );
  }
}
