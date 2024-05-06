import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/app.dart';
import 'package:flutter_book_review/src/common/interceptor/custom_interceptor.dart';
import 'package:flutter_book_review/src/common/model/naver_book_search_option.dart';
import 'package:flutter_book_review/src/common/repository/naver_api_repository.dart';

void main() {
  //dio 는 최초 한번만 생성
  //dio를 사용하는 이유 request, response를 보내거나 받을 때 선처리, 후처리를 interceptor라는 것을 이용하여 손쉽게 활용할 수 있다.
  Dio dio = Dio(BaseOptions(baseUrl: "https://openapi.naver.com/"));
  dio.interceptors.add(CustomInterceptor()); //인증키가 담겨서 날라가게 됨
  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;
  const MyApp({super.key, required this.dio});

  @override
  Widget build(BuildContext context) {
    //이 앱에 사용되는 repository를 여기서 전부 등록함.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => NaverBookRepository(dio),
        ),
      ],
      //공통적으로 필요한 bloc을 여기서 전부 등록함.
      child: Builder(
        builder: (context) => FutureBuilder(
          future: context.read<NaverBookRepository>().searchBooks(
                const NaverBookSearchOption.init(
                  query: '플러터',
                ),
              ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MaterialApp(
                home: Center(
                  child: Text('${snapshot.data?.items?.length}'),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
