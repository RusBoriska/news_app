import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '/core/network/network_client.dart';
import '/core/shared/constants.dart';
import '/core/shared/queries.dart';
import '/features/news/data/api/news_api.dart';
import '/features/news/data/repository/news_repository_impl.dart';
import '/features/news/domain/repository/news_repository.dart';
import '/features/news/domain/usecase/get_recent_news_usecase.dart';
import '/features/news/presentation/screens/bloc/main_news_bloc.dart';

final serviceLocator = GetIt.instance;

setupServiceLocator() async {
  serviceLocator.registerFactory<Constant>(() => Constant());
  serviceLocator.registerFactory<Query>(() => Query());
  serviceLocator.registerFactory<Dio>(
    () => NetworkClient(Dio(), constant: serviceLocator()).dio,
  );

  // News
  serviceLocator.registerFactory<MainNewsBloc>(() => MainNewsBloc());
  serviceLocator.registerFactory<NewsApi>(() => NewsApi(
      dio: serviceLocator<Dio>(), apiKey: serviceLocator<Constant>().apiKey, query: Query.query));
  serviceLocator.registerFactory<NewsRepository>(() => NewsRepositoryImpl(
      newsApi: serviceLocator<NewsApi>(), apiKey: serviceLocator<Constant>().apiKey));
  serviceLocator.registerFactory<GetRecentNewsUseCase>(
          () => GetRecentNewsUseCase(serviceLocator<NewsRepository>()));
}
