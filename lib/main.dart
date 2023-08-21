import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Book {
  final String title;
  final String author;
  final String classification;

  Book({required this.title, required this.author, required this.classification});
}

class MyApp extends StatelessWidget {
  final List<Book> books = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Livros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookListScreen(books),
    );
  }
}

class BookListScreen extends StatefulWidget {
  final List<Book> books;

  BookListScreen(this.books);

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _classificationController = TextEditingController();

  void _addBook() {
    setState(() {
      final newBook = Book(
        title: _titleController.text,
        author: _authorController.text,
        classification: _classificationController.text,
      );

      widget.books.add(newBook);

      _titleController.clear();
      _authorController.clear();
      _classificationController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Livros'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(labelText: 'Autor'),
                ),
                TextField(
                  controller: _classificationController,
                  decoration: InputDecoration(labelText: 'Classificação'),
                ),
                ElevatedButton(
                  onPressed: _addBook,
                  child: Text('Adicionar Livro'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.books.length,
              itemBuilder: (context, index) {
                final book = widget.books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text('${book.author}, ${book.classification}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
