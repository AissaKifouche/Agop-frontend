import 'package:agop/features/crops/crop.dart';
import 'package:agop/features/home/my_account_page.dart';
import 'package:agop/features/tasks/task.dart';
import 'package:agop/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'position.dart';
import 'package:geocoding/geocoding.dart';
import 'weather_service.dart';


class HomePage extends StatefulWidget {
  final VoidCallback onNavigateToTasks;
  const HomePage({super.key, required this.onNavigateToTasks});



  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  Position? _currentPosition;
  String _locationName = "";
  WeatherData? _weatherData;
  int? farmerId;
  List<Crop>? crops;
  String? username;
  List<Task>? tasks;


  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  void refresh() => loadData();


  //a method to get the weather
  Future<void> _fetchWeather(double lat, double lon) async {
    try {
      final data = await WeatherService.fetchWeather(lat, lon);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load weather."), backgroundColor: Colors.redAccent),
        );
      }
  }



  // a method to get location
  Future<void> _fetchLocation() async {
    try{
      Position position = await determinePosition();
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude
      );
      Placemark place = placeMarks[0];
      setState(() {
        _currentPosition = position;
        _locationName = "${place.locality}, ${place.administrativeArea} ${place.country}";
      });
      await _fetchWeather(position.latitude, position.longitude);
    }catch(e){
      setState(() {
      });
    }
  }



  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt("user_id");
      final name = prefs.getString("username");
      if (id == null) return;
      final result = await ApiService.getCrops(id);
      final loadedCrops = result.map((json) => Crop.fromJson(json)).toList();

      List<Task> allTasks = [];
      for (var crop in loadedCrops) {
        final task = await ApiService.getTasks(crop.id);
        allTasks.addAll(task.map((j) => Task.fromJson(j)));
      }

      setState(() {
        farmerId = id;
        username = name;
        crops = loadedCrops;
        tasks = allTasks;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data."), backgroundColor: Colors.redAccent),
      );
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchLocation();
    loadData();
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
                                username ?? "Loading",
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => MyAccountPage())
                              );
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
                                            _weatherData != null ? _weatherData!.tempCurrent.round().toString() : '--',
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
                          


                                      // a description
                                      Text(
                                        _weatherData?.description ?? "Loading",
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.35),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Icon(
                                    WeatherService.getIconData(_weatherData?.icon ?? "sunny"),
                                    color: Colors.white,
                                    size: 40,
                                  ),
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
                                        
                                        //humidity
                                        Text(
                                          _weatherData != null ? "${_weatherData!.humidity}%" : "--",
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
                                      color: Colors.white.withValues(alpha: 0.35),
                                    ),

                                    
                                    //rain
                                    Column(
                                      children: [
                                        Text(
                                          _weatherData != null ? "${_weatherData!.rainMm.toStringAsFixed(1)} mm" : "--",
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
                                      color: Colors.white.withValues(alpha: 0.35),
                                    ),

                                    
                                    //wind speed
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              _weatherData != null ? _weatherData!.windSpeed.round().toString() : "--",
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
                                      color: Colors.white.withValues(alpha: 0.35),
                                    ),

                                    
                                    //UV
                                    Column(
                                      children: [
                                        Text(
                                          _weatherData?.uvIndex ?? "--",
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
                        children: [
                          // NOW card (current weather)
                          SizedBox(
                            width: 60,
                            height: 95,
                            child: Card(
                              color: Color(0xFF2E1F0F),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 5),
                                  Text("NOW", style: TextStyle(fontSize: 10, color: Color(0xFF7A5C3A))),
                                  SizedBox(height: 5),
                                  Icon(
                                    WeatherService.getIconData(_weatherData?.icon ?? "sunny"),
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(height: 5),
                                  Text("${_weatherData?.tempMax.round() ?? "--"}°",
                                      style: TextStyle(fontSize: 14, color: Colors.white)),
                                  Text("${_weatherData?.tempMin.round() ?? "--"}°",
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
                                ],
                              ),
                            ),
                          ),

                          // Next 4 days from forecast
                          if (_weatherData != null)
                            ...(_weatherData!.forecast.map((day) => Row(
                              children: [
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 95,
                                  width: 60,
                                  child: Card(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(day.label, style: TextStyle(fontSize: 10, color: Color(0xFF7A5C3A))),
                                        SizedBox(height: 5),
                                        Icon(
                                          WeatherService.forecastIconData(day.weatherCode),
                                          size: 15,
                                        ),
                                        SizedBox(height: 5),
                                        Text("${day.tempMax.round()}°",
                                            style: TextStyle(fontSize: 14, color: Colors.black)),
                                        Text("${day.tempMin.round()}°",
                                            style: TextStyle(color: Color(0xFFB8926A), fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ))),
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


                          child: _weatherData == null
                            ? Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFB8860B))))
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [


                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      WeatherService.formatTime(_weatherData!.sunriseTs),
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

                                  color: Color(0xFFB8860B).withValues(alpha: 0.3),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      WeatherService.daylightDuration(_weatherData!.sunriseTs, _weatherData!.sunsetTs),
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

                                  color: Color(0xFFB8860B).withValues(alpha: 0.3),
                                ),


                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      WeatherService.formatTime(_weatherData!.sunsetTs),
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
                          onPressed: widget.onNavigateToTasks,

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
                    if (tasks == null)
                      Center(child: CircularProgressIndicator())
                    else
                      Builder(
                        builder: (context) {
                          final todayTasks = tasks!
                              .where((t) => !t.isDone && _sameDay(t.dueDate, DateTime.now()))
                              .toList();

                          if (todayTasks.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text("No tasks for today 🌱", style: TextStyle(color: Colors.grey)),
                              ),
                            );
                          }

                          return Column(
                            children: todayTasks.map((t) {
                              final crop = crops?.firstWhere(
                                    (c) => c.id == t.cropId,
                                orElse: () => null as dynamic,
                              );
                              if (crop == null) return SizedBox.shrink();
                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${t.type.label} ${crop.name}',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1F16)),
                                            ),
                                            SizedBox(height: 6),
                                            Row(children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: t.type.color.withValues(alpha: 0.15),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                                  Text(t.type.icon2, style: TextStyle(fontSize: 11)),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    crop.name.toUpperCase(),
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: t.type.color, letterSpacing: 0.5),
                                                  ),
                                                ]),
                                              ),
                                              SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  'Anytime today · ${crop.fieldName}',
                                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ]),
                                          ],
                                        ),
                                      ),
                                      Text(t.type.icon2, style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),



                  ],
                ),
              ),
            ],
          ),
        ),
      );

  }
}
