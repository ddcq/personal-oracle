enum CardVersion {
  chibi,
  premium,
  epic;

  String toJson() => name;
  static CardVersion fromJson(String json) => values.byName(json);
}
