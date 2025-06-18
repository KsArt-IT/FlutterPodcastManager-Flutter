import 'package:core_data/data.dart';
import 'package:core_domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_podcast_manager/app/podcast_manager_app.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PodcastApiService>(
          create: (_) => PodcastApiService(dio),
        ),
        RepositoryProvider<PodcastRepository>(
          create: (context) => PodcastRepositoryImpl(service: context.read()),
        ),
        RepositoryProvider<ApiService>(
          create: (_) {
            if (dotenv.env['USE_KEY'] == 'DEESEEK_API_KEY') {
              return DeepSeekApiService(dio) as ApiService<DeepSeekResponse>;
            }
            return HuggingFaceApiService(dio)
                as ApiService<HuggingFaceResponse>;
          },
        ),
        RepositoryProvider<LlmGenerateRepository>(
          create: (context) {
            final ApiService service = context.read();
            if (service is ApiService<DeepSeekResponse>) {
              return DeepSeekGenerateRepositoryImpl(
                service: service,
                apiKey: dotenv.env['DEESEEK_API_KEY'] ?? '',
              );
            }
            if (service is ApiService<HuggingFaceResponse>) {
              return HuggingFaceGenerateRepositoryImpl(
                service: service,
                apiKey: dotenv.env['HUGGINGFACE_API_KEY'] ?? '',
              );
            }
            throw Exception("Error: required service not available!");
          },
        ),
        RepositoryProvider<FetchEpisodesUseCase>(
          create: (context) => FetchEpisodesUseCase(context.read()),
        ),
        RepositoryProvider<FetchEpisodeUseCase>(
          create: (context) => FetchEpisodeUseCase(context.read()),
        ),
        RepositoryProvider<CreateEpisodeUseCase>(
          create: (context) => CreateEpisodeUseCase(context.read()),
        ),
        RepositoryProvider<UpdateEpisodeUseCase>(
          create: (context) => UpdateEpisodeUseCase(context.read()),
        ),
        RepositoryProvider<DeleteEpisodeUseCase>(
          create: (context) => DeleteEpisodeUseCase(context.read()),
        ),
        RepositoryProvider<GenerateEpisodeUseCase>(
          create: (context) => GenerateEpisodeUseCase(context.read()),
        ),
      ],
      child: PodcastManagerApp(),
    );
  }
}
