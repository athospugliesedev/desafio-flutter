import 'package:escriboapp/models/book.dart';
import 'package:escriboapp/services/api_service.dart';

class BookRepository {
  Future<List<Book>> getBooks() async {
    try {
      return await ApiService.fetchBooks();
    } catch (e) {
      throw Exception('Falha ao carregar livros');
    }
  }
}
