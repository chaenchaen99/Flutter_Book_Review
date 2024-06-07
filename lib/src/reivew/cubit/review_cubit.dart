import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/model/naver_book_info.dart';
import 'package:flutter_book_review/src/common/model/review.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(String uid, NaverBookInfo naverBookInfo)
      : super(ReviewState(
            reviewInfo: Review(reviewerId: uid, naverBookInfo: naverBookInfo)));

  changeValue(double value) {
    emit(state.copyWith(reviewInfo: state.reviewInfo!.copyWith(value: value)));
  }

  changeReview(String review) {
    emit(
        state.copyWith(reviewInfo: state.reviewInfo!.copyWith(review: review)));
  }

  save() async {
    print(state.reviewInfo);
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
