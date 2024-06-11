import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/model/book_review_info.dart';
import 'package:flutter_book_review/src/common/model/naver_book_info.dart';
import 'package:flutter_book_review/src/common/model/review.dart';
import 'package:flutter_book_review/src/common/repository/book_review_info_repository.dart';
import 'package:flutter_book_review/src/common/repository/review_repository.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final BookReviewInfoRepository _bookReviewInfoRepository;
  final ReviewRepository _reviewRepository;

  ReviewCubit(this._bookReviewInfoRepository, this._reviewRepository, uid,
      NaverBookInfo naverBookInfo)
      : super(ReviewState(
            reviewInfo: Review(
                bookId: naverBookInfo.isbn,
                reviewerUId: uid,
                naverBookInfo: naverBookInfo))) {
    _loadReviewInfo();
  }

  _loadReviewInfo() async {
    var reviewInfo = await _reviewRepository.loadReviewInfo(
        state.reviewInfo!.bookId!, state.reviewInfo!.reviewerUId!);
    emit(state.copyWith(
      isEditMode: reviewInfo != null,
      reviewInfo: reviewInfo,
      beforeValue: reviewInfo?.value,
    ));
  }

  changeValue(double value) {
    emit(state.copyWith(reviewInfo: state.reviewInfo!.copyWith(value: value)));
  }

  changeReview(String review) {
    emit(
        state.copyWith(reviewInfo: state.reviewInfo!.copyWith(review: review)));
  }

  Future<void> insert() async {
    var now = DateTime.now();
    emit(state.copyWith(
        reviewInfo:
            state.reviewInfo!.copyWith(createdAt: now, updatedAt: now)));
    await _reviewRepository.createReview(state.reviewInfo!);

    var bookId = state.reviewInfo!.bookId!;
    var bookReviewInfo =
        await _bookReviewInfoRepository.loadBookReviewInfo(bookId);
    if (bookReviewInfo == null) {
      //insert
      var bookReviewInfo = BookReviewInfo(
        bookId: bookId,
        totalCounts: state.reviewInfo!.value,
        naverBookInfo: state.reviewInfo!.naverBookInfo!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        reviewerUids: [state.reviewInfo!.reviewerUId!],
      );
      _bookReviewInfoRepository.createBookReviewInfo(bookReviewInfo);
    } else {
      //update
      bookReviewInfo.reviewerUids!.add(state.reviewInfo!.reviewerUId!);
      bookReviewInfo = bookReviewInfo.copyWith(
        totalCounts: bookReviewInfo.totalCounts! -
            (state.beforeValue ?? 0) +
            state.reviewInfo!.value!,
        reviewerUids: bookReviewInfo.reviewerUids!.toSet().toList(),
        updatedAt: DateTime.now(),
      );
      _bookReviewInfoRepository.updateBookReviewInfo(bookReviewInfo);
    }
  }

  Future<void> update() async {
    var updateData = state.reviewInfo!.copyWith(updatedAt: DateTime.now());
    await _reviewRepository.updateReview(updateData);
    var bookReviewInfo =
        await _bookReviewInfoRepository.loadBookReviewInfo(updateData.bookId!);
    if (bookReviewInfo != null) {
      bookReviewInfo = bookReviewInfo.copyWith(
        updatedAt: DateTime.now(),
        totalCounts: bookReviewInfo.totalCounts! -
            (state.beforeValue ?? 0) +
            state.reviewInfo!.value!,
      );
      await _bookReviewInfoRepository.updateBookReviewInfo(bookReviewInfo);
    }
  }

  save() async {
    if (state.isEditMode!) {
      //수정하기
      await update();
    } else {
      //등록하기
      await insert();
    }
  }
}

class ReviewState extends Equatable {
  final Review? reviewInfo;
  final bool? isEditMode;
  final double? beforeValue;

  const ReviewState({
    this.reviewInfo,
    this.isEditMode,
    this.beforeValue,
  });

  ReviewState copyWith(
      {Review? reviewInfo, bool? isEditMode, double? beforeValue}) {
    return ReviewState(
      reviewInfo: reviewInfo ?? this.reviewInfo,
      isEditMode: isEditMode ?? this.isEditMode,
      beforeValue: beforeValue ?? this.beforeValue,
    );
  }

  @override
  List<Object?> get props => [
        reviewInfo,
        isEditMode,
        beforeValue,
      ];
}
