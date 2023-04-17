import 'package:flutter/material.dart';
import 'package:multi_store_app/galleries/men_gallery.dart';
import '../widgets/fake_search.dart';

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
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.50),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const FakeSearchWidget(),
          bottom: const TabBar(
            isScrollable: true,
            indicatorWeight: 8,
            indicatorColor: Colors.yellow,
            tabs: [
              RepeatedTabs(label: 'Men'),
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
            MenGalleryScreen(),
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
