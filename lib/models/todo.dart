class Todo {
  final int id;
  String judul;
  String deskripsi;
  DateTime date;
  bool status;

  Todo({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.date,
    this.status = false,
  });
}
