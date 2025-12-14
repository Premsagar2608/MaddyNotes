import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maddy_notes/features/auth/data/auth_repository.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/notes_repository.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final user = authRepository.currentUser;
  if (user != null) {
    return NotesRepository(userId: user.uid);
  }
  throw Exception('User not logged in');
});


final searchQueryProvider = StateProvider<String>((ref) => '');
final colorFilterProvider = StateProvider<String>((ref) => '');
final lastDocumentProvider = StateProvider<DocumentSnapshot?>((ref) => null);
final sortByProvider = StateProvider<String>((ref) => 'date');
final notesProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(notesRepositoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final colorFilter = ref.watch(colorFilterProvider);
  final lastDocument = ref.watch(lastDocumentProvider);
  final sortBy = ref.watch(sortByProvider);

  return repository.getNotes(
    searchQuery: searchQuery,
    colorFilter: colorFilter,
    lastDocument: lastDocument,
    sortBy: sortBy,
  );
});
