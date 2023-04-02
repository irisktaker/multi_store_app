import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/app_bar_widget.dart';

class StaticsScreen extends StatelessWidget {
  const StaticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(
          title: 'Statics',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
