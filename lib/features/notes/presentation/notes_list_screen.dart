import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maddy_notes/core/animations/slide_transition.dart';
import '../providers/notes_provider.dart';
import 'add_edit_note_screen.dart';
import 'notes_search_delegate.dart';

class NotesListScreen extends ConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsyncValue = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NotesSearchDelegate(ref),
              );
            },
          ),
        ],
      ),
      body: notesAsyncValue.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet. Add one!'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final title = note['title'] ?? 'No Title';
              final description = note['description'] ?? 'No Description';
              final colorString = note['color'] ?? '#FFFFFF';
              final imageUrl = note['imageUrl'];

              return Card(
                margin: const EdgeInsets.all(8.0),
                color: Color(int.parse(colorString.replaceFirst('#', '0xFF'))),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description),
                      const SizedBox(height: 8.0),
                      if (imageUrl != null)
                        Image.network(
                          imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideRightRoute(page: AddEditNoteScreen(note: note)),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final noteId = note['id'];
                      if (noteId != null) {
                        try {
                          await ref.read(notesRepositoryProvider).deleteNote(noteId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Note deleted successfully')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            SlideRightRoute(page: const AddEditNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
