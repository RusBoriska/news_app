import '/features/news/domain/entity/news_entity.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> getRecentNews();
}
