// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundofmeme/reusables/createcustomsong.dart';
import 'package:soundofmeme/reusables/createsong.dart';
import 'package:soundofmeme/reusables/selectchip.dart';
import 'package:soundofmeme/models/all_song_model.dart';
import 'package:http/http.dart' as http;

class CreationsPage extends StatefulWidget {
  const CreationsPage({super.key});

  @override
  State<CreationsPage> createState() => _CreationsPageState();
}

class _CreationsPageState extends State<CreationsPage> {
  Color blueColor = const Color.fromARGB(255, 15, 23, 42);
  Color blueColorBottom = const Color.fromARGB(255, 21, 32, 56);
  String? _accessToken = "";
  List<Song> songs = [];
  bool _isLoading = false;

  final List<ChipItem> chipItems = [
    ChipItem(imageUrl: LineIcons.heart, title: 'A Lovely music'),
    ChipItem(imageUrl: LineIcons.drum, title: 'Hall of fame...'),
    ChipItem(imageUrl: LineIcons.lightbulb, title: 'Midnight Mirage'),
    ChipItem(imageUrl: LineIcons.speakerDeck, title: 'Electric Dreamscape'),
  ];

  void _onItemSelected(ChipItem item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CreateSongDialog(
          accessToken: _accessToken!,
          initialSongName: item.title,
          onSongCreated: (String songName) {
            Fluttertoast.showToast(msg: "Sound Added!");
            fetchUserSongs();
          },
        );
      },
    );
    print('Selected Item: ${item.title}');
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> fetchUserSongs() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('http://18.204.16.28:80/usersongs?page=1'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> fetchedSongs = jsonResponse['songs'];

      songs.clear();
      setState(() {
        songs.addAll(fetchedSongs.map((data) => Song.fromJson(data)).toList());
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load songs');
    }
  }

  Future<void> _checkToken() async {
    final token = await getToken();
    setState(() {
      _accessToken = token;
    });
    fetchUserSongs();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      appBar: AppBar(
        title: const Text(
          'Creations',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: blueColor,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => _showOptions(),
            backgroundColor: Colors.white12,
            tooltip: "Create Sound!",
            child: const Icon(LineIcons.music),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Create",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Try something?",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 12.0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SelectChip(
                      items: chipItems,
                      onItemSelected: _onItemSelected,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "My Creations",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(
                        top: 12.0,
                      ),
                      color: blueColor,
                      child: ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return songs.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No sound created yet...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  color: Colors.white12,
                                  elevation: 2.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                                      onTap: () {},
                                                      child: const Icon(
                                                        LineIcons.heartAlt,
                                                        color: Colors.white24,
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
                                );
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _showOptions() {
    showCustomBottomSheet(
      context,
      blueColor: blueColor,
      option1: 'Create a Song?',
      option2: 'Have custom lyrics?',
      onOption1Tap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CreateSongDialog(
              accessToken: _accessToken!,
              initialSongName: null,
              onSongCreated: (String songName) {
                Fluttertoast.showToast(msg: "Sound Added!");
                fetchUserSongs();
              },
            );
          },
        );
      },
      onOption2Tap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CreateCustomSongDialog(
              accessToken: _accessToken!,
              onSongCreated: (String songName) {
                Fluttertoast.showToast(msg: "Sound Created!");
                fetchUserSongs();
              },
            );
          },
        );
      },
    );
  }

  void showCustomBottomSheet(BuildContext context,
      {required Color blueColor,
      required String option1,
      required String option2,
      required Function() onOption1Tap,
      required Function() onOption2Tap}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: blueColorBottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: "animatedAstronaut",
                child: LottieBuilder.asset(
                  "assets/gifs/loading.json",
                  height: 150.0,
                ),
              ),
              Card(
                color: Colors.white10,
                child: ListTile(
                  leading: const Icon(
                    LineIcons.penFancy,
                    color: Colors.white54,
                  ),
                  title: Text(
                    option1,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onOption1Tap();
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                color: Colors.white10,
                child: ListTile(
                  leading: const Icon(
                    LineIcons.music,
                    color: Colors.white54,
                  ),
                  title: Text(
                    option2,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onOption2Tap();
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      },
    );
  }
}
