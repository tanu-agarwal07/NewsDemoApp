import '../Model/search_model.dart';

class GenericMethods<T> {
  Future<List<T>> buildSearchList(String keyword, List<T> originalList) async {
    List<T> _searchList = [];

    for (int i = 0; i < originalList.length; i++) {
      String? name = "";
      if (originalList[i] is SearchModel) {
        name = (originalList[i] as SearchModel).getSearchString();
      } else {
        name = originalList[i].toString();
      }

      if (name!.toLowerCase().contains(keyword.toLowerCase())) {
        _searchList.add(originalList[i]);
      }
    }

    if (keyword.isEmpty) {
      _searchList = [];
    }

    return _searchList;
  }

  // Future<List<Bookmark>> bookMarkSearchList(String keyword, List<Bookmark> originalList) async {
  //   List<Bookmark> _searchList = [];
  //
  //   for (int i = 0; i < originalList.length; i++) {
  //     String name = "";
  //     if (originalList[i] is SearchModel) {
  //       name = (originalList[i] as SearchModel).getSearchString();
  //     } else {
  //       name = originalList[i].subjectName;
  //     }
  //
  //     if (name.toLowerCase().contains(keyword.toLowerCase())) {
  //       _searchList.add(originalList[i]);
  //     }
  //   }
  //
  //   if (keyword.isEmpty) {
  //     _searchList = [];
  //   }
  //
  //   return _searchList;
  // }

}
