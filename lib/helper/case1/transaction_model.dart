class MyTransaction {
  int? id;
  String description;
  String status;
  DateTime time;

  MyTransaction({this.id, required this.description, required this.status, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'status': status,
      'time': time.toString()
    };
  }
}