// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _accessToken = "";
  bool _isLoading = true;
  String? _userName;
  String? _userEmail;
  String? _userProfilePic;
  String? _songCount;
  String? _likeCount;

  Color blueColor = const Color.fromARGB(255, 15, 23, 42);
  Color blueColorBottom = const Color.fromARGB(255, 21, 32, 56);

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _getLikeCounts() async {
    try {
      final int likeCount = await getLikeCountFromPrefs();
      setState(() {
        _likeCount = "$likeCount";
      });
    } catch (e) {
      print('Error fetching likes count from SharedPreferences: $e');
    }
  }

  void _getSongCounts() async {
    final int songCount = await fetchUserSongsCount(_accessToken!);
    setState(() {
      _songCount = "$songCount";
    });
  }

  Future<int> getLikeCountFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? likedSongIds = prefs.getStringList('liked_songs');
    return likedSongIds?.length ?? 0;
  }

  Future<void> _checkToken() async {
    final token = await getToken();
    setState(() {
      _accessToken = token.toString();
    });
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      _fetchUserProfile();
      _getSongCounts();
      _getLikeCounts();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('http://18.204.16.28:80/user'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _userName = jsonResponse['name'];
          _userEmail = jsonResponse['email'];
          _userProfilePic = jsonResponse['profile_pic'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<int> fetchUserSongsCount(String accessToken) async {
    final response = await http.get(
      Uri.parse('http://18.204.16.28:80/usersongs?page=1'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> songs = jsonResponse['songs'];
      return songs.length;
    } else {
      throw Exception('Failed to load user songs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      appBar: AppBar(
        title: const Text(
          'Profile',
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
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  child: Card(
                    color: blueColorBottom,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 18.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: _userProfilePic != null
                                ? NetworkImage(_userProfilePic!)
                                : null,
                            radius: 50.0,
                            backgroundColor: Colors.white24,
                            child: _userProfilePic == null
                                ? const Icon(
                                    LineIcons.userAstronaut,
                                    size: 50.0,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            _userName ?? 'Loading...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            _userEmail ?? 'Loading...',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Sounds Created: $_songCount | Sounds liked: $_likeCount",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
