import 'package:feature_episodes/episodes.dart';
import 'package:feature_episodes/src/ui/edit/widgets/text_form_field_valid.dart';
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
          context.pop(state.episode);
        }
      },
      builder: (context, state) {
        final isEdit = state.episode != null;
        final bloc = context.read<EpisodeEditBloc>();
        return Scaffold(
          appBar: AppBar(title: Text(isEdit ? 'Edit' : 'Create')),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldValid(
                              hint: 'Title',
                              autocorrect: true,
                              onCheckText: (value) {
                                return state.status == StateStatus.error &&
                                        state.error.contains('Title')
                                    ? state.error
                                    : null;
                              },
                              onChanged: (value) {
                                bloc.add(ChangeTitleEpisodeEvent(value));
                              },
                            ),
                            // SizedBox(height: 16),
                            TextFormFieldValid(
                              hint: 'Description',
                              autocorrect: true,
                              onCheckText: (value) {
                                return state.status == StateStatus.error &&
                                        state.error.contains('Description')
                                    ? state.error
                                    : null;
                              },
                              onChanged: (value) {
                                bloc.add(ChangeDescriptionEpisodeEvent(value));
                              },
                            ),
                            // SizedBox(height: 16),
                            TextFormFieldValid(
                              hint: 'Host',
                              autocorrect: false,
                              onCheckText: (value) {
                                return state.status == StateStatus.error &&
                                        state.error.contains('Host')
                                    ? state.error
                                    : null;
                              },
                              onChanged: (value) {
                                bloc.add(ChangeHostEpisodeEvent(value));
                              },
                            ),
                          ],
                        ),
                      ),
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
