import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_books.dart';

// ── States ────────────────────────────────────────────────────────────────────

abstract class LibraryState extends Equatable {
  const LibraryState();
  @override
  List<Object?> get props => [];
}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<Book> books;
  const LibraryLoaded(this.books);
  @override
  List<Object?> get props => [books];
}

class LibraryError extends LibraryState {
  final String message;
  const LibraryError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class LibraryCubit extends Cubit<LibraryState> {
  final GetBooks _getBooks;

  LibraryCubit(this._getBooks) : super(LibraryLoading());

  Future<void> loadBooks() async {
    emit(LibraryLoading());
    try {
      final books = await _getBooks();
      emit(LibraryLoaded(books));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }
}
