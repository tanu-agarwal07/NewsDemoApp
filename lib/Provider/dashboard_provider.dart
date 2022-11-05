import 'package:flutter/material.dart';
import 'package:news_demo_app/Screens/BottomScreens/home_page.dart';
import 'package:news_demo_app/Screens/BottomScreens/wishlist.dart';

class DashBoardProvider with ChangeNotifier{

  int currentIndex = 0;

  List screenList = [
    const HomeScreen(),
    const WishListScreen(),
  ];

  changeScreenIndex(int index, BuildContext context){
    currentIndex = index;
    notifyListeners();
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
  }

}