import 'package:flutter/material.dart';

class SubCategoryProducts extends StatelessWidget {
  final String mainCateName;
  final String subCateName;
  const SubCategoryProducts(
      {Key? key, required this.subCateName, required this.mainCateName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: Text(
          subCateName,
        ),
      ),
      body: Center(
        child: Text(mainCateName),
      ),
    );
  }
}
