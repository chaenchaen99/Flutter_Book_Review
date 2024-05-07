import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_book_review/src/common/components/app_font.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/splash_bg.png',
          fit: BoxFit.cover,
        ),
        Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppFont(
                  '도서 리뷰 앱으로\n좋아하는 책을 찾아보세요',
                  textAlign: TextAlign.center,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 20,
                ),
                AppFont(
                  '데이터 로드 중 입니다.',
                  textAlign: TextAlign.center,
                  fontSize: 13,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ))
      ],
    ));
  }
}
