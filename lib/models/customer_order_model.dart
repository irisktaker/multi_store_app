import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerOrderModel extends StatelessWidget {
  final dynamic order;
  const CustomerOrderModel({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow),
            borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 80),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(order['order_image']),
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        order['order_name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$ ' + order['order_price'].toStringAsFixed(2),
                            ),
                            Text(
                              'x ' + order['order_quantity'].toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('See More ..'),
              Text(
                order['delivery_state'],
              ),
            ],
          ),
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: order['delivery_state'] == "delivered"
                    ? Colors.green.withOpacity(0.20)
                    : Colors.yellow.withOpacity(0.20),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ' + order['name'],
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Phone No: ' + order['phone'],
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Email Address: ' + order['email'],
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Address: ' + order['address'],
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Payment Status: ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          order['payment_status'],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Delivery Status: ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          order['delivery_state'],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    order['delivery_date'].toString() != "" ||
                            order['delivery_state'] == "shipping"
                        ? Text(
                            'Estimated Delivery Date: ' +
                                (DateFormat('yyyy-MM-dd')
                                    .format(order['delivery_date'].toDate())
                                    .toString()),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          )
                        : const Text(""),
                    order['delivery_state'] == "delivered" &&
                            !order['order_review']
                        ? TextButton(
                            onPressed: () {},
                            child: const Text('Write Review'),
                          )
                        : const Text(""),
                    order['delivery_state'] == "delivered" &&
                            order['order_review']
                        ? Row(
                            children: const [
                              Icon(
                                Icons.check,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Review Added',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        : const Text(""),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
