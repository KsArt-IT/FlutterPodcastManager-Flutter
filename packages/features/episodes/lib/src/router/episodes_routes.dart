import 'package:feature_episodes/episodes.dart';
import 'package:go_router/go_router.dart';

class EpisodesRoutes {
  static const String path = '/episodes';

  static final GoRoute route = GoRoute(
    path: path,
    name: 'episodes',
    builder: (context, state) => const EpisodesScreen(),
    routes: <RouteBase>[
      GoRoute(
        path: 'new',
        builder: (context, state) => const EpisodeEditScreen(),
        //
      ),
      GoRoute(
        path: 'edit/:episodeId',
        builder: (context, state) =>
            EpisodeEditScreen(id: state.pathParameters['episodeId']),
        //
      ),
    ],
  );
}
