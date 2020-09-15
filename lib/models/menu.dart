class Menu {
  Menu({
    this.id,
    this.title,
    this.ingredients,
    this.price,
  });

  int id;
  String title;
  String ingredients;
  double price;

  factory Menu.zero() {
    return Menu(id: 0, title: "", ingredients: "", price: 0.0);
  }

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["menu"]["id"],
        title: json["menu"]["title"],
        ingredients: json["menu"]["ingredients"],
        price: json["price"].toDouble()
      );

  Map<String, dynamic> toJson() => {
        "menu": {
          "title": title,
          "ingredients": ingredients,
        },
        "price": price,
      };
}
