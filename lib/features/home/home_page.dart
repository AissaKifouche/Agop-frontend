import 'package:agop/features/crops/crops_page.dart';
import 'package:agop/features/tasks/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'position.dart';
import 'package:geocoding/geocoding.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Position? _currentPosition;
  bool _isPositionLoading = true;
  String _locationName = "";

  Future<void> _fetchLocation() async {
    try{
      Position position = await determinePosition();

      print("coordinates found: ${position.latitude}");

      List<Placemark> placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude
      );

      print("finished here");

      Placemark place = placeMarks[0];

      setState(() {
        _currentPosition = position as Position?;
        _locationName = "${place.locality}, ${place.administrativeArea} ${place.country}";
        _isPositionLoading = false;
      });
    }catch(e){
      setState(() {
        _isPositionLoading = false;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchLocation();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF1C1208),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [

                      //a row for the text good morning and an icon for the profile
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //the text good morning
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "good morning",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13
                                ),
                              ),
                              SizedBox(height: 4,),
                              Text(
                                "Ahmed Benali",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  fontFamily: "InstrumentSerif",
                                ),
                              ),
                            ],
                          ),

                          //the profile Icon
                          IconButton(
                            onPressed: (){

                            },
                            icon: SvgPicture.asset(
                              "assets/images/profile icon.svg",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24,),

                      //the weather card
                      Card(
                        
                        color: Color(0xFF2E1F0F),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            // a row then a divider then a row
                            children: [
                              //a row for the location
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.grey,
                                            size: 12,
                                          ),
                                          SizedBox(width: 2,),
                                          Text(
                                            _currentPosition != null ?
                                            _locationName : "Locating...",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12
                                            ),
                                          )
                                        ],
                                      ),

                                      SizedBox(height: 3.5,),
                          
                                      //the temperature
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "32",
                                            style: TextStyle(
                                              fontSize: 60,
                                              color: Colors.white,
                                              fontFamily: "InstrumentSerif",
                                            ),
                                          ),

                                          Text(
                                            "°",
                                            style: TextStyle(
                                              fontSize: 32,
                                              color: Colors.white
                                            ),
                                          )
                                        ],
                                      ),
                          

                          
                                      Text(
                                        "Clear skies",
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.35),
                                        ),
                                      ),
                                    ],
                                  ),
                          
                                  Icon(Icons.sunny),
                                ],
                              ),
                          
                              Divider(
                                height: 32,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),

                              SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "38%",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "HUMIDITY",
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.white.withValues(alpha: 0.5)
                                          ),
                                        ),
                                      ],
                                    ),

                                    VerticalDivider(
                                      width: 40,
                                      color: Colors.white.withValues(alpha: 0.35),
                                    ),

                                    Column(
                                      children: [
                                        Text(
                                          "0 mm",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "RAIN",
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white.withValues(alpha: 0.5)
                                          ),
                                        ),
                                      ],
                                    ),

                                    VerticalDivider(
                                      thickness: 1,
                                      width: 40,
                                      color: Colors.white.withValues(alpha: 0.35),
                                    ),

                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "18 ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 1,),

                                            Text(
                                              "km/h",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "WIND",
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white.withValues(alpha: 0.5)
                                          ),
                                        ),
                                      ],
                                    ),

                                    VerticalDivider(
                                      width: 40,
                                      color: Colors.white.withValues(alpha: 0.35),
                                    ),

                                    Column(
                                      children: [
                                        Text(
                                          "High",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "UV",
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white.withValues(alpha: 0.5)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //the row of a summary of the weather for 5 days

              SizedBox(height: 24,),



              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 95,
                            child: Card(
                              color: Color(0xFF2E1F0F),
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Text(
                                    "NOW",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF7A5C3A),
                                    ),
                                  ),

                                  SizedBox(height: 5,),

                                  Icon(
                                    Icons.sunny,
                                    color: Colors.white,
                                    size: 15,
                                  ),

                                  SizedBox(height: 5,),

                                  Text(
                                    "32°",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),

                                  Text(
                                    "19°",
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      fontSize: 11
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),


                          SizedBox(
                            height: 95,
                            width: 60,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                children: [

                                  SizedBox(height: 5,),
                                  Text(
                                    "NOW",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF7A5C3A),
                                    ),
                                  ),

                                  SizedBox(height: 5,),

                                  Icon(
                                    Icons.sunny,
                                    size: 15,
                                  ),

                                  SizedBox(height: 5,),

                                  Text(
                                    "32°",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),

                                  Text(
                                    "19°",
                                    style: TextStyle(
                                        color: Color(0xFFB8926A),
                                        fontSize: 11
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),


                          SizedBox(
                            height: 95,
                            width: 60,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                children: [

                                  SizedBox(height: 5,),

                                  Text(
                                    "NOW",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF7A5C3A),
                                    ),
                                  ),

                                  SizedBox(height: 5,),

                                  Icon(
                                    Icons.sunny,
                                    size: 15,
                                  ),

                                  SizedBox(height: 5,),

                                  Text(
                                    "32°",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),

                                  Text(
                                    "19°",
                                    style: TextStyle(
                                        color: Color(0xFFB8926A),
                                        fontSize: 11
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),


                          SizedBox(
                            height: 95,
                            width: 60,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                children: [

                                  SizedBox(height: 5,),

                                  Text(
                                    "NOW",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF7A5C3A),
                                    ),
                                  ),

                                  SizedBox(height: 5,),

                                  Icon(
                                    Icons.sunny,
                                    size: 15,
                                  ),

                                  SizedBox(height: 5,),

                                  Text(
                                    "32°",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),

                                  Text(
                                    "19°",
                                    style: TextStyle(
                                        color: Color(0xFFB8926A),
                                        fontSize: 11
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),


                          SizedBox(
                            height: 95,
                            width: 60,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                children: [

                                  SizedBox(height: 5,),

                                  Text(
                                    "NOW",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF7A5C3A),
                                    ),
                                  ),

                                  SizedBox(height: 5,),

                                  Icon(
                                    Icons.sunny,
                                    size: 15,
                                  ),

                                  SizedBox(height: 5,),

                                  Text(
                                    "32°",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),

                                  Text(
                                    "19°",
                                    style: TextStyle(
                                        color: Color(0xFFB8926A),
                                        fontSize: 11
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),



                        ],
                      ),
                    ),

                    SizedBox(height: 16,),

                    
                    //the card for the sunrise and sunset 
                    SizedBox(
                      height: 60,
                      child: Card(
                        color: Color(0xFFFDF3D0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),


                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [


                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "06:14",
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),

                                  Text(
                                    "SUNRISE",
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      fontSize: 9,
                                    ),

                                  )
                                ],
                              ),

                              VerticalDivider(
                                width: 80,
                                color: Color(0xFFB8860B).withValues(alpha: 0.3),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "12:50",
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),

                                  Text(
                                    "DAYLIGHT",
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      fontSize: 9,
                                    ),

                                  )
                                ],
                              ),

                              VerticalDivider(
                                width: 80,
                                color: Color(0xFFB8860B).withValues(alpha: 0.3),
                              ),


                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "18:52",
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),

                                  Text(
                                    "SUNSET",
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      fontSize: 9,
                                    ),

                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16,),

                    //the row for tasks text...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's tasks",
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 20,
                            fontFamily: "InstrumentSerif"
                          ),
                        ),

                        TextButton(
                          onPressed: (){

                          },

                          child: Text(
                            "See all",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2E7A52)
                            ),
                          ),
                        )
                      ],
                    ),


                    //the tasks cards




                  ],
                ),
              ),
            ],
          ),
        ),
      );

  }
}
