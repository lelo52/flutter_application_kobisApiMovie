import 'package:flutter/material.dart';
import 'kobis_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  dynamic mvList = const Text("검색하세요");

  void showCal() async {
    var dt = await showDatePicker(
      context: context,
      initialDate: DateTime(2010, 1, 1),
      firstDate: DateTime(2010, 1, 1),
      lastDate: DateTime.now(),
    );
    if (dt != null) {
      String tp = dt.toString().split(' ')[0].replaceAll('-', '');
      var koApi = Api();
      var komv = await koApi.search(tp: tp);

      setState(() {
        if (komv.isEmpty) {
          mvList = Center(
            child: Text('결과가 텅텅'),
          );
        } else {
          mvList = ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(komv[index]['rank']+"위 "+komv[index]['movieNm']),
                subtitle: Text(komv[index]['openDt']
                    .toString()
                    .replaceAll('<br/>', '\n')),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: komv.length,
          );
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("20230101"),
          Expanded(child: mvList),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCal,
        child: Icon(Icons.calendar_today),
      ),
    );
  }
}
