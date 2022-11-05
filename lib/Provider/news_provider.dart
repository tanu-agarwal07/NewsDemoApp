import 'package:flutter/material.dart';
import 'package:news_demo_app/Model/news_model.dart';

import '../Api/api.dart';

class NewsProvider with ChangeNotifier{

  bool newsLoader = false, loadMoreAllNews = false, nextAllNewsList = true, googleLoader = false;
  List<Articles> articles = [];
  List<Articles> fetchArticles = [];
  List<Articles> bookmarkList = [];
  int currentPage = 1;
  NewsListModel? newsListModel;
  String name = '', email = '', image = '';

  setNewsList(List<Articles> listModel){
    articles = listModel;
    notifyListeners();
  }

  setNewsData(NewsListModel listModel){
    newsListModel = listModel;
    notifyListeners();
  }

  getSearchData(List<Articles> list){
    setNewsList(list);
  }

  setFetchNewsList(List<Articles> listModel){
    fetchArticles = listModel;
    notifyListeners();
  }

  updateFetchNewsLoader(bool load){
    loadMoreAllNews = load;
    notifyListeners();
  }

  updateNewsLoader(bool load){
    newsLoader = load;
  }

  updateGoogleLoader(bool load){
    googleLoader = load;
    notifyListeners();
  }

  Future newsListApi() async{
    updateNewsLoader(true);
    var res = await Api.newsList(currentPage.toString());
    setNewsData(res);
    setNewsList(res.articles!);
    updateNewsLoader(false);
    return res;
  }

}