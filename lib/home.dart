import 'package:diary_app/auth_service.dart';
import 'package:diary_app/widgets/note_service.dart';
import 'package:flutter/material.dart';
import 'package:diary_app/canvas_screen.dart';
import 'package:diary_app/widgets/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes(); // ⬅️ ambil dari Firestore
  }

  void _loadNotes() async {
    final user = AuthService.currentUser;
    if (user == null) {
      debugPrint("User belum login saat loadNotes");
      return;
    }

    final userNotes = await NoteService.fetchNotesForUser(user.id);
    setState(() {
      _notes.clear();
      _notes.addAll(userNotes);
    });
  }

  void _createNewNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CanvasScreen(
          onSave: (newNote) {
            setState(() {
              _notes.add(newNote);
            });
          },
        ),
      ),
    );
  }

  void _editNote(int index, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CanvasScreen(
          initialNote: note,
          onSave: (updatedNote) {
            setState(() {
              _notes[index] = updatedNote;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.book_outlined),
        title: const Text('My Diary'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewNote,
          ),
        ],
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('Belum ada catatan ☁️'))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _notes.length,
              itemBuilder: (_, i) {
                final note = _notes[i];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () => _editNote(i, note),
                  ),
                );
              },
            ),
    );
  }
}
