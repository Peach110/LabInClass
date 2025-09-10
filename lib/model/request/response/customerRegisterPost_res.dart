import 'dart:convert';

CustomerRegisterPostResponse customerRegisterPostResponseFromJson(String str) =>
    CustomerRegisterPostResponse.fromJson(json.decode(str));

String customerRegisterPostResponseToJson(CustomerRegisterPostResponse data) =>
    json.encode(data.toJson());

class CustomerRegisterPostResponse {
  String phone;
  String password;
  String name;
  String email;
  String confirmPassword;

  CustomerRegisterPostResponse({
    required this.phone,
    required this.password,
    required this.name,
    required this.email,
    required this.confirmPassword,
  });

  factory CustomerRegisterPostResponse.fromJson(Map<String, dynamic> json) =>
      CustomerRegisterPostResponse(
        phone: json["phone"],
        password: json["password"],
        name: json["name"],
        email: json["email"],
        confirmPassword: json["confirmPassword"],
      );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "password": password,
    "name": name,
    "email": email,
    "confirmPassword": confirmPassword,
  };
}
