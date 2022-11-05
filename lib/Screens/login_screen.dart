import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_demo_app/Api/google_sign_in.dart';
import 'package:news_demo_app/Common/constant_methods.dart';
import 'package:news_demo_app/Provider/news_provider.dart';
import 'package:news_demo_app/Screens/MainScreen/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  dynamic height,width;
  String flag = '🇮🇳', code = ' +91';
  TextEditingController mobile = TextEditingController();
  User? user;

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: (){
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                SizedBox(height: height*0.1,),
                Image.asset('assets/news_logo.png',scale: 1.5,),
                SizedBox(height: height*0.1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Get Going with ride on',style:
                    TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                  ],
                ),
                SizedBox(height: height*0.06,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: height*0.07,
                      width: width*0.65,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 60,
                            color: Colors.white,
                            child: Center(child: Text(flag+code,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),)),
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            height: height*0.05,width: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            width: width*0.35,
                            child: TextFormField(
                              controller: mobile,
                              inputFormatters: [LengthLimitingTextInputFormatter(10)],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '0123456789',
                                  hintStyle: TextStyle(color: Colors.grey)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 15,),
                    GestureDetector(
                      onTap: (){
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (BuildContext context) => const MainScreen()));
                      },
                      child: Container(
                        height: height*0.07,
                        width: width*0.15,
                        decoration: BoxDecoration(
                            color: const Color(0xffFF0000),
                            // color: const Color(0xff003BAC),
                            borderRadius: BorderRadius.circular(7),
                            boxShadow:  const [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(-4, 5),
                                  blurRadius: 3,
                                  spreadRadius: -2
                              )
                            ]
                        ),
                        child: const Center(child: /*value.sendOtpLoader ? SizedBox(height: 20,width: 20,
                          child: ConstantMethods().loader(),) :*/
                         Icon(Icons.arrow_forward,color: Colors.white,size: 28,),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height*0.14,),
                const Text('Or sign up with social account',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 17,),),
                SizedBox(height: height*0.03,),
                Consumer<NewsProvider>(
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: ()async{
                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                        value.updateGoogleLoader(true);
                        user = await Authentication.signInWithGoogle(context: context);
                        if(user != null){
                          value.updateGoogleLoader(false);
                          sharedPreferences.setString('GoogleEmail', user!.email!);
                          sharedPreferences.setString('name', user!.displayName!);
                          sharedPreferences.setString('image', user!.photoURL!);
                          value.image = user!.photoURL!;
                          value.name = user!.displayName!;
                          value.email = user!.email!;
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => const MainScreen()));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: height*0.07,
                        width: width*0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/google.png',scale: 3,),
                            const SizedBox(width: 20,),
                            value.googleLoader ? ConstantMethods().loader() :
                            const Text('Login with Google',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),)
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
