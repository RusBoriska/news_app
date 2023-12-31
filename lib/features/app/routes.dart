import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '/core/di/service_locator.dart';
import '/features/news/presentation/screens/bloc/main_news_bloc.dart';
import '/features/news/presentation/screens/main_news_screen/main_news_screen.dart';

class AppRouter {
  GoRouter generateRoute() {
    return GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider.value(
            value: serviceLocator<MainNewsBloc>()
              // ..add(MainNewsGetRecentNewsEvent())
            ,
            child: const MainNewsScreen(),
          );
        },
      )
    ]);
  }
}
