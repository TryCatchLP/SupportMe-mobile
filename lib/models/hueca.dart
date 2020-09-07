class Hueca {
  Hueca({
    this.id,
    this.name,
    this.descrip,
    this.lat,
    this.lng,
    this.address,
    this.photo,
    this.phone,
    this.stars,
    this.ratings,
  });

  int id;
  String name;
  String descrip;
  double lat;
  double lng;
  String address;
  String photo;
  String phone;
  int stars;
  int ratings;

  factory Hueca.fromJson(Map<String, dynamic> json) => Hueca(
        id: json["id"],
        name: json["name"],
        descrip: json["descrip"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        address: json["address"],
        photo: json["photo"],
        phone: json["phone"],
        stars: json["stars"],
        ratings: json["ratings"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "descrip": descrip,
        "lat": lat,
        "lng": lng,
        "address": address,
        "photo": photo,
        "phone": phone,
        "stars": stars,
        "ratings": ratings,
      };
}
