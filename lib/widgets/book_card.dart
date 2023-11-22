import 'package:flutter/material.dart';
import 'package:escriboapp/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isFavorite;

  BookCard({required this.book, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Image.network(book.coverUrl),
    );
  }
}
