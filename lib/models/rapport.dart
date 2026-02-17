class Rapport {
  Rapport({
    required this.headerValue,
    required this.data,
    this.isExpanded = false,
  });
  String headerValue;
  List<dynamic> data;
  bool isExpanded;
}
