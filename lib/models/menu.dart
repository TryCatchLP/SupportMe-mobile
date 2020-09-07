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

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        title: json["title"],
        ingredients: json["ingredients"],
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
