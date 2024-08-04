// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundofmeme/reusables/selectchip.dart';

class CreationsPage extends StatefulWidget {
  const CreationsPage({super.key});

  @override
  State<CreationsPage> createState() => _CreationsPageState();
}

class _CreationsPageState extends State<CreationsPage> {
  Color blueColor = const Color.fromARGB(255, 15, 23, 42);
  String? _accessToken = "";

  final List<ChipItem> chipItems = [
    ChipItem(imageUrl: LineIcons.heart, title: 'A Lovely music'),
    ChipItem(imageUrl: LineIcons.drum, title: 'Hall of fame...'),
    ChipItem(imageUrl: LineIcons.lightbulb, title: 'Midnight Mirage'),
    ChipItem(imageUrl: LineIcons.speakerDeck, title: 'Electric Dreamscape'),
  ];

  void _onItemSelected(ChipItem item) {
    print('Selected Item: ${item.title}');
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await getToken();
    setState(() {
      _accessToken = token;
    });
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
            onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
