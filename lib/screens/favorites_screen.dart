import 'package:escriboapp/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:escriboapp/models/book.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Book> favoriteBooks;

  FavoritesScreen({Key? key, required this.favoriteBooks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: buildGridView(),
    );
  }

  Widget buildGridView() {
    // Filtrar apenas os livros favoritos
    List<Book> favorites = favoriteBooks.where((book) => book.isFavorite).toList();

    if (favorites.isEmpty) {
      return Center(child: Text('Nenhum livro favorito.'));
    }

    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Adicione a lógica para lidar com o toque em um livro favorito, se necessário
          },
          child: BookCard(
            book: favorites[index],
            isFavorite: favorites[index].isFavorite,
            addToFavorites: (Book book) {
              // Adicione a lógica para adicionar/remover dos favoritos
            },
          ),
        );
      },
    );
  }
}
