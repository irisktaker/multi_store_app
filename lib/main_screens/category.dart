import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/fake_search.dart';

List<ItemData> items = [
  ItemData(label: 'Men'),
  ItemData(label: 'Women'),
  ItemData(label: 'Shoes'),
  ItemData(label: 'Bags'),
  ItemData(label: 'Electronics'),
  ItemData(label: 'Accessories'),
  ItemData(label: 'Home & Garden'),
  ItemData(label: 'Kids'),
  ItemData(label: 'Beauty'),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const FakeSearchWidget(),
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: sideNavigator(size)),
          Positioned(bottom: 0, right: 0, child: categoryView(size)),
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.80,
      width: size.width * 0.25,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // _pageController.jumpToPage(index);
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn,
              );

              // for (var element in items) {
              //   element.isSelected = false;
              // }
              // setState(() {
              //   items[index].isSelected = true;
              // });
            },
            child: Container(
              height: size.height / 8,
              color:
                  items[index].isSelected ? Colors.white : Colors.grey.shade300,
              child: Center(
                child: Text(
                  items[index].label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget categoryView(Size size) {
    return Container(
      height: size.height * 0.80,
      width: size.width * 0.75,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        children: const [
          Center(child: Text('men category')),
          Center(child: Text('women category')),
          Center(child: Text('shoes category')),
          Center(child: Text('bags category')),
          Center(child: Text('electronics category')),
          Center(child: Text('accessories category')),
          Center(child: Text('home and garden category')),
          Center(child: Text('kids category')),
          Center(child: Text('beauty category')),
        ],
      ),
    );
  }
}

class ItemData {
  String label;
  bool isSelected;

  ItemData({
    required this.label,
    this.isSelected = false,
  });
}
