import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:soundofmeme/models/all_song_model.dart';
import 'package:http/http.dart' as http;

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Color blueColor = const Color.fromARGB(255, 15, 23, 42);
  int? selectedIndex = 0;
  List<String> list = [
    'Trending',
    'Recently Added',
    'Premium',
  ];

  final List<Song> _songs = [];
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
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
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                // crossAxisSpacing: 6.0,
                mainAxisSpacing: 10.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _songs.length) {
                    return _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white24,
                            ),
                          )
                        : const SizedBox();
                  }

                  final song = _songs[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index % 2 == 0 ? 8.0 : 1.0,
                      right: index % 2 == 0 ? 1.0 : 8.0,
                    ),
                    child: Card(
                      color: Colors.white24,
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Opacity(
                              opacity: 1,
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
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              song.songName,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}
