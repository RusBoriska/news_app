import '/features/news/domain/entity/news_entity.dart';
import '/features/news/domain/repository/news_repository.dart';

class GetRecentNewsUseCase {
  final NewsRepository newsRepositoryImpl;
  GetRecentNewsUseCase(this.newsRepositoryImpl);
  Future<List<NewsEntity>> call() async {
    return newsRepositoryImpl.getRecentNews();
  }
}
