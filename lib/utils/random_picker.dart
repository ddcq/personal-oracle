import 'dart:math';

/// A class to pick random items from a list without repetition.
class UniqueRandomPicker<T> {
  final List<T> _items;
  final Random _random;

  /// Creates a new picker with a copy of the provided list.
  UniqueRandomPicker(List<T> items) 
      : _items = List<T>.from(items), // Create a copy to avoid modifying the original list
        _random = Random();

  /// Returns `true` if there are still items to pick.
  bool get isNotEmpty => _items.isNotEmpty;

  /// Returns `true` if there are no more items to pick.
  bool get isEmpty => _items.isEmpty;

  /// Picks a random item from the list and removes it.
  /// Returns `null` if the list is empty.
  T? pick() {
    if (_items.isEmpty) {
      return null;
    }
    final index = _random.nextInt(_items.length);
    return _items.removeAt(index);
  }
}
