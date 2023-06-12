import 'package:flutter/material.dart';
import 'kobis_api.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
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
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  dynamic mvList = Text("검색하세요");

  void showCal() async {
    var dt = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022, 01, 01),
        lastDate: DateTime(2022, 12, 31));
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
                title: Text(komv[index]['movieNm']),
                subtitle: Text(komv[index]['salesAmt']
                    .toString()
                    .replaceAll('<br/>', '\n')),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: komv.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text("20230101"), Expanded(child: mvList)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCal,
        child: Icon(Icons.calendar_month),
      ),
    );
  }
}