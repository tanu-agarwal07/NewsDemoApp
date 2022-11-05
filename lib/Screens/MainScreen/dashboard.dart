import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Common/animated_dialog.dart';
import '../../Common/bottom_navogation_bar.dart';
import '../../Provider/dashboard_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return WillPopScope(
              onWillPop: () async => false,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return FunkyOverlay(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.clear),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Are you sure want to exit?',style: TextStyle(
                              fontSize: 18,fontWeight: FontWeight.bold
                          ),),
                        ),
                        SizedBox(height: 30,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text('No',
                                  style: TextStyle(fontSize: 17,color: Colors.grey,fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              onPressed: () async {
                                SystemNavigator.pop();
                              },
                              child: const Text('Yes',
                                  style: TextStyle(fontSize: 17,color: Color(0xffFF0000),fontWeight: FontWeight.bold)),
                            ),
                          ],),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationCustom(),
        body: Consumer<DashBoardProvider>(
          builder: (context, value, child) {
            return value.screenList[value.currentIndex];
          },
        ),
      ),
    );
  }
}
