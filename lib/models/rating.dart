class Rating {
  int id;
  int stars;
  int userid;
  int huecaid;
  String comentario;

  Rating({this.id, this.stars, this.userid, this.huecaid, this.comentario});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json["id"],
      stars: json["stars"],
      userid: json["user_id"],
      huecaid: json["hueca_id"],
      comentario: json["comentario"]
    );
  }

  factory Rating.zero() {
    return Rating(
      stars: 0,
      comentario: ""
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "stars": this.stars,
      "hueca_id": this.huecaid,
      "comentario": this.comentario ?? '<no comment>',
    };
  }
}
