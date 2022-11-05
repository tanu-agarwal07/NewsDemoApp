import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_demo_app/Provider/news_provider.dart';
import 'package:provider/provider.dart';

import '../../Common/common_drawer.dart';
import '../../Common/constant_methods.dart';
import '../detail_screen.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {

  dynamic height,width;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        drawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text('Wishlist',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          leading: InkWell(
              onTap: (){
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Image.asset('assets/menu.png',scale: 3.5,)),
        ),
      body: Consumer<NewsProvider>(
        builder: (context, value, child) {
          return SizedBox(
            height: height,
            width: width,
            child: value.bookmarkList.isEmpty ?
                Center(
                  child: Text('No wishlist added!',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                )
                : ListView.builder(
              itemCount: value.bookmarkList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var data = value.bookmarkList[index];

                var date = DateFormat('MMMM dd,yyyy').format(DateTime.parse(data.publishedAt!));

                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                      articles: value.bookmarkList[index],
                    )));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.25,
                          height: height * 0.14,
                          margin: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                image: DecorationImage(fit: BoxFit.cover,
                                    image:NetworkImage(data.urlToImage!))),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        SizedBox(
                          width: width * 0.61,
                          height: height * 0.14,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 0.45,
                                    child: Text(data.title!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: (){
                                        if(data.isBookmarked!){
                                          setState((){
                                            data.isBookmarked = false;
                                            value.bookmarkList.removeAt(index);
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: height*0.04,
                                        width: width*0.1,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius: BorderRadius.circular(7),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 1,spreadRadius: 1,
                                                  offset: Offset(-1,2)
                                              )
                                            ]
                                        ),
                                        child: Center(
                                            child: Icon(data.isBookmarked! ? Icons.bookmark : Icons.bookmark_border_outlined)
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: width*0.5,
                                    child: Text(
                                      data.description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Color(0xff686868),
                                          fontSize: 12),
                                    ),
                                  ),

                                ],
                              ),
                              const SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  ConstantMethods().launchNews(data.url);
                                },
                                child: const Text(
                                  "View in browser",
                                  style: TextStyle(color: Color(0xffFF0000), fontSize: 11,decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      )
    );
  }
}
