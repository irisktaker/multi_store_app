import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/app_bar_widget.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';

class CartScreen extends StatefulWidget {
  final bool canPop;
  const CartScreen({Key? key, this.canPop = false}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const AppBarTitle(title: 'Cart'),
            leading: widget.canPop ? const AppBarBackButton() : null,
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
                      // Navigator.pushNamedAndRemoveUntil(
                      //   context,
                      //   "/customer_home",
                      //   (route) => false,
                      // );

                      Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : Navigator.pushReplacementNamed(
                              context,
                              "/customer_home",
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
                YellowButton(
                  label: 'checkout',
                  onPressed: () {},
                  widthRatio: 0.45,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
