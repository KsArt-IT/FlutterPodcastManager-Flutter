import 'package:core_domain/domain.dart';
import 'package:flutter/material.dart';

class EpisodesList extends StatelessWidget {
  final List<Episode> list;

  const EpisodesList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return ListTile(
          key: item.id != null ? ValueKey(item.id) : null,
          title: Text(item.title),
          subtitle: Text(item.description),
          onTap: () {
            // TODO: open host
            item.host;
          },
        );
      },
    );
  }
}
