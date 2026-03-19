import 'package:flutter/material.dart';
import '../data/models/note_model.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotesController extends ChangeNotifier {
  List<Note> notes = [];
  List<String> folders = ['All Notes', 'Personal', 'Work', 'Ideas'];
  String selectedFolder = 'All Notes';

  Future<void> fetchNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString('notes');

    if (notesString != null) {
      final List<dynamic> jsonList = jsonDecode(notesString);
      notes = jsonList.map((e) => Note.fromMap(e)).toList();
    } else {
      // Default welcome note
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
      await _saveNotes();
    }
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = jsonEncode(notes.map((n) => n.toMap()).toList());
    await prefs.setString('notes', notesString);
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
    for (var note in notes) {
      if (note.folderName == name) {
        note.folderName = null;
      }
    }
    if (selectedFolder == name) {
      selectedFolder = 'All Notes';
    }
    _saveNotes();
    notifyListeners();
  }

  void selectFolder(String folderName) {
    selectedFolder = folderName;
    notifyListeners();
  }

  void moveNote(String noteId, String newFolderName) {
    final index = notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      notes[index].folderName = newFolderName == 'All Notes' ? null : newFolderName;
      _saveNotes();
      notifyListeners();
    }
  }

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
    for (var note in notes) {
      note.tags.remove(tag);
    }
    _saveNotes();
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
    _saveNotes();
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
        for (var t in tags) {
          addTag(t);
        }
      }
      if (folderName != null) {
        notes[index].folderName = folderName == 'All Notes' ? null : folderName;
      }
      notes[index].dateModified = DateTime.now();
      _saveNotes();
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    notes.removeWhere((note) => note.id == id);
    _saveNotes();
    notifyListeners();
  }

  List<Note> get filteredNotes {
    return notes.where((note) {
      final matchesFolder =
          selectedFolder == 'All Notes' || note.folderName == selectedFolder;
      return matchesFolder;
    }).toList();
  }
}
