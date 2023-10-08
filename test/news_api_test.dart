import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:news_app/features/news/data/api/news_api.dart';
// import 'package:news_app/features/news/domain/entity/news_entity.dart';


class MockDio extends Mock implements Dio {}

void main() {
  group('NewsApi', () {
    late NewsApi newsApi;
    late MockDio mockDio;
    const String apiKey = 'api';
    const String query = 'query';

    setUp(() {
      mockDio = MockDio();
      newsApi = NewsApi(dio: mockDio, apiKey: apiKey, query: query);
    });

    test('getRecentNews should return a list of NewsEntity', () async {
      final response = {
        'articles': [
          {'title': 'News 1'},
          {'title': 'News 2'},
          {'title': 'News 3'},
        ],
      };

      when(() => mockDio.get('/v2/everything?q=$query&sortBy=publishedAt&apiKey=$apiKey'))
          .thenAnswer((_) async => Response(
          data: response,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      final result = await newsApi.getRecentNews();

      expect(result.length, 3);
      expect(result[0].title, 'News 1');
      expect(result[1].title, 'News 2');
      expect(result[2].title, 'News 3');
    });
  });
}