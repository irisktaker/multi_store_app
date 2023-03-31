import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../minor_screens/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.yellow,
                  width: 1.4,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              // child: const CupertinoSearchTextField(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Text(
                        "What are you looking for?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 32,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    // ignore: prefer_const_constructors
                    child: Center(
                      child: const Text(
                        "Search",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            indicatorWeight: 8,
            indicatorColor: Colors.yellow,
            tabs: [
              RepeatedTabs(label: "Men"),
              RepeatedTabs(label: "Women"),
              RepeatedTabs(label: "Shoes"),
              RepeatedTabs(label: "Bags"),
              RepeatedTabs(label: "Electronics"),
              RepeatedTabs(label: "Accessories"),
              RepeatedTabs(label: "Home & Garden"),
              RepeatedTabs(label: "Kids"),
              RepeatedTabs(label: "Beauty"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Men screen')),
            Center(child: Text('Women screen')),
            Center(child: Text('Shoes screen')),
            Center(child: Text('Bags screen')),
            Center(child: Text('Electronics screen')),
            Center(child: Text('Accessories screen')),
            Center(child: Text('Home & Garden screen')),
            Center(child: Text('Kids screen')),
            Center(child: Text('Beauty screen')),
          ],
        ),
      ),
    );
  }
}

class RepeatedTabs extends StatelessWidget {
  final String label;
  const RepeatedTabs({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
