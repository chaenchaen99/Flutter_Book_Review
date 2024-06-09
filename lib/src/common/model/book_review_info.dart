import 'package:equatable/equatable.dart';
import 'package:flutter_book_review/src/common/model/naver_book_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_review_info.g.dart';

//이 클래스는 JSON으로 직렬화될 수 있다를 나타냄
//explicitToJson = true : 직렬화할 때 내장 객체들을 명시적으로 JSON으로 변환하겠다.
@JsonSerializable(explicitToJson: true)
class BookReviewInfo extends Equatable {
  final NaverBookInfo? naverBookInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? bookId;
  final double? totalCounts;
  final List<String>? reviewerUids;

  const BookReviewInfo({
    this.naverBookInfo,
    this.createdAt,
    this.updatedAt,
    this.bookId,
    this.totalCounts,
    this.reviewerUids,
  });

  BookReviewInfo copyWith({
    NaverBookInfo? naverBookInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? bookId,
    double? totalCounts,
    List<String>? reviewerUids,
  }) {
    return BookReviewInfo(
      naverBookInfo: naverBookInfo ?? this.naverBookInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bookId: bookId ?? this.bookId,
      totalCounts: totalCounts ?? this.totalCounts,
      reviewerUids: reviewerUids ?? this.reviewerUids,
    );
  }

  factory BookReviewInfo.fromJson(Map<String, dynamic> json) =>
      _$BookReviewInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BookReviewInfoToJson(this);

  //props는 Equatable패키지가 두 객체를 비교할 때 사용하는 속성 리스트를 반환하다.
  //따라서 이 리스트에 포함된 필드들이 모두 동일하면 Equatable은 두 객체를 동일한 것으로 간주한다.
  @override
  List<Object?> get props => [
        naverBookInfo,
        createdAt,
        updatedAt,
        bookId,
        totalCounts,
        reviewerUids,
      ];
}
