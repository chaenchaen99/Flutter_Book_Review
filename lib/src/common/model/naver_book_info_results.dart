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

  const NaverBookInfoResults.init()
      : this(start: 1, display: 10, items: const []);

  const NaverBookInfoResults({
    this.total,
    this.start,
    this.display,
    this.items,
  });

  factory NaverBookInfoResults.fromJson(Map<String, dynamic> json) =>
      _$NaverBookInfoResultsFromJson(json);

  NaverBookInfoResults copyWith({
    List<NaverBookInfo>? items,
    int? display,
    int? start,
    int? total,
  }) {
    return NaverBookInfoResults(
      total: total ?? this.total,
      start: start ?? this.start,
      display: display ?? this.display,
      items: [...this.items ?? [], ...items ?? []],
    );
  }

  @override
  List<Object?> get props => [
        total,
        start,
        display,
        items,
      ];
}
