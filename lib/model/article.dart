class Article {
  int id;
  String name;
  int item;
  var price;
  String store;
  String image;

  Article();

  void fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.item = map['item'];
    this.price = map['price'];
    this.store = map['store'];
    this.image = map['image'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': this.name,
      'item': this.item,
      'store': this.store,
      'price': this.price,
      'image': this.image,
    };
    if (id != null) {
      map['id'] = this.id;
    }
    return map;
  }
}