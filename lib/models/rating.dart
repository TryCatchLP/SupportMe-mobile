class Rating {
  int id;
  int stars;
  int userid;
  int huecaid;
  String comentario;
  String huecaname;
  String username;

  Rating(
      {this.id,
      this.stars,
      this.userid,
      this.huecaid,
      this.comentario,
      this.huecaname,
      this.username});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
        id: json["id"],
        stars: json["stars"],
        userid: json["user_id"],
        huecaid: json["hueca_id"],
        comentario: json["comentario"]);
  }

  factory Rating.fromJsonDetail(Map<String, dynamic> json) {
    return Rating.fromJson(json)..huecaname = json["huecaname"];
  }

  factory Rating.fromJsonUser(Map<String, dynamic> json) {
    return Rating.fromJson(json)..username = json["username"];
  }

  factory Rating.zero() {
    return Rating(stars: 0, comentario: "");
  }

  Map<String, dynamic> toJson() {
    return {
      "stars": this.stars,
      "hueca_id": this.huecaid,
      "comentario": this.comentario ?? '<no comment>',
    };
  }
}
