import 'dart:io';

import 'package:dio/dio.dart';
import 'package:escriboapp/screens/favorites_screen.dart';
import 'package:escriboapp/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:escriboapp/models/book.dart';
import 'package:escriboapp/widgets/book_card.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:path_provider/path_provider.dart';

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
        title: Text('Leitor de Ebooks • Escribo'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteBooks:
                        books.where((book) => book.isFavorite).toList(),
                  ),
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
                          onTap: () async {
                            await _downloadAndOpenEpub(
                                books[index].downloadUrl);
                          },
                          child: BookCard(
                            book: books[index],
                            isFavorite: books[index].isFavorite,
                            addToFavorites: addToFavorites,
                          ),
                        ),
                        Container(),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      books[index].title.length > 20
                          ? '${books[index].title.substring(0, 20)}\n${books[index].title.substring(20)}'
                          : books[index].title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${books[index].author}',
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

  Future<void> _downloadAndOpenEpub(String downloadUrl) async {
    try {
      Dio dio = Dio();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = "${appDocDir.path}/downloaded_book.epub";

      await dio.download(
        downloadUrl,
        filePath,
        onReceiveProgress: (receivedBytes, totalBytes) {},
      );

      _openEpubViewer(context, filePath);
    } catch (e) {
      print('Erro ao baixar e abrir o EPUB: $e');
    }
  }

  void _openEpubViewer(BuildContext context, String epubPath) {
    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );

    VocsyEpub.locatorStream.listen((locator) {
      print('LOCATOR: $locator');
    });

    VocsyEpub.open(
      epubPath,
      lastLocation: EpubLocator.fromJson({
        "bookId": "2239",
        "href": "/OEBPS/ch06.xhtml",
        "created": 1539934158390,
        "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"},
      }),
    );
  }
}
