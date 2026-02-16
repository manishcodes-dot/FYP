import 'package:flutter/material.dart';
// immport 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import '../../logic/notes_controller.dart';
import '../../data/models/note_model.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _headerController;
  late TextEditingController _contentController;
  String _selectedFolder = 'All Notes';
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _headerController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _tags = widget.note?.tags != null ? List.from(widget.note!.tags) : [];
    _selectedFolder = widget.note?.folderName ?? 'All Notes';
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesController = Provider.of<NotesController>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.note != null ? 'Edit Note' : 'New Note',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue, size: 28),

            onPressed: () {
              String txt = _contentController.text;

              // Ensure folder is valid (if user selected something that might not be in the list, though dropdown prevents this usually)
              // But we need to handle "All Notes" mapping if needed.
              // Controller logic handles 'All Notes' as null or explicit string?
              // In controller I used "All Notes" as a valid folder name in the list, but stored as specific string or null.
              // Let's stick to storing the string.

              if (widget.note != null) {
                notesController.updateNote(
                  widget.note!.id,
                  _headerController.text,
                  txt,
                  tags: _tags,
                  folderName: _selectedFolder,
                );
              } else {
                notesController.createNote(
                  _headerController.text.isEmpty
                      ? 'New Note'
                      : _headerController.text,
                  txt,
                  tags: _tags,
                  folderName: _selectedFolder == 'All Notes'
                      ? null
                      : _selectedFolder,
                );
              }
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Title Input
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _headerController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // Folder & Tags Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFolder,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          isDense: true,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                          items: notesController.folders.map((String folder) {
                            return DropdownMenuItem<String>(
                              value: folder,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.folder,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(folder),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFolder = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.create_new_folder_outlined,
                        color: Colors.grey,
                      ),
                      tooltip: 'New Folder',
                      onPressed: () => _showAddFolderDialog(context),
                    ),
                    const Spacer(),
                    ActionChip(
                      avatar: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add Tag',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      onPressed: () => _showAddTagDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: const Color(0xFFE3F2FD),
                        labelStyle: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                        deleteIcon: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.blue[800],
                        ),
                        onDeleted: () {
                          setState(() {
                            _tags.remove(tag);
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none,
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Start typing...",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddTagDialog(BuildContext context) async {
    final notesController = Provider.of<NotesController>(
      context,
      listen: false,
    );
    final availableTags = notesController.allTags
        .where((t) => !_tags.contains(t))
        .toList();

    String newTag = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Tag'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'New Tag name'),
                  onChanged: (value) => newTag = value,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) Navigator.pop(context, value);
                  },
                ),
                if (availableTags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Suggestions:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableTags.map((tag) {
                      return ActionChip(
                        label: Text(tag),
                        backgroundColor: Colors.grey[100],
                        onPressed: () {
                          Navigator.pop(context, tag);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newTag.isNotEmpty) Navigator.pop(context, newTag);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    ).then((val) {
      if (val != null && val.toString().isNotEmpty) {
        setState(() {
          _tags.add(val.toString());
        });
      }
    });
  }

  Future<void> _showAddFolderDialog(BuildContext context) async {
    String newFolder = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Folder'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Folder Name'),
            onChanged: (value) => newFolder = value,
            onSubmitted: (value) {
              if (value.isNotEmpty) Navigator.pop(context, value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newFolder.isNotEmpty) Navigator.pop(context, newFolder);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    ).then((result) {
      if (result != null && result is String && result.isNotEmpty) {
        final notesController = Provider.of<NotesController>(
          context,
          listen: false,
        );
        notesController.createFolder(result);
        setState(() {
          _selectedFolder = result;
        });
      }
    });
  }
}
