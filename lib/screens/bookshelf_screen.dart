import 'package:escriboapp/screens/favorites_screen.dart';
import 'package:escriboapp/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:escriboapp/blocs/book_bloc.dart';
import 'package:escriboapp/models/book.dart';
import 'package:escriboapp/widgets/book_card.dart';

class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  late List<Book> books;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  void loadBooks() async {
    try {
      books = await ApiService.fetchBooks();
      print('Número de livros: ${books.length}');
      setState(() {});
    } catch (e) {
      print('Erro ao carregar livros: $e');
    }
  }

  void addToFavorites(Book book) {
    setState(() {
      book.toggleFavorite(); 
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookshelf'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                      favoriteBooks:
                          books.where((book) => book.isFavorite).toList()),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildRow(0),
            SizedBox(height: 16.0),
            buildRow(1),
          ],
        ),
      ),
    );
  }

  Widget buildRow(int rowIndex) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          5,
          (colIndex) {
            int index = rowIndex * 5 + colIndex;
            if (index < books.length) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        GestureDetector(
                          onTap: () {
                            addToFavorites(books[index]); // Chama a função ao clicar no livro
                          },
                          child: BookCard(
                            book: books[index],
                            isFavorite: books[index].isFavorite,
                            addToFavorites: addToFavorites, // Passa a função para o BookCard
                          ),
                        ),
                        Container(),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      books[index].title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Autor: ${books[index].author}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
