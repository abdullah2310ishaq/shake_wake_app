import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../home/home_screen.dart';
import 'order_tracking_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String selectedCity = 'Islamabad';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Success Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Order Placed Successfully!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Order ID: ${order.id.substring(0, 8).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Order Details Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _DetailRow(
                              label: 'Order Type',
                              value: order.orderType == OrderType.delivery
                                  ? 'Delivery'
                                  : 'Pickup',
                            ),
                            Row(
                              children: [
                                const Text('City:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return DropdownButton<String>(
                                      value: selectedCity,
                                      dropdownColor:
                                          Theme.of(context).cardTheme.color,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'Rawalpindi',
                                          child: Text('Rawalpindi',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Islamabad',
                                          child: Text('Islamabad',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            selectedCity = value;
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            _DetailRow(
                              label: 'Address',
                              value: '$selectedCity, ${order.address}',
                            ),
                            _DetailRow(
                              label: 'Order Time',
                              value:
                                  '${order.orderTime.day}/${order.orderTime.month}/${order.orderTime.year} at ${order.orderTime.hour}:${order.orderTime.minute.toString().padLeft(2, '0')}',
                            ),
                            if (order.scheduledTime != null)
                              _DetailRow(
                                label: 'Scheduled For',
                                value:
                                    '${order.scheduledTime!.day}/${order.scheduledTime!.month}/${order.scheduledTime!.year} at ${order.scheduledTime!.hour}:${order.scheduledTime!.minute.toString().padLeft(2, '0')}',
                              ),
                            const _DetailRow(
                              label: 'Payment Method',
                              value: 'Cash on Delivery',
                            ),
                            const Divider(),
                            _DetailRow(
                              label: 'Total Amount',
                              value:
                                  'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Items List
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Items Ordered',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...order.items
                                .map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${item.name} x${item.quantity}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            'Rs. ${item.totalPrice.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                ,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Estimated Time
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF8B4513).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 32,
                            color: Color(0xFF8B4513),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            order.orderType == OrderType.delivery
                                ? 'Estimated Delivery Time'
                                : 'Estimated Pickup Time',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '30-45 minutes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Back to Home'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderTrackingScreen(order: order),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Track Order'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isTotal ? Theme.of(context).colorScheme.primary : null,
              fontWeight: isTotal ? FontWeight.bold : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isTotal ? Theme.of(context).colorScheme.primary : null,
              fontWeight: isTotal ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
