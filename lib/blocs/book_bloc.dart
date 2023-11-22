import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:escriboapp/models/book.dart';
import 'package:escriboapp/repositories/book_repository.dart';

import '../services/api_service.dart';

abstract class BookEvent {}

class FetchBooksEvent extends BookEvent {
  @override
  Stream<BookState> applyAsync({required MyBloc bloc, required BookState currentState}) async* {
    try {
      print('Chamando ApiService.fetchBooks()');
      List<Book> books = await ApiService.fetchBooks();
      print('Número de livros recebidos: ${books.length}');
      yield BooksLoadedState(books: books);
    } catch (e) {
      print('Erro ao carregar livros: $e');
      yield BookErrorState(errorMessage: 'Erro ao carregar os livros.');
    }
  }
}

class DownloadAndReadBookEvent extends BookEvent {
  final Book book;

  DownloadAndReadBookEvent(this.book);
}

abstract class BookState {}

class BookInitialState extends BookState {}

class BooksLoadedState extends BookState {
  final List<Book> books;

  BooksLoadedState({required this.books});

  @override
  List<Object> get props => [books];
}

class BookErrorState extends BookState {
  final String errorMessage;

  BookErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class MyBloc extends Bloc<BookEvent, BookState> {
  final BookRepository bookRepository = BookRepository();

  MyBloc() : super(BookInitialState()) {
    on<FetchBooksEvent>((event, emit) async {
      try {
        print('Chamando bookRepository.getBooks()');
        final books = await bookRepository.getBooks();
        print('Número de livros no bloco: ${books.length}');
        emit(BooksLoadedState(books: books));
      } catch (e) {
        print('Erro ao carregar livros no bloco: $e');
        emit(BookErrorState(errorMessage: "Erro ao carregar livros."));
      }
    });

    on<DownloadAndReadBookEvent>((event, emit) async {
    });
  }
}
