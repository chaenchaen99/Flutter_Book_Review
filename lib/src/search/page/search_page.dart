import 'package:flutter/material.dart';
import 'package:flutter_book_review/src/common/components/app_font.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppFont('검색'),
      ),
    );
  }
}
