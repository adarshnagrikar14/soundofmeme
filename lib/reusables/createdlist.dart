import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:soundofmeme/models/all_song_model.dart';
import 'package:http/http.dart' as http;

class UserSongsPage extends StatefulWidget {
  final String accessToken;

  const UserSongsPage({super.key, required this.accessToken});

  @override
  _UserSongsPageState createState() => _UserSongsPageState();
}

class _UserSongsPageState extends State<UserSongsPage> {
  List<Song> songs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserSongs();
  }

  Future<void> fetchUserSongs() async {
    final response = await http.get(
      Uri.parse('http://18.204.16.28:80/usersongs?page=1'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> songJson = jsonDecode(response.body);
      setState(() {
        songs = songJson.map((json) => Song.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(song.imageUrl),
                    title: Text(
                      song.songName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      song.lyrics,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
    );
  }
}
