import 'package:flutter/material.dart';
import 'package:agop/shared/widgets/agop_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_icons/simple_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //controllers to manage user input
  final TextEditingController _identifierConroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;


  @override
  void dispose() {

    _identifierConroller.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 40),
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
                            label: "username, e-mail or phone NUMBER",
                            hintText: "enter your identifier",
                          controller: _identifierConroller,
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: false,
                                onChanged: (val) {
                                  // to handle later
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //don't forget
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(6)),
                              ),
                            ),
                            Text("remember me", style: TextStyle(color: Color(0xFF3F4942)),),
                            TextButton(
                              child: Text("Forgot password?", style: TextStyle(color: Color(0xFF0B613B)),),
                              onPressed: (){
                                //to handle later
                                //
                                //
                                //
                                //
                                //
                                //
                                //
                                //
                                //
                                //
                                //don't forget
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: 24,),

                        //the button login
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: (){
                              //to handle later
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                              //
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(40)),
                            ),
                            child: Text(
                              "LOG IN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ), // the button


                        SizedBox(height: 24,),
                        //the divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Color(0xFFBFC9BF),)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "OR CONTINUE WITH",
                                style: TextStyle(
                                  color: Color(0xFF3F4942),
                                  fontSize: 12
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Color(0xFFBFC9BF),)),
                          ],
                        ),

                        SizedBox(height: 32,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            //google button
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  //to handle later
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                },
                                icon: Icon(SimpleIcons.google),
                                label: Text(
                                  "Google",
                                  style: TextStyle(
                                    color: Color(0xFF1D1C16),
                                    fontSize: 14,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Color(0xFFBFC9BF)),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(40),
                                  )
                                ),
                              ),
                            ),


                            //facbk button
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  //to handle later
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                },
                                icon: Icon(SimpleIcons.facebook),
                                label: Text(
                                  "Facebook",
                                  style: TextStyle(
                                    color: Color(0xFF1D1C16),
                                    fontSize: 14,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Color(0xFFBFC9BF)),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(40),
                                    )
                                ),
                              ),
                            )
                          ],
                        ),

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
                      "don't have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3F4942),
                      ),
                    ),
                    
                    TextButton(
                      onPressed: () {
                        //to handle later
                        //
                        //
                        //
                        //
                        //
                        //
                        //
                      },
                      child: Text(
                        "Sign Up",
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
