import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:soundofmeme/dashboard_pages/discover.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;
  Color blueColor = const Color.fromARGB(255, 15, 23, 42);
  Color blueColorBottom = const Color.fromARGB(255, 21, 32, 56);

  Future<bool> onBackPress() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: blueColorBottom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const DiscoverPage(),
      const Scaffold(),
      const Scaffold(),
    ];

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: SizedBox(
          height: 75.0,
          child: GNav(
            tabBorderRadius: 12,
            backgroundColor: blueColorBottom,
            tabActiveBorder: Border.all(color: Colors.white, width: 1),
            gap: 8,
            color: Colors.white54,
            activeColor: Colors.white,
            iconSize: 25,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Discover',
              ),
              GButton(
                icon: Icons.music_note_outlined,
                text: 'My Creations',
              ),
              GButton(
                icon: LineIcons.heart,
                text: 'Account',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
