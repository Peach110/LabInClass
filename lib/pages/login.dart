import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_1/config/internal_config.dart';
import 'package:flutter_mobile_1/model/request/customerLoginPost_req.dart';
import 'package:flutter_mobile_1/model/request/response/customerLoginPost_res.dart';
import 'package:flutter_mobile_1/pages/register.dart';
import 'package:flutter_mobile_1/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  String text = "";
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Image.asset('assets/images/clipart997394.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text('หมายเลขโทรศัพท์'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                controller: phoneNoCtl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text('รหัสผ่าน'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                controller: passwordCtl,
                obscureText: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: register,
                    child: const Text(
                      'ลงทะเบียนใหม่',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  FilledButton(
                    onPressed: login,
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            Center(child: Text(text, style: const TextStyle(fontSize: 20))),
          ],
        ),
      ),
    );
  }

  void login() async {
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );

    try {
      final response = await http.post(
        Uri.parse("$API_ENDPOINT/customers/login"),
        headers: {"Content-Type": "application/json"},
        body: customerLoginPostRequestToJson(req),
      );

      log("📡 StatusCode: ${response.statusCode}");
      log("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        CustomerLoginPostResponse customerLoginPostResponse =
            customerLoginPostResponseFromJson(response.body);

        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ShowtripPage(
      cid: customerLoginPostResponse.customer.idx,
      userData: {
        'fullname': customerLoginPostResponse.customer.fullname,
        'email': customerLoginPostResponse.customer.email,
        'phone': customerLoginPostResponse.customer.phone,
        'image': customerLoginPostResponse.customer.image ?? '',
      },
    ),
  ),
);

      } else {
        setState(() {
          text = "❌ Login failed: ${response.body}";
        });
      }
    } catch (error) {
      log("🔥 Network Error: $error");
      setState(() {
        text = "ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้";
      });
    }
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register_page()),
    );
  }
}
