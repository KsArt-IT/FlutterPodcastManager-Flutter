import 'package:feature_episodes/episodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EpisodeEditScreen extends StatelessWidget {
  final String? id;
  const EpisodeEditScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EpisodeEditBloc(
        fetchEpisode: context.read(),
        createEpisode: context.read(),
        updateEpisodes: context.read(),
      )..add(id != null ? EditEpisodeEvent(id!) : CreateEpisodeEvent()),
      child: _EpisodeEditBody(),
    );
  }
}

class _EpisodeEditBody extends StatelessWidget {
  const _EpisodeEditBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EpisodeEditBloc, EpisodeEditState>(
      listener: (context, state) {
        if (state.status == StateStatus.success) {
          context.pop();
        }
      },
      builder: (context, state) {
        final isEdit = state.episode != null;
        return Scaffold(
          appBar: AppBar(title: Text(isEdit ? 'Edit' : 'Create')),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: 'Title'),
                          textInputAction: TextInputAction.next,
                          autocorrect: true,
                        ),
                        SizedBox(),
                        TextField(
                          decoration: InputDecoration(hintText: 'Description'),
                          textInputAction: TextInputAction.next,
                          autocorrect: true,
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: 'Host'),
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: BlocBuilder<EpisodeEditBloc, EpisodeEditState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      final isEnabled = state.status == StateStatus.valid;
                      return ElevatedButton(
                        onPressed: isEnabled
                            ? () {
                                context.read<EpisodeEditBloc>().add(
                                  SaveEpisodeEvent(),
                                );
                              }
                            : null,
                        child: Text(isEdit ? 'Update' : 'Create'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
