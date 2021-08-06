import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

//TODO: complete this page - you may choose to change it to a stateful widget if necessary

Future<PlayListType> fetchPlaylist() async {
  final response = await http.get(
    Uri.parse(
        'https://palota-jobs-africa-spotify-fa.azurewebsites.net/api/browse/categories/afro/playlists'),
    headers: {
      "x-functions-key": dotenv.env['API_KEY'].toString(),
    },
  );
  //print(response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return PlayListType.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load playlist');
  }
}

class PlayListType {
  final String categoryName;
  final String imageUrl;

  PlayListType({
    required this.categoryName,
    required this.imageUrl,
  });

  factory PlayListType.fromJson(Map<String, dynamic> json) {
    return PlayListType(
      imageUrl: json['imageUrl'].toString(),
      categoryName: json['name'].toString(),
    );
  }
}

class SpotifyPlaylist extends StatefulWidget {
  const SpotifyPlaylist({Key? key}) : super(key: key);

  @override
  _SpotifyPlaylistState createState() => _SpotifyPlaylistState();
}

class _SpotifyPlaylistState extends State<SpotifyPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
