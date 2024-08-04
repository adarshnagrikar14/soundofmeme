// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';

class CreateSongDialog extends StatefulWidget {
  final String accessToken;
  final String? initialSongName;
  final Function(String) onSongCreated;

  const CreateSongDialog({
    super.key,
    required this.accessToken,
    this.initialSongName,
    required this.onSongCreated,
  });

  @override
  _CreateSongDialogState createState() => _CreateSongDialogState();
}

class _CreateSongDialogState extends State<CreateSongDialog> {
  final TextEditingController _songController = TextEditingController();
  bool _isLoading = false;
  Color blueColor = const Color.fromARGB(255, 15, 23, 42);

  @override
  void initState() {
    super.initState();
    if (widget.initialSongName != null) {
      _songController.text = widget.initialSongName!;
      _createSong();
    }
  }

  Future<void> _createSong() async {
    final songName = _songController.text.trim();
    if (songName.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://18.204.16.28:80/create'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'song': songName}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      widget.onSongCreated(songName);
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
                        controller: _songController,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Song Name',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            LineIcons.lightbulbAlt,
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
                        padding:
                            const EdgeInsets.only(right: 12.0, bottom: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
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
        ],
      ),
    );
  }
}
