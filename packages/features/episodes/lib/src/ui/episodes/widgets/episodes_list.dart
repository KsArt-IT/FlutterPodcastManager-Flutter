import 'dart:async';

import 'package:core_domain/domain.dart';
import 'package:feature_episodes/src/ui/episodes/widgets/dismissible_list_tile.dart';
import 'package:flutter/material.dart';

class EpisodesList extends StatelessWidget {
  final List<Episode> list;
  final Function(Completer) onRefresh;
  final Function(String) onEdit;
  final Function(String) onDelete;
  final Function(String) onTap;
  final Function(Episode) onGenerate;

  const EpisodesList({
    super.key,
    required this.list,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        final completer = Completer<void>();
        onRefresh(completer);
        return completer.future;
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return DismissibleListTile(
            id: item.id,
            title: item.title,
            description: item.description,
            onEdit: () => onEdit(item.id),
            onDelete: () => onDelete(item.id),
            onTap: () => onTap(item.id),
            onGenerate: () => onGenerate(item),
          );
        },
      ),
    );
  }
}
