import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/enum/common_state_status.dart';
import 'package:flutter_book_review/src/common/model/naver_book_info_results.dart';
import 'package:flutter_book_review/src/common/model/naver_book_search_option.dart';
import 'package:flutter_book_review/src/common/repository/naver_api_repository.dart';

class SearchBookCubit extends Cubit<SearchBookState> {
  final NaverBookRepository _naverBookRepository;
  SearchBookCubit(this._naverBookRepository) : super(const SearchBookState());

  void search(String searchKey) async {
    emit(state.copyWith(status: CommonStateStatus.loading));
    var searchOption = NaverBookSearchOption(
      query: searchKey,
      display: 10,
      start: 1,
      sort: NaverBookSearchType.date,
    );
    var result = await _naverBookRepository.searchBooks(searchOption);
    print(result);
    emit(state.copyWith(status: CommonStateStatus.loaded, result: result));
  }
}

class SearchBookState extends Equatable {
  final CommonStateStatus status;
  final NaverBookInfoResults? result;

  const SearchBookState({
    this.status = CommonStateStatus.init,
    this.result,
  });

  SearchBookState copyWith({
    CommonStateStatus? status,
    NaverBookInfoResults? result,
  }) {
    return SearchBookState(
      status: status ?? this.status,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [status, result];
}
