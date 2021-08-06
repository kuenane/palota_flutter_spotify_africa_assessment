import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';
// ignore: unused_import
import 'package:flutter_spotify_africa_assessment/routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*

// TODO: fetch and populate playlist info and allow for click-through to detail
// Feel free to change this to a stateful widget if necessary
// */

Future<CategoryType> fetchCategory() async {
  final response = await http.get(
    Uri.parse(
        'https://palota-jobs-africa-spotify-fa.azurewebsites.net/api/browse/categories/afro'),
    headers: {
      "x-functions-key": dotenv.env['API_KEY'].toString(),
    },
  );
  //print(response.body);
  //json.decode(response.body)['results'];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return CategoryType.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load category');
  }
}

CategoryType categoryTypeFromJson(String str) =>
    CategoryType.fromJson(json.decode(str));

class CategoryType {
  CategoryType({
    required this.id,
    required this.href,
    required this.icons,
    required this.name,
    required this.type,
  });

  String id;
  String href;

  List<Icon> icons;
  String name;
  String type;

  factory CategoryType.fromJson(Map<String, dynamic> json) => CategoryType(
        id: json["id"],
        href: json["href"],
        icons: List<Icon>.from(json["icons"].map((x) => Icon.fromJson(x))),
        name: json["name"],
        type: json["type"],
      );
}

class Icon {
  Icon({
    this.height,
    required this.url,
    this.width,
  });

  dynamic height;
  String url;
  dynamic width;

  factory Icon.fromJson(Map<String, dynamic> json) => Icon(
        height: json["height"],
        url: json["url"],
        width: json["width"],
      );
}

class SpotifyCategory extends StatefulWidget {
  const SpotifyCategory({
    Key? key,
    required String categoryId,
  }) : super(key: key);
  @override
  _SpotifyCategoryState createState() => _SpotifyCategoryState();
}

class _SpotifyCategoryState extends State<SpotifyCategory> {
  late Future<CategoryType> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FutureBuilder<CategoryType>(
            future: futureCategory,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColors.blue,
                  AppColors.cyan,
                  AppColors.green,
                ],
              ),
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10),
            child: Align(
                alignment: Alignment.topCenter,
                child: FutureBuilder<CategoryType>(
                    future: futureCategory,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.icons.length,
                            itemBuilder: (context, int index) {
                              return Card(
                                  child: Container(
                                      height: 300,
                                      width: 300,
                                      color: Colors.grey[850],
                                      padding: const EdgeInsets.all(0),
                                      child: Column(children: [
                                        Expanded(
                                            flex: 14,
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                          (snapshot.data!.name),
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style
                                                              .apply(
                                                                fontSizeFactor:
                                                                    5.0,
                                                              )),
                                                      Spacer(
                                                        flex: 1,
                                                      ),
                                                      Expanded(
                                                        flex: 6,
                                                        child: Container(
// title: Text(snapshot.data!.categoryName),
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      snapshot
                                                                          .data!
                                                                          .icons[
                                                                              index]
                                                                          .url),
                                                                  fit: BoxFit
                                                                      .contain)),
                                                        ),
                                                      ),
                                                    ])))
                                      ])));
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      //
                    }))));
  }
}
