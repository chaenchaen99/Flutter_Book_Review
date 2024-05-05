import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //이 앱에 사용되는 repository를 여기서 전부 등록함.
    return MultiRepositoryProvider(
      providers: const [],
      //공통적으로 필요한 bloc을 여기서 전부 등록함.
      child: MultiBlocProvider(
        providers: const [],
        child: const App(),
      ),
    );
  }
}
