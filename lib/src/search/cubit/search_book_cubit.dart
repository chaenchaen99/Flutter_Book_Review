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
    emit(state.copyWith(
        status: CommonStateStatus.loading,
        searchOption: state.searchOption!.copyWith(
          query: searchKey,
        )));
    var searchOption = NaverBookSearchOption(
      query: searchKey,
      display: 10,
      start: 1,
      sort: NaverBookSearchType.date,
    );
    var result = await _naverBookRepository.searchBooks(state.searchOption!);
    if (result.start! > result.total! || result.items!.isEmpty) {
      emit(state.copyWith(status: CommonStateStatus.complete));
    } else {
      emit(state.copyWith(
          status: CommonStateStatus.loaded,
          result: state.result!.copyWith(items: result.items)));
    }
  }

  void nextPage() {
    emit(
      state.copyWith(
        status: CommonStateStatus.loading,
        searchOption: state.searchOption!.copyWith(
          start: state.searchOption!.start! + state.searchOption!.display!,
        ),
      ),
    );
    search(state.searchOption!.query ?? '');
  }
}

class SearchBookState extends Equatable {
  final CommonStateStatus status;
  final NaverBookInfoResults? result;
  final NaverBookSearchOption? searchOption;

  const SearchBookState({
    this.status = CommonStateStatus.init,
    this.result = const NaverBookInfoResults.init(),
    this.searchOption = const NaverBookSearchOption.init(query: ''),
  });

  SearchBookState copyWith({
    CommonStateStatus? status,
    NaverBookInfoResults? result,
    NaverBookSearchOption? searchOption,
  }) {
    return SearchBookState(
      status: status ?? this.status,
      result: result ?? this.result,
      searchOption: searchOption ?? this.searchOption,
    );
  }

  @override
  List<Object?> get props => [
        status,
        result,
        searchOption,
      ];
}
