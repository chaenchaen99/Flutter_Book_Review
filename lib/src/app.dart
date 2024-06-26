import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/model/naver_book_info.dart';
import 'package:flutter_book_review/src/common/repository/book_review_info_repository.dart';
import 'package:flutter_book_review/src/common/repository/naver_api_repository.dart';
import 'package:flutter_book_review/src/common/repository/review_repository.dart';
import 'package:flutter_book_review/src/common/repository/user_repository.dart';
import 'package:flutter_book_review/src/home/page/home_page.dart';
import 'package:flutter_book_review/src/init/cubit/authentication_cubit.dart';
import 'package:flutter_book_review/src/login/page/login_page.dart';
import 'package:flutter_book_review/src/reivew/cubit/review_cubit.dart';
import 'package:flutter_book_review/src/reivew/page/review_page.dart';
import 'package:flutter_book_review/src/root/page/root_page.dart';
import 'package:flutter_book_review/src/search/cubit/search_book_cubit.dart';
import 'package:flutter_book_review/src/search/page/search_page.dart';
import 'package:flutter_book_review/src/signup/cubit/signup_cubit.dart';
import 'package:flutter_book_review/src/signup/page/signup_page.dart';
import 'package:go_router/go_router.dart';

import 'book_Info/page/book_info_page.dart';

//go_route사용시 stless위젯을 사용하면 저장할 때마다 화면이 갱신됨.
//따라서 route는 한번만 세팅이 되게 하기 위해서 stateful의 라이프사이클을 이용하여 사용.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late GoRouter router;
  @override
  void initState() {
    super.initState();
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: context.read<AuthenticationCubit>(),
      redirect: (context, state) {
        var authStatus = context.read<AuthenticationCubit>().state.status;
        var blockPageInAuthenticationState = ['/', '/login', '/signup'];
        print('현재상태:$authStatus');
        print('현재패스:${state.matchedLocation}');
        switch (authStatus) {
          case AuthenticationStatus.authentication:
            return blockPageInAuthenticationState.contains(state.fullPath)
                ? '/home'
                : state.matchedLocation;
          case AuthenticationStatus.unAuthenticated:
            return '/signup';
          case AuthenticationStatus.unknown:
            return '/login';
          case AuthenticationStatus.init:
            break;
          case AuthenticationStatus.error:
            break;
        }
        return state.path;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RootPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/info',
          builder: (context, state) =>
              BookInfoPage(state.extra as NaverBookInfo),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) => BlocProvider(
              create: (context) {
                var bookInfo = state.extra as NaverBookInfo;
                var uid = context.read<AuthenticationCubit>().state.user!.uid!;
                return ReviewCubit(context.read<BookReviewInfoRepository>(),
                    context.read<ReviewRepository>(), uid, bookInfo);
              },
              child: ReviewPage(state.extra as NaverBookInfo)),
        ),
        GoRoute(
            path: '/search',
            builder: (context, state) => BlocProvider(
                  create: (context) =>
                      SearchBookCubit(context.read<NaverBookRepository>()),
                  child: const SearchPage(),
                )),
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (context) => SignupCubit(
              context.read<AuthenticationCubit>().state.user!,
              context.read<UserRepository>(),
            ),
            child: const SignupPage(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xff1C1C1C),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color(0xff1C1C1C),
      ),
    );
  }
}
