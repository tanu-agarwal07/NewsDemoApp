import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_demo_app/Provider/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Provider/dashboard_provider.dart';
import 'Screens/MainScreen/dashboard.dart';
import 'Screens/login_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DashBoardProvider()),
      ChangeNotifierProvider(create: (_) => NewsProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gilroy',
        scaffoldBackgroundColor: const Color(0xfff2f2f2),
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: Color(0xFF172E4D),
        // )
      ),
      home: const SplashScreen(),
    ),
  ),);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  dynamic height, width;

  autoLogin() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var news = Provider.of<NewsProvider>(context,listen: false);
    var token = pref.getString('GoogleEmail');
    var image = pref.getString('image');
    var name = pref.getString('name');
    print(token);
    if(token != null){
      news.email = token;
      news.name = name!;
      news.image = image!;
      return Timer(
          const Duration(seconds: 3),
              () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const MainScreen())));
    }else{
      return Timer(
          const Duration(seconds: 3),
              () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen())));
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState((){});
    });
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Image.asset('assets/news_logo.png',scale: 1,),
          ),
        ),
      ),
    );
  }
}
