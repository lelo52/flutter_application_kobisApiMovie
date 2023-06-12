import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {


  Future<List<dynamic>> search({required String tp}) async {
    String site =
        'http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=01736d1cbc4c7f3e45f3f5f6354d4e12&targetDt=$tp';
    // print(site);
    var response = await http.get(Uri.parse(site));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var movies =
      //boxOfficeResult.dailyBoxOfficeList
          jsonDecode(response.body)['boxOfficeResult']['dailyBoxOfficeList'] as List<dynamic>;
      return movies;
    } else {
      return []; 
    }
  }
}