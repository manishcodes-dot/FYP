import 'package:flutter/material.dart';
import '../data/models/note_model.dart'; // <-- Corrected path
import 'dart:math';

class NotesController extends ChangeNotifier {
  List<Note> notes = [];
  List<String> folders = ['All Notes', 'Personal', 'Work', 'Ideas'];
  String selectedFolder = 'All Notes';

  void fetchNotes() {
    notes = [
      Note(
        id: '1',
        title: 'Welcome to My Notes',
        content: 'Start writing your thoughts here...',
        tags: ['Personal'],
        folderName: 'Personal',
        dateModified: DateTime.now(),
      ),
    ];
    notifyListeners();
  }

  // Folder Management
  void createFolder(String name) {
    if (!folders.contains(name)) {
      folders.add(name);
      notifyListeners();
    }
  }

  void deleteFolder(String name) {
    if (name == 'All Notes') return; // Cannot delete All Notes
    folders.remove(name);
    // Move notes in deleted folder to 'All Notes' or kept blank?
    // Let's set their folderName to null or 'All Notes' (conceptually)
    for (var note in notes) {
      if (note.folderName == name) {
        note.folderName = null;
      }
    }
    if (selectedFolder == name) {
      selectedFolder = 'All Notes';
    }
    notifyListeners();
  }

  void selectFolder(String folderName) {
    selectedFolder = folderName;
    notifyListeners();
  }

  void moveNote(String noteId, String newFolderName) {
    final index = notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      notes[index].folderName = newFolderName == 'All Notes'
          ? null
          : newFolderName;
      notifyListeners();
      // Logic: If we are viewing a specific folder and move a note OUT of it,
      // it should disappear from the list seamlessly.
    }
  }

  // Note Management

  // Tag Management
  List<String> allTags = ['Work', 'Personal', 'Important', 'Ideas'];

  void addTag(String tag) {
    if (!allTags.contains(tag)) {
      allTags.add(tag);
      notifyListeners();
    }
  }

  void deleteTag(String tag) {
    allTags.remove(tag);
    // Optional: Remove this tag from all notes?
    for (var note in notes) {
      note.tags.remove(tag);
    }
    notifyListeners();
  }

  // Note Management
  void createNote(
    String title,
    String content, {
    List<String>? tags,
    String? folderName,
  }) {
    final id = Random().nextInt(10000).toString();

    // Auto-add new tags to global list
    if (tags != null) {
      for (var t in tags) {
        addTag(t);
      }
    }

    notes.add(
      Note(
        id: id,
        title: title,
        content: content,
        tags: tags ?? [],
        folderName: folderName,
      ),
    );
    notifyListeners();
  }

  void updateNote(
    String id,
    String title,
    String content, {
    List<String>? tags,
    String? folderName,
  }) {
    final index = notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      notes[index].title = title;
      notes[index].content = content;
      if (tags != null) {
        notes[index].tags = tags;
        // Auto-add new tags to global list
        for (var t in tags) {
          addTag(t);
        }
      }
      if (folderName != null) {
        notes[index].folderName = folderName == 'All Notes' ? null : folderName;
      }
      notes[index].dateModified = DateTime.now();
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  // Computed / Filtered Notes
  List<Note> get filteredNotes {
    return notes.where((note) {
      final matchesFolder =
          selectedFolder == 'All Notes' || note.folderName == selectedFolder;
      return matchesFolder;
    }).toList();
  }
}
