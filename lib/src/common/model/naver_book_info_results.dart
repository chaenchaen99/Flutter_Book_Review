import 'package:equatable/equatable.dart';
import 'package:flutter_book_review/src/common/model/naver_book_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'naver_book_info_results.g.dart';

@JsonSerializable()
class NaverBookInfoResults extends Equatable {
  final int? total;
  final int? start;
  final int? display;
  final List<NaverBookInfo>? items;

  const NaverBookInfoResults({
    required this.total,
    required this.start,
    required this.display,
    required this.items,
  });

  factory NaverBookInfoResults.fromJson(Map<String, dynamic> json) =>
      _$NaverBookInfoResultsFromJson(json);

  @override
  List<Object?> get props => [
        total,
        start,
        display,
        items,
      ];
}
