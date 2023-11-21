import 'package:flutter/material.dart';
import 'package:escriboapp/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;

  BookCard(this.book);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Image.network(book.coverUrl),
    );
  }
}
