import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_demo_app/Model/news_model.dart';
import 'package:news_demo_app/Provider/news_provider.dart';
import 'package:provider/provider.dart';
import '../../Api/api.dart';
import '../../Common/common_drawer.dart';
import '../../Common/constant_methods.dart';
import '../../Common/search_method.dart';
import '../detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  dynamic height,width;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController search = TextEditingController();

  void loadMore() async {
    print("loadmore == ");
    var order = Provider.of<NewsProvider>(context,listen: false);
    if (order.nextAllNewsList == true &&
        order.newsLoader == false &&
        order.loadMoreAllNews == false &&
        _controller.position.extentAfter < 300) {
      order.updateFetchNewsLoader(true);
      setState(() {
        order.currentPage += 1;
      });
      final res = await Api.newsList(order.currentPage.toString());
      if(res.status == 'ok'){
        order.setFetchNewsList(res.articles!);
        if (order.fetchArticles.isNotEmpty) {
          setState(() {
            order.articles.addAll(order.fetchArticles);
          });
        } else {
          setState(() {
            order.nextAllNewsList = false;
          });
        }

      }else{
        setState(() {
          order.nextAllNewsList = false;
        });
      }
      order.updateFetchNewsLoader(false);
    }
  }

  late ScrollController _controller;

  @override
  void initState() {
    var order = Provider.of<NewsProvider>(context,listen: false);
    order.newsListApi();
    _controller =  ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        drawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Color(0xffFF0000),
          elevation: 0,
          leading: InkWell(
              onTap: (){
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Image.asset('assets/menu.png',scale: 3.5,color: Colors.white,)),
          actions: [
            Image.asset('assets/notification.png',scale: 3,color: Colors.white,),
          ],
        ),
        body: SafeArea(
          child: Consumer<NewsProvider>(
            builder: (context, value, child) {
              return Column(
                children: [
                  Container(
                    height: height*0.1,
                    width: width,
                    decoration: const BoxDecoration(
                        color: Color(0xffFF0000),
                        boxShadow: [BoxShadow(blurRadius: 1,color: Colors.grey)],
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                    ),
                    child: Center(
                      child: Container(
                        height: height*0.06,
                        width: width*0.8,
                        decoration: BoxDecoration(
                            color: const Color(0xffF4F4F5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextFormField(
                          controller: search,
                          onChanged: (v){
                            if(search.text.isNotEmpty){
                              print('search ===');
                              GenericMethods<Articles>().buildSearchList(search.text, value.articles).then((val) {
                                print('search === 2 ');
                                value.getSearchData(val);
                              });
                            }else{
                              value.setNewsList(value.articles);
                              value.newsListApi();
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              hintText: 'Search Here',
                              hintStyle: const TextStyle(color: Colors.grey)
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height*0.66,
                    width: width,
                    child:  SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: height*0.01,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('News',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                          SizedBox(height: height*0.01,),
                          value.newsLoader ? SizedBox(
                            height: height*0.4,
                            child: ConstantMethods().loader(),
                          ) :
                          value.articles.isEmpty ? SizedBox(
                            height: height*0.4,
                            child: Center(
                              child: Text('No News',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                            ),
                          ) :SizedBox(
                            height: height*0.6,
                            width: width,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: value.articles.length,
                                    shrinkWrap: true,
                                    controller: _controller,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var data = value.articles[index];

                                      var date = DateFormat('MMMM dd,yyyy').format(DateTime.parse(data.publishedAt!));

                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                                            articles: value.articles[index],
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
                                                          value.bookmarkList.remove(value.articles[index]);
                                                        });
                                                      }else{
                                                        setState((){
                                                          data.isBookmarked = true;
                                                          value.bookmarkList.add(value.articles[index]);
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
                                ),
                                // when the _loadMore function is running
                                if (value.loadMoreAllNews == true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                                    child: ConstantMethods().loader(),
                                  ),

                                // When nothing else to load
                                if (value.nextAllNewsList == false)
                                  Container(
                                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                                    color: Colors.amber,
                                    child: const Center(
                                      child: Text('You have fetched all of the news'),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        )
    );
  }

  block(image, name){
    return Container(
      height: height*0.05,
      width: width*0.28,
      // padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,scale: 2.5,),
          const SizedBox(width: 12,),
          Text(name)
        ],
      ),
    );
  }
}
