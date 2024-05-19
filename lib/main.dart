import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/firebase_options.dart';
import 'package:flutter_book_review/src/app.dart';
import 'package:flutter_book_review/src/common/cubit/app_data_load_cubit.dart';
import 'package:flutter_book_review/src/common/interceptor/custom_interceptor.dart';
import 'package:flutter_book_review/src/common/model/naver_book_search_option.dart';
import 'package:flutter_book_review/src/common/repository/authentication_repository.dart';
import 'package:flutter_book_review/src/common/repository/naver_api_repository.dart';
import 'package:flutter_book_review/src/common/repository/user_repository.dart';
import 'package:flutter_book_review/src/init/cubit/authentication_cubit.dart';
import 'package:flutter_book_review/src/init/cubit/init_cubit.dart';
import 'package:flutter_book_review/src/splash/cubit/splash_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
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
    var db = FirebaseFirestore.instance;

    //이 앱에 사용되는 repository를 여기서 전부 등록함.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => NaverBookRepository(dio),
        ),
        RepositoryProvider(
          create: (context) => AuthenticationRepository(FirebaseAuth.instance),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(db),
        ),
      ],
      //공통적으로 필요한 bloc을 여기서 전부 등록함.
      child: MultiBlocProvider(providers: [
        BlocProvider(
          create: (context) => AppDataLoadCubit(),
          lazy: false, //등록되는 순가 바로 인스턴스 생성 => loadData() 바로 호출
        ),
        BlocProvider(
          create: (context) => SplashCubit(),
        ),
        BlocProvider(
          create: (context) => InitCubit(),
        ),
        BlocProvider(
          create: (context) => AuthenticationCubit(
            context.read<AuthenticationRepository>(),
            context.read<UserRepository>(),
          ),
        ),
      ], child: const App()),
    );
  }
}
