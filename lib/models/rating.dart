class Rating {
  int id;
  int stars;
  int userid;
  int huecaid;
  String comentario;

  Rating({this.id, this.stars, this.userid, this.huecaid, this.comentario});

  Map<String, dynamic> toJson(){
    return {
      "stars": this.stars,
      "user_id": this.userid,
      "hueca_id": this.huecaid,
      "comentario": this.comentario,
    };
  }

  
}
