import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main(){
  runApp(MobileApp());
}

class MobileApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 1;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color(0xff402D7C)),
        centerTitle: true,
        title: Image.asset(
            'assets/images/logo.png',
            width: 60,
            height: 60,
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                  'assets/images/camera.svg'
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff402D7C),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 20,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/calendar.svg',width: 25,
              height: 25,),
            activeIcon: SvgPicture.asset('assets/images/calendar-selected.svg',width: 25,
              height: 25,),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/home.svg',width: 25,
              height: 25,),
            activeIcon: SvgPicture.asset('assets/images/home-selected.svg',width: 25,
              height: 25,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/shop.svg',width: 25,
              height: 25,),
            activeIcon: SvgPicture.asset('assets/images/shop-selected.svg',width: 25,
              height: 25,),
            label: 'Shop',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

