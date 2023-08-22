import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class Book {
  final int id;
  final String title;
  final String author;
  final String classification;

  Book({required this.id, required this.title, required this.author, required this.classification});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'classification': classification,
    };
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Livros',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Database _database;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _classificationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'books_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE books(id INTEGER PRIMARY KEY, title TEXT, author TEXT, classification TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _addBook() async {
    final newBook = Book(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      author: _authorController.text,
      classification: _classificationController.text,
    );

    await _database.insert(
      'books',
      newBook.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _titleController.clear();
    _authorController.clear();
    _classificationController.clear();

    setState(() {});
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
          FutureBuilder<void>(
            future: _initDatabase(), // Initialize the database before building UI
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return FutureBuilder<List<Book>>(
                  future: _getBooks(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('Nenhum livro cadastrado.'),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final book = snapshot.data![index];
                          return ListTile(
                            title: Text(book.title),
                            subtitle: Text('${book.author}, ${book.classification}'),
                            onTap: () => _showBookDetails(book),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<Book>> _getBooks() async {
    final List<Map<String, dynamic>> maps = await _database.query('books');
    return List.generate(maps.length, (i) {
      return Book(  
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        classification: maps[i]['classification'],
      );
    });
  }

  void _showBookDetails(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book)),
    );
  }
}

class BookDetailScreen extends StatelessWidget {
  final Book book;

  BookDetailScreen(this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${book.title}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Autor: ${book.author}', style: TextStyle(fontSize: 18)),
            Text('Classificação: ${book.classification}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
