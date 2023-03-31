import 'package:flutter/material.dart';

import '../minor_screens/search.dart';

class FakeSearchWidget extends StatelessWidget {
  const FakeSearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
    );
  }
}
