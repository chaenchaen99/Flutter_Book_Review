import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/components/app_font.dart';
import 'package:flutter_book_review/src/common/components/input_widget.dart';
import 'package:flutter_book_review/src/common/enum/common_state_status.dart';
import 'package:flutter_book_review/src/common/model/naver_book_info.dart';
import 'package:flutter_book_review/src/search/cubit/search_book_cubit.dart';
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
          child: const Padding(
            padding: EdgeInsets.all(15.0),
            // child: SvgPicture.asset('assets/svg/icons/icon_arrow_back.svg'),
          ),
        ),
        title: const AppFont(
          '검색',
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            InputWidget(
              onSearch: context.read<SearchBookCubit>().search,
            ),
            const Expanded(
              child: _SearchResultView(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultView extends StatefulWidget {
  const _SearchResultView({super.key});

  @override
  State<_SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<_SearchResultView> {
  ScrollController controller = ScrollController();
  late SearchBookCubit cubit;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.offset > controller.position.maxScrollExtent - 100 &&
          cubit.state.status == CommonStateStatus.loaded) {
        cubit.nextPage();
      }
    });
  }

  // @override
  Widget _messageView(String message) {
    return Center(
      child: AppFont(
        message,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget result() {
    return ListView.separated(
      controller: controller,
      itemBuilder: (context, index) {
        NaverBookInfo bookInfo = cubit.state.result!.items![index];
        return GestureDetector(
          onTap: () {
            //  context.push('/info', extra: bookInfo);
          },
          behavior: HitTestBehavior.translucent,
          child: Row(
            children: [
              SizedBox(
                width: 75,
                height: 115,
                child: Image.network(bookInfo.image ?? ''),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppFont(
                      bookInfo.title ?? '',
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 7),
                    AppFont(
                      bookInfo.author ?? '',
                      fontSize: 13,
                      color: const Color(0xff878787),
                    ),
                    const SizedBox(height: 13),
                    AppFont(
                      bookInfo.description ?? '',
                      fontSize: 12,
                      color: const Color(0xff838383),
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Divider(color: Color(0xff262626)),
      ),
      itemCount: cubit.state.result?.items?.length ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    cubit = context.watch<SearchBookCubit>();

    if (cubit.state.status == CommonStateStatus.init) {
      return _messageView('리뷰할 책을 찾아보세요.');
    }
    if (cubit.state.status == CommonStateStatus.loaded &&
        (cubit.state.result == null || cubit.state.result!.items!.isEmpty)) {
      return _messageView('검색된 결과가 없습니다.');
    }
    return result();
  }
}
