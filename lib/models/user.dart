class User {
  User({
    this.id,
    this.username,
    this.firstname,
    this.lastname,
    this.email,
    this.address,
    this.phone  
  });

  int id;
  String username;
  String firstname;
  String lastname;
  String email;
  String address;
  String phone;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        address: json["address"],
        phone: json["phone"],
      );

factory User.zero() {
    return User(
      id: 0, username: "", firstname: "",
      lastname: "", email: "", address: "",
      phone: ""
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "address": address,
        "phone": phone,
      };
}
