part of 'main_news_bloc.dart';

abstract class MainNewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class MainNewsGetRecentNewsEvent extends MainNewsEvent {
  final String query;

  MainNewsGetRecentNewsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

  // Original
// class MainNewsGetRecentNewsEvent extends MainNewsEvent {}
