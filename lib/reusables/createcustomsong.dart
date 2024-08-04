// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';

class CreateCustomSongDialog extends StatefulWidget {
  final String accessToken;
  final Function(String) onSongCreated;

  const CreateCustomSongDialog({
    super.key,
    required this.accessToken,
    required this.onSongCreated,
  });

  @override
  _CreateCustomSongDialogState createState() => _CreateCustomSongDialogState();
}

class _CreateCustomSongDialogState extends State<CreateCustomSongDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _lyricsController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();

  bool _isLoading = false;
  Color blueColor = const Color.fromARGB(255, 15, 23, 42);

  Future<void> _createSong() async {
    final songTitle = _titleController.text.trim();
    final songLyrics = _lyricsController.text.trim();
    final songGenre = _genreController.text.trim();

    if (songTitle.isEmpty || songLyrics.isEmpty || songGenre.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://18.204.16.28:80/createcustom'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': songTitle,
        'lyric': songLyrics,
        'genere': songGenre,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      widget.onSongCreated(songTitle);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create song. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: blueColor,
                child: Card(
                  color: Colors.white10.withOpacity(0.11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(
                        color: Colors.white12, style: BorderStyle.solid),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: "animatedAstronaut",
                            child: LottieBuilder.asset(
                              "assets/gifs/loading.json",
                              height: 200.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextField(
                              enabled: !_isLoading,
                              controller: _titleController,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Song Title',
                                labelStyle: TextStyle(color: Colors.white70),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  LineIcons.penNib,
                                  color: Colors.white60,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white54),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextField(
                              enabled: !_isLoading,
                              controller: _lyricsController,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Lyrics',
                                labelStyle: TextStyle(color: Colors.white70),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  LineIcons.music,
                                  color: Colors.white60,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white54),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextField(
                              enabled: !_isLoading,
                              controller: _genreController,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Genre',
                                labelStyle: TextStyle(color: Colors.white70),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  LineIcons.heartAlt,
                                  color: Colors.white60,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white54),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          if (_isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white38,
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 12.0, bottom: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _createSong,
                                    child: const Text(
                                      'Create',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
