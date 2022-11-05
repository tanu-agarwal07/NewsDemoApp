import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_demo_app/Api/google_sign_in.dart';
import 'package:news_demo_app/Screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/news_provider.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {

  dynamic height, width;


  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var news = Provider.of<NewsProvider>(context,listen: false);

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.close,size: 30,),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: height*0.12,
                    width: width*0.24,
                    margin: const EdgeInsets.only(top: 10,right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: Offset(-1,2),
                          blurRadius: 2,spreadRadius: 2
                        )
                      ]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(news.image,fit: BoxFit.fill,),
                    )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(news.name,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
                      SizedBox(height: 8,),
                      Text(news.email,style: TextStyle(fontSize: 18,color: Color.fromRGBO(0, 0, 0, 0.5)),),
                    ],
                  ),
                ),

              ],
            ),
            const SizedBox(height: 10,),
            const Divider(thickness: 3,),
            InkWell(
              onTap: ()async{
                SharedPreferences pref = await SharedPreferences.getInstance();
                var g = pref.getString('GoogleEmail');
                await Authentication.signOut(context: context);
                pref.remove('GoogleEmail');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10,top: 10,left: 8),
                  child: Row(
                    children: [
                      Container(
                          height: 35,
                          width: 32,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 193, 7, 0.2),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Center(child: Image.asset('assets/logout.png',scale: 0.9,))),
                      const SizedBox(width: 10,),
                      const Text('Log Out',style: TextStyle(
                        color: Colors.black,fontSize: 17,
                      ),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
