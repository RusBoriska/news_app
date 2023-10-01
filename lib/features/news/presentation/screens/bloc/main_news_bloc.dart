import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/core/shared/queries.dart';
import '/core/di/service_locator.dart';
import '/features/news/domain/entity/news_entity.dart';
import '/features/news/domain/usecase/get_recent_news_usecase.dart';



part 'main_news_event.dart';
part 'main_news_state.dart';

class MainNewsBloc extends Bloc<MainNewsEvent, MainNewsState> {
  MainNewsBloc() : super(MainNewsInitialState()) {
    on<MainNewsGetRecentNewsEvent>(mainNewsGetRecentNewsEvent);
  }

  FutureOr<void> mainNewsGetRecentNewsEvent(
      MainNewsGetRecentNewsEvent event, Emitter<MainNewsState> emit) async {
    try {
      emit(MainNewsLoadingState());
      Query.query = event.query;
      List<NewsEntity> news =
          await serviceLocator<GetRecentNewsUseCase>().call();
      emit(MainNewsGetRecentNewsSuccessState(news));
    } catch (e) {
      emit(MainNewsErrorState("Something Went Wrong"));
    }
  }
}
