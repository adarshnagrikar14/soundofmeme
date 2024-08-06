// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundofmeme/apiconfig.dart';
import 'package:soundofmeme/models/all_song_model.dart';
import 'package:http/http.dart' as http;
import 'package:soundofmeme/reusables/playsong.dart';

class LikedSongsPage extends StatefulWidget {
  const LikedSongsPage({super.key});

  @override
  _LikedSongsPageState createState() => _LikedSongsPageState();
}

class _LikedSongsPageState extends State<LikedSongsPage> {
  List<Song> _likedSongs = [];
  bool _isLoading = true;
  String? _accessToken = "";
  Color blueColor = const Color.fromARGB(255, 15, 23, 42);

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await getToken();
    setState(() {
      _accessToken = token.toString();
    });
    _loadLikedSongs();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _loadLikedSongs() async {
    try {
      final likedSongIds = await _getLikedSongIds();
      final List<Song> songs = [];

      for (String id in likedSongIds) {
        final song = await _fetchSongById(id);
        songs.add(song);
      }

      setState(() {
        _likedSongs = songs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Song> _fetchSongById(String songId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/getsongbyid?id=$songId'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Song.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load song');
    }
  }

  Future<List<String>> _getLikedSongIds() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? likedSongIds = prefs.getStringList('liked_songs');
    return likedSongIds ?? [];
  }

  Future<void> _dislikeSong(String songId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/dislike'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'song_id': songId}),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        List<String>? likedSongIds = prefs.getStringList('liked_songs');
        likedSongIds?.remove(songId);
        await prefs.setStringList('liked_songs', likedSongIds ?? []);
        _loadLikedSongs();
      } else {
        throw Exception('Failed to dislike song');
      }
    } catch (e) {
      print('Error disliking song: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      appBar: AppBar(
        title: const Text(
          'Liked Songs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: blueColor,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white60,
            ))
          : Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 10.0,
              ),
              child: _likedSongs.isEmpty
                  ? const Center(
                      child: Text(
                        "No liked sounds!",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _likedSongs.length,
                      itemBuilder: (context, index) {
                        final song = _likedSongs[index];
                        return GestureDetector(
                          onTap: () {
                            print(song.songUrl);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaySongPage(song: song),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            color: Colors.white12,
                            elevation: 2.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      song.imageUrl,
                                      width: 80.0,
                                      height: 80.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          song.songName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          song.tags.isNotEmpty
                                              ? song.tags[0]
                                              : '',
                                          style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 12.0,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12.0,
                                            bottom: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Fluttertoast.showToast(
                                                      msg: "Deleting...");
                                                  _dislikeSong(
                                                      "${song.songId}");
                                                },
                                                child: const Icon(
                                                  LineIcons.heartAlt,
                                                  color: Colors.red,
                                                  size: 20.0,
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Text(
                                                "${song.likes}",
                                                style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const LineIcon(
                                    LineIcons.playCircle,
                                    size: 30.0,
                                    color: Colors.white60,
                                  ),
                                  const SizedBox(width: 10.0),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
