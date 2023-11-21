import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  final String bookTitle;

  BookDetailsScreen({required this.bookTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookTitle),
      ),
      body: Center(
        child: Text('Detalhes do livro: $bookTitle'),
      ),
    );
  }
}
