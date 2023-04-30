import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/app_bar_widget.dart';

import 'delivered.dart';
import 'preparing.dart';
import 'shipping.dart';

class SupplierOrders extends StatelessWidget {
  const SupplierOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const AppBarTitle(
            title: 'Orders',
          ),
          leading: const AppBarBackButton(),
          bottom: const TabBar(
            indicatorColor: Colors.yellow,
            indicatorWeight: 8,
            tabs: [
              RepeatedTabs(label: 'Preparing'),
              RepeatedTabs(label: 'Shipping'),
              RepeatedTabs(label: 'Delivered'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Preparing(),
            Shipping(),
            Delivered(),
          ],
        ),
      ),
    );
  }
}

class RepeatedTabs extends StatelessWidget {
  final String label;
  const RepeatedTabs({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
