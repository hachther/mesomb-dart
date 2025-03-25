abstract class APaginated {
  Map<String, dynamic> _data;

  late int count;
  String? next;
  String? previous;

  APaginated(this._data)
      : count = _data['count'],
        next = _data['next'],
        previous = _data['previous'];

  Map<String, dynamic> getData() => _data;
}
