import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:escriboapp/blocs/book_bloc.dart';
import 'package:escriboapp/screens/bookshelf_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MyBloc()),
      ],
      child: MaterialApp(
        title: 'Leitor de eBooks',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BookshelfScreen(),
      ),
    ),
  );
}
