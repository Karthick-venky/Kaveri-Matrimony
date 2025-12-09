import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../other_files/global.dart';
import '../Home Screens/homepage.dart';
import '../Home Screens/myprofile.dart';
import '../Intrested Screen/intrestedpage.dart';
import '../SearchScreen/searchpage.dart';
import '../wishlistScreen/whislistpage.dart';

class BottomBar extends StatefulWidget {

  final int index;

  const BottomBar({super.key,required this.index});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  final List<Widget> _pages = [
    const HomeScreen(wishlistmemberid: '', interestedmemberid: '',),
    searchScreen(),
    const MyProfile(memberId: '', id: '',),
    const intrestedScreen(),
    const wishlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    int currentIndex = widget.index;
    return SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
            color: MyColors.appBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: MyColors.appBackgroundColor,
            selectedItemColor: Color(0xff000080),
            unselectedItemColor: Colors.white,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _pages[index]),
              );
            },
            items: [
              BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.handshake), label: "Matched Profile"),
              BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.magnifyingGlass), label: "Search"),
              BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.user), label: "MyProfile"),
              BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.solidHeart), label: "Interested"),
              BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.gift), label: "Wishlist"),
            ],
          ),
        )
    );
  }
}
