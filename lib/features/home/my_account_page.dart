import 'package:agop/features/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agop/core/app_theme.dart';

import '../../services/api_service.dart';



class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {

  String? username;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false, // ← removes ALL previous routes
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My account",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration:  BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),

              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: SvgPicture.asset(
                      "assets/images/profile icon.svg",
                    ),
                  ),

                  Text(
                    username ?? "no name",
                    style: TextStyle(
                        fontFamily: "InstrumentSerif",
                        fontSize: 32,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 76,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "$username 's farm",
                        style: TextStyle(
                          fontSize: 30,

                        ),
                      ),
                    ),
                  )
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1208),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: Color(0xFFE85555),
                      fontSize: 30,
                      fontFamily: "InstrumentSerif",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Text(
              "Agop v1.0.0",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFB8926A),
                fontFamily: "InstrumentSerif",
              ),
            ),


          ],
        ),
      ),
    );
  }
}
