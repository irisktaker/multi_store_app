import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screens/customer_home_screen.dart';
import 'package:multi_store_app/widgets/app_bar_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(title: 'Cart'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Cart Is Empty!',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 50),
            Material(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(25),
              child: MaterialButton(
                elevation: 0,
                minWidth: MediaQuery.of(context).size.width * 0.60,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerHomeScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  'Total: ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '00.00',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(25)),
              child: MaterialButton(
                onPressed: () {},
                child: Text(
                  'Checkout'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
