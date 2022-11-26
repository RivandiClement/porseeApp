import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xff402D7C)),
          centerTitle: true,
          title: Image.asset(
            'assets/images/logo.png',
            width: screenWidth * 0.125,
            height: screenHeight * 0.125,
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.04),
              child: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                    'assets/images/camera.svg'
                ),
              ),
            ),
          ],
        ),
        body: Container(
            margin: EdgeInsets.only(top: screenHeight * 0.01, left: screenWidth * 0.04, right: screenWidth * 0.04),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: screenHeight * 0.05,
                        child: TextField(
                          style: const TextStyle(fontSize: 16),
                          cursorColor: const Color(0xff402D7C),
                          decoration: InputDecoration(
                            fillColor: const Color(0xffF3F3F3),
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none
                            ),
                            hintText: "search for menu",
                            prefixIcon: IconButton(
                              splashColor: Colors.transparent,
                              icon: Padding(
                                padding: EdgeInsets.zero,
                                child: SvgPicture.asset(
                                  'assets/images/search.svg', height: screenHeight * 0.03, width: screenWidth * 0.03,
                                ),
                              ), onPressed: () {  },
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.015),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index){
                            return Card(
                              child: ListTile(
                                onTap: (){},
                                title: Text("test"),
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/logo.png'),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                ),
              ],
            ),
        ),
        drawer: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 25),
            child: Container(
              width: 230,
              height: 500,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      title: Text('data'),
                    ),
                  ],
                ),
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
              icon: SvgPicture.asset('assets/images/calendar.svg',width: screenWidth * 0.03,
                height: screenHeight * 0.03,),
              activeIcon: SvgPicture.asset('assets/images/calendar-selected.svg',width: screenWidth * 0.03,
                height: screenHeight * 0.03,),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/home.svg',width: screenWidth * 0.03,
                height: screenHeight * 0.03,),
              activeIcon: SvgPicture.asset('assets/images/home-selected.svg',width: screenWidth * 0.03,
                height: screenHeight * 0.03,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/shop.svg',width: screenWidth * 0.03,
                height: screenHeight * 0.03,),
              activeIcon: SvgPicture.asset('assets/images/shop-selected.svg',width: screenWidth * 0.03,
                height: screenHeight * 0.03,),
              label: 'Shop',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}