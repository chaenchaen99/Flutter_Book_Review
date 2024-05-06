import 'package:dio/dio.dart';
import 'package:flutter_book_review/src/common/model/naver_book_info_results.dart';
import 'package:flutter_book_review/src/common/model/naver_book_search_option.dart';

class NaverBookRepository {
  final Dio _dio;
  NaverBookRepository(this._dio);

  Future<NaverBookInfoResults> searchBooks(
      NaverBookSearchOption searchOption) async {
    var response = await _dio.get('v1/search/book.json',
        queryParameters: searchOption.toMap());
    return NaverBookInfoResults.fromJson(response.data);
  }
}
