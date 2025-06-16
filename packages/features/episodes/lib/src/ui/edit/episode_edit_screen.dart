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
        id: id,
      ),
      child: _EpisodeEditBody(id: id),
    );
  }
}

class _EpisodeEditBody extends StatelessWidget {
  final bool isEdit;

  const _EpisodeEditBody({super.key, required String? id})
    : isEdit = id != null;

  @override
  Widget build(BuildContext context) {
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
                        BlocBuilder<EpisodeEditBloc, EpisodeEditState>(
                          buildWhen: (previous, current) =>
                              previous.title != current.title,
                          builder: (context, state) {
                            return TextFormFieldValid(
                              value: state.title,
                              hint: 'Title',
                              autocorrect: true,
                              onCheckText: (value) {
                                return state.status == StateStatus.error &&
                                        state.error.contains('Title')
                                    ? state.error
                                    : null;
                              },
                              onChanged: (value) => context
                                  .read<EpisodeEditBloc>()
                                  .add(ChangeTitleEpisodeEvent(value)),
                            );
                          },
                        ),
                        BlocBuilder<EpisodeEditBloc, EpisodeEditState>(
                          buildWhen: (previous, current) =>
                              previous.description != current.description,
                          builder: (context, state) {
                            return TextFormFieldValid(
                              value: state.description,
                              hint: 'Description',
                              autocorrect: true,
                              onCheckText: (value) {
                                return state.status == StateStatus.error &&
                                        state.error.contains('Description')
                                    ? state.error
                                    : null;
                              },
                              onChanged: (value) => context
                                  .read<EpisodeEditBloc>()
                                  .add(ChangeDescriptionEpisodeEvent(value)),
                            );
                          },
                        ),
                        BlocBuilder<EpisodeEditBloc, EpisodeEditState>(
                          buildWhen: (previous, current) =>
                              previous.host != current.host,
                          builder: (context, state) {
                            return TextFormFieldValid(
                              value: state.host,
                              hint: 'Host',
                              autocorrect: false,
                              onCheckText: (value) {
                                return state.status == StateStatus.error &&
                                        state.error.contains('Host')
                                    ? state.error
                                    : null;
                              },
                              onChanged: (value) => context
                                  .read<EpisodeEditBloc>()
                                  .add(ChangeHostEpisodeEvent(value)),
                            );
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
              child: BlocConsumer<EpisodeEditBloc, EpisodeEditState>(
                listener: (context, state) {
                  if (state.status == StateStatus.success) {
                    context.pop(state.episode);
                  }
                },
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.status == StateStatus.valid
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
  }
}
