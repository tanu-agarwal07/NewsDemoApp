import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/news_model.dart';

class Api{

  static Future<NewsListModel> newsList(currentPage) async{
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // var token = pref.getString('token');
    var body = {
      'q' : 'a',
      'apiKey' : '38ac1e4bc5e64b12a56d141bdd2fdee5',
      'pageSize' : '20',
      'page' : currentPage,
    };
    var uri = Uri.https('newsapi.org', '/v2/everything', body);
    // print(uri);
    http.Response response = await http.get(uri);
    print(jsonDecode(response.body));
    return NewsListModel.fromJson(jsonDecode(response.body));
  }

}