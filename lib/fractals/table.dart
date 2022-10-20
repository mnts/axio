class TableFractal {
  String name;
  String id;
  late DateTime time;

  TableFractal({
    this.name = '',
    this.id = '',
    DateTime? time,
  }) {
    this.time = time ?? DateTime.now();
  }
}
