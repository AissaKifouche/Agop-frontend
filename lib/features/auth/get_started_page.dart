import 'package:agop/features/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // using a stack to make the element each one above the other starting with the image the the logo ...
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/getStarted.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              color: Colors.black.withValues(alpha: 0.64),
            ),

            SingleChildScrollView(

            child: Column(

              children: [

                    // the dark overlay on the image


                    //the other contents: text and button
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            SizedBox(height: 24,),

                            //the logo
                            SvgPicture.asset(
                                "assets/images/AgopLogoWhite.svg",

                            ),

                            // a space
                              SizedBox(
                                height: 350,
                              ),

                            //the text
                            Center(
                              child: Text(
                                "WELCOME TO AGOP",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            /*Center(
                              child: Text(
                                "AI powered farming",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight(300),
                                  color: Colors.white,
                                ),
                              ),
                            ),*/

                            //a sized box to separate between the text and the button
                            SizedBox(
                              height: 40,
                            ),

                            //the button get started
                            SizedBox(
                              width: double.infinity,
                              height: 70,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage() ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,        // uses the primary color in the app_theme.dart
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(37)
                                  )
                                ),
                                child: Text(
                                  "GET STARTED",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight(600),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            // a sized box to get the button far from the bottom

                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
          ]
        ),
      ),
    );
  }
}
