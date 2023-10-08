import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:news_app/features/news/data/api/news_api.dart';
import 'package:news_app/features/news/domain/entity/news_entity.dart';
import 'package:news_app/features/news/data/repository/news_repository_impl.dart';

class MockNewsApi extends Mock implements NewsApi {}

void main() {
  group('NewsRepositoryImpl', () {
    late NewsRepositoryImpl newsRepository;
    late MockNewsApi mockNewsApi;
    const String apiKey = 'api';

    setUp(() {
      mockNewsApi = MockNewsApi();
      newsRepository = NewsRepositoryImpl(newsApi: mockNewsApi, apiKey: apiKey);
    });

    test('getRecentNews should return a list of NewsEntity', () async {
      final List<NewsEntity> expectedNews = [
        const NewsEntity(title: 'News 1'),
        const NewsEntity(title: 'News 2'),
        const NewsEntity(title: 'News 3'),
      ];

      when(() => mockNewsApi.getRecentNews()).thenAnswer((_) async => expectedNews);

      final result = await newsRepository.getRecentNews();

      expect(result.length, 3);
      expect(result[0].title, 'News 1');
      expect(result[1].title, 'News 2');
      expect(result[2].title, 'News 3');
    });
  });
}