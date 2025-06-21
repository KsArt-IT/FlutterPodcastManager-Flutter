import 'package:core_domain/domain.dart';
import 'package:core_icons/icons.dart';
import 'package:feature_episodes/src/ui/generate/bloc/generate_text_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GenerateScreen extends StatelessWidget {
  final Episode episode;
  const GenerateScreen({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenerateTextBloc(
        generateText: context.read(),
        updateEpisodes: context.read(),
        episode: episode,
      ),
      child: Material(child: _GenerateBody()),
    );
  }
}

class _GenerateBody extends StatefulWidget {
  const _GenerateBody({super.key});

  @override
  State<_GenerateBody> createState() => _GenerateBodyState();
}

class _GenerateBodyState extends State<_GenerateBody> {
  late final TextEditingController _textController;
  late final TextEditingController _promptController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _promptController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocConsumer<GenerateTextBloc, GenerateTextState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.pop(state.generatedEpisode);
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: IconAssets.shared.huggingFace,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Generate Alternative",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SegmentedButton<EpisodeTarget>(
                segments: EpisodeTarget.values
                    .map(
                      (t) => ButtonSegment<EpisodeTarget>(
                        value: t,
                        label: SizedBox(
                          width: 120,
                          child: Center(child: Text(t.label)),
                        ),
                      ),
                    )
                    .toList(),
                selected: {state.target},
                showSelectedIcon: false,
                onSelectionChanged: (newSelection) {
                  context.read<GenerateTextBloc>().add(
                    SelectTargetEvent(newSelection.first),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                child: Column(
                  children: [
                    Text(
                      _getLineFromEpisode(state.episode, state.target),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<GenerateTextBloc, GenerateTextState>(
                      buildWhen: (previous, current) =>
                          previous.generatedEpisode !=
                              current.generatedEpisode ||
                          previous.target != current.target,
                      builder: (context, state) {
                        final generatedText = _getLineFromEpisode(
                          state.generatedEpisode,
                          state.target,
                        );
                        if (_textController.text != generatedText) {
                          _textController.text = generatedText;
                        }
                        return TextField(
                          enabled: generatedText.isNotEmpty,
                          controller: _textController,
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          minLines: 2,
                          maxLines: 2,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          onChanged: (value) => context
                              .read<GenerateTextBloc>()
                              .add(ChangeTextEvent(value)),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<GenerateTextBloc, GenerateTextState>(
                      buildWhen: (previous, current) =>
                          previous.prompt != current.prompt,
                      builder: (context, state) {
                        return TextField(
                          controller: _promptController,
                          decoration: InputDecoration(
                            labelText: "Prompt",
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            border: const OutlineInputBorder(),
                            errorText: state.error,
                          ),
                          minLines: 3,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) => context
                              .read<GenerateTextBloc>()
                              .add(ChangePromptEvent(value)),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: state.isLoading
                    ? Center(child: const CircularProgressIndicator())
                    : Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: _canApply(state.generatedEpisode)
                                  ? () => context.read<GenerateTextBloc>().add(
                                      ApplyEpisodeEvent(),
                                    )
                                  : null,
                              child: const Text("Apply"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: state.prompt.isNotEmpty
                                  ? () => context.read<GenerateTextBloc>().add(
                                      GenerateStringEvent(),
                                    )
                                  : null,
                              child: const Text("Generate"),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getLineFromEpisode(Episode? episode, EpisodeTarget target) {
    if (episode == null) return '';
    return switch (target) {
      EpisodeTarget.title => episode.title,
      EpisodeTarget.description => episode.description,
    };
  }

  bool _canApply(Episode? episode) {
    if (episode == null) return false;
    return episode.title.isNotEmpty && episode.description.isNotEmpty;
  }
}
