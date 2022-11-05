import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_demo_app/Model/news_model.dart';
import 'package:provider/provider.dart';

import '../Common/constant_methods.dart';
import '../Provider/news_provider.dart';


class NewsDetailScreen extends StatefulWidget {
  final Articles articles;
  const NewsDetailScreen({Key? key,required this.articles}) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {

  dynamic height, width;

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          body: Consumer<NewsProvider>(
            builder: (context, value, child) {
              return SizedBox(
                height: height,
                width: width,
                child: Column(
                  children: [
                    Container(
                      height: height*0.45,
                      width: width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.articles.urlToImage!),
                              fit: BoxFit.fill
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: height*0.02,),
                              Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: IconButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,),
                                  )
                              ),
                            ],
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: width*0.8,
                                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                  child: Text(widget.articles.title! ?? '',
                                    maxLines: 4,
                                    style: const TextStyle(
                                        color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600
                                    ),),
                                ),
                                SizedBox(height: height*0.02,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

                                        children: [
                                          Text('By ${widget.articles.author == null ? "" : widget.articles.author!}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                                        ],
                                      ),
                                      Text(DateFormat('MMMM dd,yyyy').format(DateTime.parse(widget.articles.publishedAt!)),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                                    ],
                                  ),
                                ),
                                SizedBox(height: height*0.02,),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                    SizedBox(height: height*0.02,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(widget.articles.description! ?? '',
                        style: const TextStyle(
                            color: Color(0xff686868),fontSize: 16
                        ),),
                    ),
                    SizedBox(height: height*0.02,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(widget.articles.content! ?? '',
                        style: const TextStyle(
                            color: Color(0xff686868),fontSize: 16
                        ),),
                    ),
                    SizedBox(height: height*0.02,),
                    GestureDetector(
                      onTap: (){
                        ConstantMethods().launchNews(widget.articles.url);
                      },
                      child: const Text(
                        "View in browser",
                        style: TextStyle(color: Color(0xffFF0000), fontSize: 11,decoration: TextDecoration.underline),
                      ),
                    ),
                    SizedBox(height: height*0.02,),
                  ],
                ),
              );
            },
          )
      ),
    );
  }
}
