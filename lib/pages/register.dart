import 'dart:developer';
import 'package:flutter_mobile_1/config/internal_config.dart';
import 'package:flutter_mobile_1/model/request/customerRegisterPost_req.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register_page extends StatefulWidget {
  const Register_page({super.key});

  @override
  State<Register_page> createState() => _Register_pageState();
}

class _Register_pageState extends State<Register_page> {
  var phonCtl = TextEditingController();
  var passCtl = TextEditingController();
  var fullnameCtl = TextEditingController();
  var emailCtl = TextEditingController();
  var confirmPasswordCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ลงทะเบียนสมาชิกใหม่")),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("ชื่อ-นามสกุล"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: fullnameCtl,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("หมายเลขโทรศัพท์"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: phonCtl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("อีเมลล์"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: emailCtl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("รหัสผ่าน"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: passCtl,
                  obscureText: true,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("ยืนยันรหัสผ่าน"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: confirmPasswordCtl,
                  obscureText: true,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: FilledButton(
                  onPressed: register,
                  child: const Text(
                    'สมัครสมาชิก',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text("หากมีบัญชีนี้อยู่แล้ว? "),
                  Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    Customer customer = Customer(
      fullname: fullnameCtl.text,
      phone: phonCtl.text,
      email: emailCtl.text,
      password: passCtl.text,
      confirmPassword: confirmPasswordCtl.text,
    );

    CustomerRegisterPostRequest req = CustomerRegisterPostRequest(
      message: "register",
      customer: customer,
    );

    http
        .post(
          Uri.parse(
            "$API_ENDPOINT/customers",
          ),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerRegisterPostRequestToJson(req),
        )
        .then((value) {
          log("Response status: ${value.statusCode}");
          log("Response body: ${value.body}");
          log("fullname: ${fullnameCtl.text}");
          log("phone: ${phonCtl.text}");
          log("email: ${emailCtl.text}");
          log("password: ${passCtl.text}");
          log("confirmPassword: ${confirmPasswordCtl.text}");

          if (value.statusCode == 200) {
            CustomerRegisterPostRequest res = customerRegisterPostRequest(
              value.body,
            );

            log("ลงทะเบียนสำเร็จ: ${res.customer.fullname}");
            log("Email: ${res.customer.email}");

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("ลงทะเบียนสำเร็จ")));
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("ลงทะเบียนไม่สำเร็จ")));
          }
        })
        .catchError((error) {
          log('Error: $error');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด: $error")));
        });
  }
}
