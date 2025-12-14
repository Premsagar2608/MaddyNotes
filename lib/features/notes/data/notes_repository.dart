import 'package:cloud_firestore/cloud_firestore.dart';

class NotesRepository {
  final String userId;

  NotesRepository({required this.userId});
  Stream<List<Map<String, dynamic>>> getNotes({
    String? searchQuery,
    String? colorFilter,
    DocumentSnapshot? lastDocument,
    int limit = 10,
    String? sortBy,
  }) {
    Query notesCollection =
        FirebaseFirestore.instance.collection('users').doc(userId).collection('notes');

    if (colorFilter != null && colorFilter.isNotEmpty) {
      notesCollection = notesCollection.where('color', isEqualTo: colorFilter);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      notesCollection = notesCollection.where('title', isGreaterThanOrEqualTo: searchQuery)
          .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff');
    }
    if (sortBy != null && sortBy == 'date') {
      notesCollection = notesCollection.orderBy('createdAt', descending: true);
    } else {
      notesCollection = notesCollection.orderBy('title');
    }
    if (lastDocument != null) {
      notesCollection = notesCollection.startAfterDocument(lastDocument);
    }
    return notesCollection.limit(limit).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'description': doc['description'],
          'color': doc['color'],
        };
      }).toList();
    });
  }
  Future<void> deleteNote(String noteId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
  Future<void> addNote(Map<String, dynamic> noteData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(noteData);
  }
  Future<void> updateNote(String noteId, Map<String, dynamic> noteData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update(noteData);
  }
}
