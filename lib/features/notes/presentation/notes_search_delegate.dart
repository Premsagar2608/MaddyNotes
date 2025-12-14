import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notes_provider.dart';
import 'add_edit_note_screen.dart';

class NotesSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;
  NotesSearchDelegate(this.ref);

  final FocusNode _focusNode = FocusNode();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          ref.read(searchQueryProvider.notifier).state = query;
          _focusNode.unfocus();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, query);
        _focusNode.unfocus();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final notesAsyncValue = ref.watch(notesProvider);
    final notes = notesAsyncValue.maybeWhen(
      data: (notes) => notes,
      orElse: () => [],
    );

    final suggestions = notes.where(
          (note) => note['title'].toLowerCase().contains(query.toLowerCase()),
    ).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final note = suggestions[index];
        return ListTile(
          title: Text(note['title']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditNoteScreen(note: note),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final notesAsyncValue = ref.watch(notesProvider);
    final notes = notesAsyncValue.maybeWhen(
      data: (notes) => notes,
      orElse: () => [],
    );

    final suggestions = notes.where(
          (note) => note['title'].toLowerCase().contains(query.toLowerCase()),
    ).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final note = suggestions[index];
        return ListTile(
          title: Text(note['title']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditNoteScreen(note: note),
              ),
            );
          },
        );
      },
    );
  }
}
