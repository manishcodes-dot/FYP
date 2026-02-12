import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/notes/logic/notes_controller.dart';

class ManageFoldersTagsPage extends StatefulWidget {
  const ManageFoldersTagsPage({super.key});

  @override
  State<ManageFoldersTagsPage> createState() => _ManageFoldersTagsPageState();
}

class _ManageFoldersTagsPageState extends State<ManageFoldersTagsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Manage',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black87,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Folders'),
            Tab(text: 'Tags'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [FoldersManager(), TagsManager()],
      ),
    );
  }
}

class FoldersManager extends StatefulWidget {
  const FoldersManager({super.key});

  @override
  State<FoldersManager> createState() => _FoldersManagerState();
}

class _FoldersManagerState extends State<FoldersManager> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NotesController>(context);
    final folders = controller.folders;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Create new folder...',
              prefixIcon: const Icon(Icons.create_new_folder_outlined),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_circle),
                color: Colors.black87,
                onPressed: () => _addFolder(controller),
              ),
            ),
            onSubmitted: (_) => _addFolder(controller),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: folders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final folder = folders[index];
              final isAllNotes = folder == 'All Notes';
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.folder_outlined,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    folder,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: isAllNotes
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _showDeleteFolderDialog(
                            context,
                            folder,
                            controller,
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _addFolder(NotesController controller) {
    if (_controller.text.trim().isNotEmpty) {
      controller.createFolder(_controller.text.trim());
      _controller.clear();
    }
  }

  void _showDeleteFolderDialog(
    BuildContext context,
    String folder,
    NotesController controller,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete "$folder"?'),
        content: const Text(
          'Notes in this folder will be moved to "All Notes".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteFolder(folder);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class TagsManager extends StatefulWidget {
  const TagsManager({super.key});

  @override
  State<TagsManager> createState() => _TagsManagerState();
}

class _TagsManagerState extends State<TagsManager> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NotesController>(context);
    final tags = controller.allTags;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Create new tag...',
              prefixIcon: const Icon(Icons.local_offer_outlined),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_circle),
                color: Colors.black87,
                onPressed: () => _addTag(controller),
              ),
            ),
            onSubmitted: (_) => _addTag(controller),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tags.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final tag = tags[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.label_outline,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    tag,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () =>
                        _showDeleteTagDialog(context, tag, controller),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _addTag(NotesController controller) {
    if (_controller.text.trim().isNotEmpty) {
      controller.addTag(_controller.text.trim());
      _controller.clear();
    }
  }

  void _showDeleteTagDialog(
    BuildContext context,
    String tag,
    NotesController controller,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete "$tag"?'),
        content: const Text('This tag will be removed from all notes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTag(tag);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
