import 'package:feature_episodes/src/ui/episodes/bloc/episodes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EpisodesRetry extends StatelessWidget {
  final String message;

  const EpisodesRetry({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 3),
            ),
          );
      }
    });

    return Center(
      child: TextButton(
        onPressed: () {
          context.read<EpisodesBloc>().add(FetchEpisodesEvent());
        },
        child: Text('Retry'),
      ),
    );
  }
}
