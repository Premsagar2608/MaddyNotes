import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maddy_notes/core/constants/app_constants.dart';
import 'package:maddy_notes/core/utils/color_utils.dart';
import 'package:maddy_notes/features/notes/providers/notes_provider.dart';

final selectedColorProvider = StateProvider<String>((ref) => '#FFFFFF');

class AddEditNoteScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  ConsumerState<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends ConsumerState<AddEditNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  File? _newImageFile;
  String? _existingImageUrl;
  bool _imageWasRemoved = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?['title']);
    _descriptionController =
        TextEditingController(text: widget.note?['description']);
    _existingImageUrl = widget.note?['imageUrl'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedColorProvider.notifier).state =
          widget.note?['color'] ?? '#FFFFFF';
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path);
        _imageWasRemoved = false;
      });
    }
  }

  Future<void> _removeImage() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Image?'),
        content: const Text('Are you sure you want to remove this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _newImageFile = null;
        _existingImageUrl = null;
        _imageWasRemoved = true;
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('note_images')
          .child('${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  Future<void> _saveNote() async {
    final originalImageUrl = widget.note?['imageUrl'];
    String? finalImageUrl;
    if (_newImageFile != null) {
      finalImageUrl = await _uploadImage(_newImageFile!);
      if (originalImageUrl != null) {
        FirebaseStorage.instance
            .refFromURL(originalImageUrl)
            .delete()
            .catchError((e) => debugPrint('Error deleting old image: $e'));
      }
    }
    else if (_imageWasRemoved) {
      finalImageUrl = null;
      if (originalImageUrl != null) {
        FirebaseStorage.instance
            .refFromURL(originalImageUrl)
            .delete()
            .catchError((e) => debugPrint('Error deleting old image: $e'));
      }
    }
    else {
      finalImageUrl = originalImageUrl;
    }

    final noteData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'color': ref.read(selectedColorProvider),
      'createdAt': widget.note?['createdAt'] ?? FieldValue.serverTimestamp(),
      'imageUrl': finalImageUrl,
    };

    try {
      if (widget.note == null) {
        await ref.read(notesRepositoryProvider).addNote(noteData);
      } else {
        await ref
            .read(notesRepositoryProvider)
            .updateNote(widget.note!['id'], noteData);
      }
      ref.refresh(notesProvider);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = ref.watch(selectedColorProvider);
    final colors = AppConstants.noteColors;

    Widget? imageWidget;
    if (_newImageFile != null) {
      imageWidget = Image.file(_newImageFile!, height: 150, width: double.infinity, fit: BoxFit.cover);
    } else if (_existingImageUrl != null) {
      imageWidget = Image.network(_existingImageUrl!, height: 150, width: double.infinity, fit: BoxFit.cover);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final color = colors[index];
                    return GestureDetector(
                      onTap: () => ref.read(selectedColorProvider.notifier).state = color,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: hexToColor(color),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (imageWidget != null)
                GestureDetector(
                  onLongPress: _removeImage,
                  child: imageWidget,
                ),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Add/Change Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
