class MenuItem {
  String name;
  String id;
  double price;
  int popularity;
  bool isSelected = false;
  int qty;
  @override
  String toString() {
    return name + " : " + isSelected.toString();
  }
}
