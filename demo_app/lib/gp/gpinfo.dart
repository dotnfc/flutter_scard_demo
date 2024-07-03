
abstract class GPInfo {
  final String title;
  List<MapEntry<String, String>> items; 

  GPInfo({required this.title})
    : items = [];

  void addItem(String key, String value) {
    items.add(MapEntry(key, value));
  }
}
