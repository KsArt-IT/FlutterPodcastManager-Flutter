import 'package:feature_episodes/episodes.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (_, __) => EpisodesRoutes.path,
      //
    ),
    EpisodesRoutes.route,
  ],
);
