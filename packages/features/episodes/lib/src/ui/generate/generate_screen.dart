import 'package:core_domain/domain.dart';
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
      create: (context) =>
          GenerateTextBloc(generateText: context.read(), episode: episode),
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
  late final TextEditingController _promptController;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  String _getLineFromEpisode(Episode? episode, EpisodeTarget target) {
    if (episode == null) return '';
    return switch (target) {
      EpisodeTarget.title => episode.title,
      EpisodeTarget.description => episode.description,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero, //MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<GenerateTextBloc, GenerateTextState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Generate Alternative",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 8),
                Text(_getLineFromEpisode(state.episode, state.target)),
                const SizedBox(height: 8),
                Text(
                  state.generatedEpisode != null
                      ? "Generated: ${_getLineFromEpisode(state.generatedEpisode, state.target)}"
                      : '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _promptController,
                  decoration: InputDecoration(
                    labelText: "Prompt",
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: const OutlineInputBorder(),
                    errorText: state.error,
                  ),
                  minLines: 4,
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => context.read<GenerateTextBloc>().add(
                    ChangePromptEvent(value),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: state.isLoading
                      ? Center(child: const CircularProgressIndicator())
                      : Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: state.generatedEpisode != null
                                    ? () {
                                        context.pop(state.generatedEpisode);
                                      }
                                    : null,
                                child: const Text("Apply"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: state.prompt.isNotEmpty
                                    ? () => context
                                          .read<GenerateTextBloc>()
                                          .add(GenerateStringEvent())
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
      ),
    );
  }
}
