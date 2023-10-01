import 'package:dio/dio.dart';
import '/features/news/domain/entity/news_entity.dart';

class NewsApi {
  final Dio dio;
  final String apiKey;
  final String query;
  NewsApi({required this.dio, required this.apiKey, required this.query});
  Future<List<NewsEntity>> getRecentNews() async {
    final res = await dio
        .get('/v2/everything?q=$query&sortBy=publishedAt&apiKey=$apiKey');
    return List<Map<String, dynamic>>.from(res.data['articles'])
        .map((e) => NewsEntity.fromJson(e))
        .toList();
  }
}
