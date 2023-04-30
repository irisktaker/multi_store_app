import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/place_order_screen.dart';
import 'package:multi_store_app/models/cart_model.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:multi_store_app/widgets/app_bar_widget.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

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
          backgroundColor: Colors.blueGrey.shade50,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const AppBarTitle(title: 'Cart'),
            leading: widget.canPop ? const AppBarBackButton() : null,
            actions: [
              context.watch<Cart>().getCartItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                          context,
                          title: 'Clear Cart!',
                          content: 'Are you sure to clear your cart?',
                          tabNo: () => Navigator.pop(context),
                          tabYes: () {
                            context.read<Cart>().clearList();
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
                    ),
            ],
          ),

          // ..
          // this ->  Provider.of<Cart>(context, listen: false).getItems.isEmpty
          // same as context.red<Cart>().getItems.isNotEmpty
          // ..
          // and this ->  Provider.of<Cart>(context, listen: true).getItems.isEmpty
          // same as     context.watch<Cart>().getItems.isNotEmpty
          // *
          // Reading a value
          // The easiest way to read a value is by using the extension methods on [BuildContext]:
          //   context.watch<T>(), which makes the widget listen to changes on T
          //   context.read<T>(), which returns T without listening to it
          //   context.select<T, R>(R cb(T value)), which allows a widget to listen to only a small part of T.
          // One can also use the static method Provider.of<T>(context), which will behave similarly to watch. When the listen parameter is set to false (as in Provider.of<T>(context, listen: false)), then it will behave similarly to read.
          // It's worth noting that context.read<T>() won't make a widget rebuild when the value changes and it cannot be called inside StatelessWidget.build/State.build. On the other hand, it can be freely called outside of these methods.
          // */

          body: context.watch<Cart>().getCartItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: const CartBottomSheetWidget(),
        ),
      ),
    );
  }
}

class CartBottomSheetWidget extends StatelessWidget {
  const CartBottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Total: ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                total.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          YellowButton(
            label: 'checkout',
            onPressed: total == 0.0
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaceOrderScreen(),
                      ),
                    );
                  },
            widthRatio: 0.45,
          )
        ],
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 65),
        child: ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getCartItems[index];

            return CartModel(
              product: product,
              cart: context.read<Cart>(),
            );
          },
        ),
      );
    });
  }
}
