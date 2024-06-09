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
                naverBookInfo: naverBookInfo)));

  changeValue(double value) {
    emit(state.copyWith(reviewInfo: state.reviewInfo!.copyWith(value: value)));
  }

  changeReview(String review) {
    emit(
        state.copyWith(reviewInfo: state.reviewInfo!.copyWith(review: review)));
  }

  save() async {
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
        totalCounts: bookReviewInfo.totalCounts! + state.reviewInfo!.value!,
        reviewerUids: bookReviewInfo.reviewerUids!.toSet().toList(),
        updatedAt: DateTime.now(),
      );
      _bookReviewInfoRepository.updateBookReviewInfo(bookReviewInfo);
    }
    //   var now = DateTime.now();
    //   emit(state.copyWith(
    //       reviewInfo:
    //           state.reviewInfo!.copyWith(createdAt: now, updatedAt: now)));
    //   await _reviewRepository.createReview(state.reviewInfo!);
  }
}

class ReviewState extends Equatable {
  final Review? reviewInfo;

  const ReviewState({this.reviewInfo});

  ReviewState copyWith({
    Review? reviewInfo,
  }) {
    return ReviewState(reviewInfo: reviewInfo ?? this.reviewInfo);
  }

  @override
  List<Object?> get props => [
        reviewInfo,
      ];
}
