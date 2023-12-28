import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  int? id;
  String? username;
  String? email;
  String? password;
  String? phone;
  String? country;
  String? userId;
  String? location;
  String? token;
  String? lang;
  bool? blocked;

  Client({
    this.id,
    this.username,
    this.email,
    this.password,
    this.phone,
    this.country,
    this.userId,
    this.location,
    this.lang,
    this.token,
    this.blocked,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    phone: json["phone"],
    country: json["country"],
    userId: json["userid"],
    location: json["location"],
    lang: json["lang"],
    token: json["token"],
    blocked: json["blocked"] == 1,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "username": username,
    "email": email,
    "password": password,
    "phone": phone,
    "country": country,
    "userid": userId,
    "location": location,
    "lang": lang,
    "token": token,
    "blocked": blocked,
  };
}