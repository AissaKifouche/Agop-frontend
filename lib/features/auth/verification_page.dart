import 'package:agop/features/auth/login_page.dart';
import 'package:agop/main_shell.dart';
import 'package:agop/shared/widgets/agop_text_field.dart';
import 'package:flutter/material.dart';
import 'package:agop/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';





class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(


          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AgopTextField(
                  label: "you will receive a verification code",
                  hintText: "enter the verification code ",
                  controller: _verificationCodeController,
                ),
                SizedBox(height: 20,),



                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: ()async{
                      final prefs = await SharedPreferences.getInstance();

                      final savedEmail = prefs.getString("user_email") ?? "";
                      bool succes = await ApiService().verifyEmail(savedEmail, _verificationCodeController.text.trim());
                      if(succes){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid code")),
                      );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    ),

                    child: Text(
                      "Verify",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
