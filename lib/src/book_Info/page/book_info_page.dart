import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_book_review/src/common/components/app_divider.dart';
import 'package:flutter_book_review/src/common/components/app_font.dart';
import 'package:flutter_book_review/src/common/components/btn.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../common/model/naver_book_info.dart';

class BookInfoPage extends StatelessWidget {
  final NaverBookInfo bookInfo;
  const BookInfoPage(this.bookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset('assets/svg/icons/icon_arrow_back.svg'),
          ),
        ),
        title: const AppFont('책 소개', fontSize: 18),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _BookDisplayLayer(bookInfo),
            const AppDivider(),
            _BookSimpleInfoLayer(bookInfo),
            const _ReviewerLayer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(context).padding.bottom),
        child: Btn(
          onTap: () {},
          text: '리뷰하기',
        ),
      ),
    );
  }
}

class _ReviewerLayer extends StatelessWidget {
  const _ReviewerLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: AppFont(
        '아직 리뷰가 없습니다',
        fontSize: 17,
      ),
    );
  }
}

class _BookSimpleInfoLayer extends StatelessWidget {
  final NaverBookInfo bookInfo;
  const _BookSimpleInfoLayer(this.bookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppFont(
            '간단 소개',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 20,
          ),
          AppFont(
            bookInfo.description ?? '',
            fontSize: 13,
            lineHeight: 1.5,
            color: const Color(0xff898989),
          ),
        ],
      ),
    );
  }
}

class _BookDisplayLayer extends StatelessWidget {
  final NaverBookInfo bookInfo;
  const _BookDisplayLayer(this.bookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: 152,
              height: 227,
              child: Image.network(
                bookInfo.image ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/icons/icon_star.svg'),
              const SizedBox(width: 5),
              const AppFont(
                '8.88',
                fontSize: 16,
                color: Color(0xffF4AABB),
              )
            ],
          ),
          const SizedBox(height: 20),
          AppFont(
            bookInfo.title ?? '',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          AppFont(
            bookInfo.author ?? '',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xff878787),
          ),
        ],
      ),
    );
  }
}
