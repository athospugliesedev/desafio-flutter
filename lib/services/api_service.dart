import 'dart:convert';
import 'package:escriboapp/models/book.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Book>> fetchBooks() async {
    final response = await http.get(
      Uri.parse('https://escribo.com/books.json'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<Book> books = jsonList.map((json) => Book.fromJson(json)).toList();
      return books;
    } else {
      throw Exception('Falha ao carregar livros');
    }
  }
}
