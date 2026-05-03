import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'features/home/home_page.dart';
import 'features/crops/crops_page.dart';
import 'features/tasks/tasks_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {

  int _selectedIndex = 0;

  void _onItemTapped (int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(onNavigateToTasks: () => setState(() { _selectedIndex = 2; })),
          CropsPage(),
          TasksPage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF5BBF86),
        backgroundColor: Color(0xFF1C1208),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/homeIcon.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0 ? Color(0xFF5BBF86) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/CropsIcon.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1 ? Color(0xFF5BBF86) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: "Crops",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/TasksIcon.svg",
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2 ? Color(0xFF5BBF86) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: "Tasks",
          )
        ],
      ),
    );
  }
}
