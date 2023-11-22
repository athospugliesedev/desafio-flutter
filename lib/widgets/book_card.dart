import 'package:flutter/material.dart';
import 'package:escriboapp/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isFavorite;
  final Function addToFavorites;

  BookCard({
    required this.book,
    required this.isFavorite,
    required this.addToFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Image.network(book.coverUrl),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                addToFavorites(book);
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.blue,
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'Favoritar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
