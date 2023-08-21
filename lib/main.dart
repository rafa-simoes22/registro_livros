import 'package:flutter/material.dart';

void main() {
  runApp(BookApp());
}

class Book {
  final String title;
  final String author;
  final String classification;

  Book(this.title, this.author, this.classification);
}

class BookApp extends StatelessWidget {
  final List<Book> books = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Registration App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookListScreen(books),
    );
  }
}

class BookListScreen extends StatelessWidget {
  final List<Book> books;

  BookListScreen(this.books);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(books[index].title),
            subtitle: Text('Author: ${books[index].author}\nClassification: ${books[index].classification}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBook = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookFormScreen()),
          );

          if (newBook != null) {
            books.add(newBook);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BookFormScreen extends StatefulWidget {
  @override
  _BookFormScreenState createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _classificationController = TextEditingController();

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: _validateNotEmpty,
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: _validateNotEmpty,
              ),
              TextFormField(
                controller: _classificationController,
                decoration: InputDecoration(labelText: 'Classification'),
                validator: _validateNotEmpty,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newBook = Book(
                      _titleController.text,
                      _authorController.text,
                      _classificationController.text,
                    );
                    Navigator.pop(context, newBook);
                  }
                },
                child: Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
