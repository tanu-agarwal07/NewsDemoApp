import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/dashboard_provider.dart';
import '../Screens/MainScreen/dashboard.dart';

class BottomNavigationCustom extends StatefulWidget {
  const BottomNavigationCustom({Key? key}) : super(key: key);

  @override
  State<BottomNavigationCustom> createState() => _BottomNavigationCustomState();
}

class _BottomNavigationCustomState extends State<BottomNavigationCustom> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardProvider>(
      builder: (context, value, child) {
        return Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1,color: Colors.grey)],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: (){
                  value.changeScreenIndex(0, context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/home.png',scale: 3,
                      color: value.currentIndex == 0 ? Color(0xffFF0000) : Color(0xff8B8B8B),),
                    const SizedBox(height: 5,),
                    Text('Home')
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  value.changeScreenIndex(1, context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/wishlist.png',scale: 1.5,
                      color: value.currentIndex == 1 ? Color(0xffFF0000) : Color(0xff8B8B8B),),
                    const SizedBox(height: 5,),
                    const Text('Wishlist')
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
