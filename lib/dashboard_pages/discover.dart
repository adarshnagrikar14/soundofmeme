// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundofmeme/models/all_song_model.dart';
import 'package:http/http.dart' as http;
import 'package:soundofmeme/reusables/like_animation.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Color blueColor = const Color.fromARGB(255, 15, 23, 42);
  int? selectedIndex = 0;
  List<String> list = [
    'All',
    'Trending',
    'Recently Added',
    'Premium',
  ];

  final List<Song> _songs = [];
  int _currentPage = 1;
  bool _isLoading = false;
  String? _accessToken = "";

  List<String> _likedSongs = [];

  @override
  void initState() {
    super.initState();
    _checkToken();
    _fetchSongs();
    _loadLikedSongs();
  }

  Future<void> _checkToken() async {
    final token = await getToken();
    setState(() {
      _accessToken = token.toString();
    });
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _fetchSongs() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('http://18.204.16.28:80/allsongs?page=$_currentPage'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> fetchedSongs = jsonResponse['songs'];

      setState(() {
        _songs.addAll(fetchedSongs.map((data) => Song.fromJson(data)).toList());
        _currentPage++;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load songs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: blueColor,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 150.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(
                  left: 1.0,
                  bottom: 1.0,
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        blueColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        top: 10,
                        right: 12.0,
                        bottom: 10.0,
                      ),
                      child: Image.asset(
                        "assets/gifs/dashboard.gif",
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                    const Text(
                      'SoundOfMeme',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: blueColor,
              shadowColor: blueColor.withAlpha(210),
              elevation: 1.0,
              collapsedHeight: 70,
            ),
            SliverToBoxAdapter(
              child: Container(
                color: blueColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List<Widget>.generate(
                        list.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                            label: Text(list[index]),
                            showCheckmark: false,
                            selected: selectedIndex == index,
                            onSelected: (selected) {
                              setState(() {
                                selectedIndex = selected ? index : null;
                              });
                            },
                            selectedColor: blueColor.withAlpha(200),
                            backgroundColor: blueColor,
                            labelStyle: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Colors.white24,
                            ),
                            surfaceTintColor: blueColor,
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey.shade700,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _isLoading
                ? const SliverToBoxAdapter(
                    child: Opacity(
                      opacity: 0.6,
                      child: LoadingWidget(),
                    ),
                  )
                : SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      // crossAxisSpacing: 6.0,
                      mainAxisSpacing: 10.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final song = _songs[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index % 2 == 0 ? 8.0 : 1.0,
                            right: index % 2 == 0 ? 1.0 : 8.0,
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 26, 39, 70),
                            elevation: 5.0,
                            shadowColor: Colors.grey.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Opacity(
                                    opacity: 0.9,
                                    child: Image.network(
                                      song.imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                      color: Colors.black12,
                                      colorBlendMode: BlendMode.multiply,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 10.0,
                                  ),
                                  child: Text(
                                    song.songName,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 5.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    song.tags[0],
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 5.0,
                                    bottom: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (_likedSongs
                                              .contains("${song.songId}")) {
                                            await _dislikeSong(
                                                "${song.songId}");
                                          } else {
                                            LottiePopupManager().showPopup(
                                                context,
                                                'assets/gifs/like.json');
                                            await _likeSong("${song.songId}");
                                          }
                                        },
                                        child: Icon(
                                          _likedSongs.contains("${song.songId}")
                                              ? LineIcons.heartAlt
                                              : LineIcons.heart,
                                          color: _likedSongs
                                                  .contains("${song.songId}")
                                              ? Colors.red
                                              : Colors.white60,
                                          size: 20.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        "${song.likes}",
                                        style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: _songs.length,
                    ),
                  ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _likeSong(String songId) async {
    final response = await http.post(
      Uri.parse('http://18.204.16.28:80/like'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'song_id': songId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _likedSongs.add(songId);
      });
      _saveLikedSongs();
      Fluttertoast.showToast(
        msg: "Sound Liked.",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: blueColor,
      );
      LottiePopupManager().hidePopup();
    } else {
      throw Exception('Failed to like song');
    }
  }

  Future<void> _dislikeSong(String songId) async {
    final response = await http.post(
      Uri.parse('http://18.204.16.28:80/dislike'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'song_id': songId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _likedSongs.remove(songId);
      });
      _saveLikedSongs();
    } else {
      throw Exception('Failed to dislike song');
    }
  }

  Future<void> _saveLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('liked_songs', _likedSongs).whenComplete(() {});
  }

  Future<void> _loadLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _likedSongs = prefs.getStringList('liked_songs') ?? [];
    });
  }
}

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 20).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Padding(
                padding: EdgeInsets.only(top: _animation.value),
                child: child,
              );
            },
            child: Image.asset(
              "assets/images/wait.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Loading Sounds for you...",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
