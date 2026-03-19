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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags,
      'folderName': folderName,
      'dateModified': dateModified.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      folderName: map['folderName'],
      dateModified: map['dateModified'] != null
          ? DateTime.parse(map['dateModified'])
          : DateTime.now(),
    );
  }
}

