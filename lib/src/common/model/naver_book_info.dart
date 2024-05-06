import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'naver_book_info.g.dart';

@JsonSerializable()
class NaverBookInfo extends Equatable {
  final String? title;
  final String? link;
  final String? image;
  final String? author;
  final String? discount;
  final String? publisher;
  final String? pubdate;
  final String? isbn;
  final String? description;

  const NaverBookInfo({
    required this.title,
    required this.link,
    required this.image,
    required this.author,
    required this.discount,
    required this.publisher,
    required this.pubdate,
    required this.isbn,
    required this.description,
  });

  factory NaverBookInfo.fromJson(Map<String, dynamic> json) =>
      _$NaverBookInfoFromJson(json);

  @override
  List<Object?> get props => [
        title,
        link,
        image,
        author,
        discount,
        publisher,
        pubdate,
        isbn,
        description,
      ];
}
