import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/init/cubit/init_cubit.dart';
import 'package:flutter_book_review/src/init/page/init_page.dart';
import 'package:flutter_book_review/src/splash/page/splash_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitCubit, bool>(builder: (context, state) {
      return state ? const SplashPage() : const InitPage();
    });
  }
}
