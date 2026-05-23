import 'package:flutter/material.dart';
import 'package:agop/shared/widgets/agop_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agop/main_shell.dart';
import 'package:agop/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'verification_page.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isRememberMeChecked = false;


  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            child: Column(
              children: [ // contains the element : logo, text fields ...

                //main white card
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.black.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [

                        //first the logo of agop
                        SvgPicture.asset(
                          "assets/images/AgopLogo.svg",
                          height: 120,
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                        ),

                        //the text Agop
                        Text(
                          "Agop",
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontFamily: "Newsreader",
                            fontSize: 36,
                            letterSpacing: -0.9,
                          ),
                        ),

                        //a space
                        SizedBox(height: 32,),

                        //username field using the customised input field AgopTextField
                        AgopTextField(
                          label: "email",
                          hintText: "enter your email",
                          controller: _emailController,
                        ),

                        SizedBox(height: 24,),

                        //the username field

                        AgopTextField(
                          label: "username",
                          hintText: "choose a username",
                          controller: _userNameController,
                        ),

                        SizedBox(height: 24,),


                        //the password field
                        AgopTextField(
                          label: "password",
                          hintText: "••••••••",
                          controller: _passwordController,
                          isPassword: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),

                        //space
                        SizedBox(height: 24,),

                        //the confirm password field

                        AgopTextField(
                          label: "confirm password",
                          hintText: "••••••••",
                          controller: _confirmPasswordController,
                          isPassword: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 24,),

                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 8,),
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: _isRememberMeChecked,
                                onChanged: (bool? val) {
                                  setState(() {
                                    _isRememberMeChecked = !_isRememberMeChecked;
                                  });
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Text("remember me", style: TextStyle(color: Color(0xFF3F4942)),),
                          ],
                        ),*/

                        //SizedBox(height: 24,),

                        //the button create account
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {

                                if (_passwordController.text != _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Passwords do not match."), backgroundColor: Colors.redAccent),
                                  );
                                  return;
                                }
                                try {
                                  final data = await ApiService.register(
                                    _userNameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                  );
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setInt("user_id", data["id"]);
                                  await prefs.setString("username", data["username"]);
                                  await prefs.setString("user_email", _emailController.text.trim());

                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerificationPage()));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Registration failed. Please try again."), backgroundColor: Colors.redAccent),
                                  );
                                }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(40)),
                            ),
                            child: Text(
                              "CREATE ACCOUNT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ), // the button

                        SizedBox(height: 24,),

                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "already have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3F4942),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
