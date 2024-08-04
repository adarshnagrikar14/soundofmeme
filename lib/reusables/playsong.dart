import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:soundofmeme/models/all_song_model.dart';

class PlaySongPage extends StatefulWidget {
  final Song song;
  const PlaySongPage({super.key, required this.song});

  @override
  State<PlaySongPage> createState() => _PlaySongPageState();
}

class _PlaySongPageState extends State<PlaySongPage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _songDuration = Duration.zero;
  Color blueColor = const Color.fromARGB(255, 15, 23, 42);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: blueColor,
      ),
    );
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _songDuration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPauseSong() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(widget.song.songUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // ignore: unused_element
  void _stopSong() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _currentPosition = Duration.zero;
    });
  }

  void _seekSong(double value) {
    final position = Duration(seconds: value.toInt());
    _audioPlayer.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, blueColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                widget.song.songName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.song.imageUrl,
                      width: MediaQuery.of(context).size.width,
                      height: 300.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 4.0,
                      sigmaY: 0.5,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.song.imageUrl,
                    width: MediaQuery.of(context).size.width,
                    height: 300.0,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                // color: Colors.white10,
              ),
              margin: const EdgeInsets.only(top: 20.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    widget.song.songName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Slider(
                    value: _currentPosition.inSeconds.toDouble(),
                    min: 0.0,
                    activeColor: Colors.grey,
                    inactiveColor: Colors.white24,
                    thumbColor: Colors.white,
                    max: _songDuration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _seekSong(value);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              LineIcons.heartAlt,
                              color: Colors.white54,
                              size: 20.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "${widget.song.likes}",
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 22.0,
                          right: 22.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            100.0,
                          ),
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isPlaying ? LineIcons.pause : LineIcons.play,
                            color: Colors.white,
                            size: 38.0,
                          ),
                          onPressed: _playPauseSong,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              LineIcons.play,
                              color: Colors.white54,
                              size: 20.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "${widget.song.views}",
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const Spacer(),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 12.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                  border: Border.all(color: Colors.white10),
                  color: Colors.white.withAlpha(5),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          widget.song.lyrics,
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
