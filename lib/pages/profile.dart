import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_1/config/config.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({super.key, required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> profile;

  late TextEditingController fullnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();
    profile = widget.userData;

    fullnameController = TextEditingController(text: profile['fullname'] ?? '');
    emailController = TextEditingController(text: profile['email'] ?? '');
    phoneController = TextEditingController(text: profile['phone'] ?? '');
    imageController = TextEditingController(text: profile['image'] ?? '');
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void updateProfile() {
    setState(() {
      profile['fullname'] = fullnameController.text;
      profile['email'] = emailController.text;
      profile['phone'] = phoneController.text;
      profile['image'] = imageController.text;
    });


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('สำเร็จ'),
        content: const Text('บันทึกข้อมูลเรียบร้อย'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: const InputDecoration(border: UnderlineInputBorder()),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'ยืนยันการยกเลิกสมาชิก?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('ปิด'),
                          ),
                          FilledButton(
                            onPressed: delete,
                            child: const Text('ยืนยัน'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: profile['image'] != ''
                    ? NetworkImage(profile['image'])
                    : const AssetImage('assets/images/ashe.png')
                        as ImageProvider,
              ),
              const SizedBox(height: 24),

              buildTextField("ชื่อ-นามสกุล", fullnameController),
              buildTextField("หมายเลขโทรศัพท์", phoneController),
              buildTextField("อีเมล์", emailController),
              buildTextField("รูปภาพ", imageController),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: updateProfile,
                  child: const Text(
                    'บันทึกข้อมูล',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void delete() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var res = await http.delete(Uri.parse('$url/customers/${profile['id']}'));
    log(res.statusCode.toString());

    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('ลบข้อมูลสำเร็จ'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },
              child: const Text('ปิด'),
            )
          ],
        ),
      ).then((s) {
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        );
      });
    } else {
      Navigator.pop(context); // ปิด dialog ยืนยันก่อน
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: const Text('ลบข้อมูลไม่สำเร็จ'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            )
          ],
        ),
      );
    }
  }
}
