import 'package:core_icons/icons.dart';
import 'package:feature_episodes/src/ui/episodes/widgets/InkWell_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DismissibleListTile extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String host;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onGenerate;

  const DismissibleListTile({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.host,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.blueAccent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: 32,
          height: 32,
          child: IconAssets.shared.editToolsGreen,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: 32,
          height: 32,
          child: IconAssets.shared.deleteGreen,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog.adaptive(
              title: Text("Delete episode: '$title'?"),
              actions: [
                TextButton(
                  onPressed: () => ctx.pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => ctx.pop(true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          return confirm ?? false;
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: InkWellListTile(
        title: title,
        description: description,
        host: host,
        onGenerate: onGenerate,
        onTap: onTap,
      ),
    );
  }
}
