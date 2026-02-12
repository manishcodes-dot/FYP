import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/notes_controller.dart';
import 'note_editor_page.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  @override
  void initState() {
    super.initState();
    // Load notes (local for now, API later)
    Provider.of<NotesController>(context, listen: false).fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NotesController>();
    final notes = controller.notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // CREATE NOTE
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NoteEditorPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                'No notes yet.\nTap + to create one.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // EDIT NOTE
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteEditorPage(note: note),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        controller.deleteNote(note.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
