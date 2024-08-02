import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 15.0,
                bottom: 12.0,
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
              title: const Text(
                'Discover',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
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
              child: Column(
                children: [
                  Padding(
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
                  const SizedBox(
                    height: 600.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
