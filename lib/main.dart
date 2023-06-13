import 'package:flutter/material.dart';
import 'kobis_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

  Future<void> showCal() async {
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
                title: Text(komv[index]['rank'] + "위 " + komv[index]['movieNm']),
                subtitle: Text(komv[index]['openDt']),
                onTap: () async {
                  if (komv[index] != null) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsPage(movie: komv[index]),
                      ),
                    );
                  }
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
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
          Text("박스오피스"),
          Expanded(child: mvList),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showCal();
        },
        child: Icon(Icons.calendar_today),
      ),
    );
  }
}

class MovieDetailsPage extends StatelessWidget {
  final dynamic movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var directors = '';
    if (movie['directors'] != null && movie['directors'].isNotEmpty) {
      directors = movie['directors'][0]['peopleNm'];
    }

    var movieNmEn = '';
    if (movie['movieNmEn'] != null) {
      movieNmEn = movie['movieNmEn'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['movieNm']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('영화 제목: ${movie['movieNm']}'),
            Text('감독: $directors'),
            Text('영문 제목: $movieNmEn'),
          ],
        ),
      ),
    );
  }
}
