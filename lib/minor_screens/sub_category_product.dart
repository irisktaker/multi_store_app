import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/app_bar_widget.dart';

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
        leading: const AppBarBackButton(),
        title: AppBarTitle(title: subCateName),
      ),
      body: Center(
        child: Text(mainCateName),
      ),
    );
  }
}
