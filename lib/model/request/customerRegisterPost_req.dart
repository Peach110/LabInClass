// To parse this JSON data, do
//
//     final CustomerRegisterPostRequest = CustomerRegisterPostRequest(jsonString);

import 'dart:convert';

CustomerRegisterPostRequest customerRegisterPostRequest(String str, {String? phone}) => CustomerRegisterPostRequest.fromJson(json.decode(str));

String customerRegisterPostRequestToJson(CustomerRegisterPostRequest data) => json.encode(data.toJson());

class CustomerRegisterPostRequest {
    String message;
    Customer customer;

    CustomerRegisterPostRequest({
        required this.message,
        required this.customer,
    });

    factory CustomerRegisterPostRequest.fromJson(Map<String, dynamic> json) => CustomerRegisterPostRequest(
        message: json["message"],
        customer: Customer.fromJson(json["customer"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "customer": customer.toJson(),
    };
}

class Customer {
    String fullname;
    String phone;
    String email;
    String password;
    String confirmPassword;

    Customer({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.password,
        required this.confirmPassword
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
    );

Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "password": password,
    "confirmPassword": confirmPassword,
};
}
