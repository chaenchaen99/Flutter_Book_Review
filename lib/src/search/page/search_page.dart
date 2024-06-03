import 'package:flutter/material.dart';
import 'package:flutter_book_review/src/common/components/app_font.dart';
import 'package:flutter_book_review/src/common/components/input_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          //behaviour: GestureDetector가 자식위젯의 탭 제스처를 감지하는 방법을 제어하는 데 사용
          //HitTestbehaviour.deferToChild: 탭 제스처를 감지하지만 이벤트를 자식 위젯으로 전달하지 않음
          //HitTestbehaviour.opaque: 탭 제스처를 감지하고 이벤트를 자식위젯에 전달
          //HitTestbehaviour.translucent: 탭 제스처를 감지하고 투명한 부분을 포함해서 자식 위젯에 이벤트를 전달
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset('assets/svg/icons/icon_arrow_back.svg'),
          ),
        ),
        title: const AppFont(
          '검색',
          fontSize: 18,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            InputWidget(),
          ],
        ),
      ),
    );
  }
}
