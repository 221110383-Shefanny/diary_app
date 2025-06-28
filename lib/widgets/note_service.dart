import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/widgets/note_model.dart';

class NoteService {
  static final _ref = FirebaseFirestore.instance.collection('notes');

  static Future<Note> saveNote(Note note) async {
    final doc = await _ref.add(note.toJson());
    return note.copyWith(id: doc.id);
  }

  static Future<Note> updateNote(Note note) async {
    await _ref.doc(note.id).set(note.toJson(), SetOptions(merge: true));
    return note;
  }

  static Future<List<Note>> fetchNotesForUser(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Note.fromJson(data);
    }).toList();
  }
}
