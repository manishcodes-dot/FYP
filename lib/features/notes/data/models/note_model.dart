class Note {
  String id;
  String title;
  String content;
  List<String> tags;
  String? folderName;
  DateTime dateModified;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.tags = const [],
    this.folderName,
    DateTime? dateModified,
  }) : dateModified = dateModified ?? DateTime.now();
}
