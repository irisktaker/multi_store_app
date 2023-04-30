import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class SupplierOrderModel extends StatelessWidget {
  final dynamic order;
  const SupplierOrderModel({Key? key, required this.order}) : super(key: key);

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
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.20),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Row(
                      children: [
                        const Text(
                          'Order Date: ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          (DateFormat('yyyy-MM-dd')
                              .format(order['order_date'].toDate())
                              .toString()),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    order['delivery_state'] == "delivered"
                        ? const Text("This order has been delivered.")
                        : Row(
                            children: [
                              const Text(
                                'Change Delivery Status To: ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              order['delivery_state'] == "preparing"
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(
                                          context,
                                          minTime: DateTime.now(),
                                          maxTime: DateTime.now().add(
                                            const Duration(days: 365),
                                          ),
                                          onConfirm: (DateTime date) async {
                                            await FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(order['order_id'])
                                                .update({
                                              'delivery_state': 'shipping',
                                              'delivery_date': date,
                                            });
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'Shipping?',
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order['order_id'])
                                            .update({
                                          'delivery_state': 'delivered',
                                        });
                                      },
                                      child: const Text(
                                        'Delivered?',
                                      ),
                                    ),
                            ],
                          ),
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
