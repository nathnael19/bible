import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/verse.dart';
import '../../domain/usecases/search_verses.dart';
import '../../domain/entities/search_filter.dart';

import '../../domain/entities/search_mode.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Verse> results;
  final SearchMode mode;

  const SearchLoaded(this.results, {this.mode = SearchMode.contains});

  @override
  List<Object?> get props => [results, mode];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchCubit extends Cubit<SearchState> {
  final SearchVerses _searchVerses;

  SearchCubit(this._searchVerses) : super(SearchInitial());

  Future<void> search(String query, {
    SearchFilter filter = SearchFilter.all,
    SearchMode mode = SearchMode.contains,
    String? versionId,
  }) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await _searchVerses(
        query,
        filter: filter,
        mode: mode,
        versionId: versionId ?? 'amh_standard',
      );
      emit(SearchLoaded(results, mode: mode));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
