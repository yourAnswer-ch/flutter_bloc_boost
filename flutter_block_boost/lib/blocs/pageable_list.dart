import 'dart:collection';

class PageableList<T> extends ListBase<T> {
  final List<T> _inner = [];

  @override
  int get length => _inner.length;

  @override
  set length(int newLength) {
    _inner.length = newLength;
  }

  @override
  T operator [](int index) => _inner[index];

  @override
  void operator []=(int index, T value) {
    _inner[index] = value;
  }

  // You can now add custom methods:
  void addIfNotNull(T? value) {
    if (value != null) _inner.add(value);
  }

  int page = 1;
  int pageSize = 40;
  bool endOfList = false;
  final Map<String, String> filters = <String, String>{};

  void updateFilters(Map<String, String>? filters) {
    this.filters.clear();

    if (filters != null) {
      this.filters.addAll(filters);
    }
  }

  void updateList(Iterable<T> list, int? page, int? pageSize) {
    this.page = page ?? 1;
    this.pageSize = pageSize ?? 40;
    endOfList = list.isEmpty || list.length < this.pageSize;

    if (page == 1) {
      _inner.clear();
    }

    _inner.addAll(list);
  }

  void addOrUpdate(T value) {
    var index =
        _inner.indexWhere((e) => (e as dynamic).id == (value as dynamic).id);
    if (index == -1) {
      _inner.insert(0, value);
    } else {
      _inner[index] = value;
    }
  }
}
