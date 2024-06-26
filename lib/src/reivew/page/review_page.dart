import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/components/app_divider.dart';
import 'package:flutter_book_review/src/common/components/app_font.dart';
import 'package:flutter_book_review/src/common/components/btn.dart';
import 'package:flutter_book_review/src/common/components/review_slider_bar.dart';
import 'package:flutter_book_review/src/common/model/naver_book_info.dart';
import 'package:flutter_book_review/src/reivew/cubit/review_cubit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ReviewPage extends StatelessWidget {
  final NaverBookInfo naverBookInfo;
  const ReviewPage(this.naverBookInfo, {super.key});

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
        title: const AppFont('리뷰 작성', fontSize: 18),
      ),
      body: Column(
        children: [
          _HeaderBookInfo(naverBookInfo),
          const AppDivider(),
          Expanded(
              child: BlocBuilder<ReviewCubit, ReviewState>(
                  buildWhen: (previous, current) =>
                      current.isEditMode != previous.isEditMode,
                  builder: (context, state) {
                    return _ReviewBox(
                      initReview: state.reviewInfo?.review,
                    );
                  })),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(context).padding.bottom),
        child: Btn(
          onTap: context.read<ReviewCubit>().save,
          text: '저장',
        ),
      ),
    );
  }
}

class _ReviewBox extends StatefulWidget {
  final String? initReview;
  const _ReviewBox({super.key, this.initReview});

  @override
  State<_ReviewBox> createState() => _ReviewBoxState();
}

class _ReviewBoxState extends State<_ReviewBox> {
  TextEditingController editingController = TextEditingController();

  @override
  void didUpdateWidget(covariant _ReviewBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    editingController.text = widget.initReview ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: editingController,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "리뷰를 입력하세요",
        contentPadding: EdgeInsets.symmetric(horizontal: 25),
        hintStyle: TextStyle(
          color: Color(0xff585858),
        ),
      ),
      onChanged: context.read<ReviewCubit>().changeReview,
      style: const TextStyle(color: Colors.white),
    );
  }
}

class _HeaderBookInfo extends StatelessWidget {
  final NaverBookInfo bookInfo;
  const _HeaderBookInfo(this.bookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: 71,
              height: 106,
              child: Image.network(
                bookInfo.image ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppFont(
                  ((bookInfo.title ?? '').length) > 65
                      ? '${bookInfo.title?.substring(0, 65)}...'
                      : bookInfo.title!,
                  fontSize: 16,
                  maxLine: 2,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 5,
                ),
                AppFont(
                  bookInfo.author ?? '',
                  fontSize: 12,
                  color: const Color(0xff878787),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<ReviewCubit, ReviewState>(
                    builder: ((context, state) {
                  return ReviewSliderBar(
                    initValue: state.reviewInfo?.value ?? 0,
                    onChange: context.read<ReviewCubit>().changeValue,
                  );
                })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
