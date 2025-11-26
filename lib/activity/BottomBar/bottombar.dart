import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    const HomeScreen(wishlistmemberid: 'KKDMB00010',interestedmemberid: 'KKDMB00010'),
    searchScreen(),
     const MyProfile(memberId: "20",id: '1',),
    const intrestedScreen(),
    const wishlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    int currentIndex = widget.index;
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: BottomNavigationBar(
        selectedItemColor: const Color(0xff000080),
        showUnselectedLabels: true,
        unselectedItemColor: const Color(0xFFDF0A0A),
        currentIndex: currentIndex,
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _pages[index] ),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.handshake,
            ),
            label: "Matched Profile",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.user,
            ),
            label: "MyProfile",
          ),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.solidHeart,
              ),
              label: "Interested"),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.gift,
              ),
              label: "Wishlist"),
        ],
      ),
    );
  }
}
