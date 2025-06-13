import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../home/home_screen.dart';
import 'order_tracking_screen.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color

class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;
    final padding =
        EdgeInsets.all(screenSize.width * 0.04); // 4% of screen width
    final buttonPadding = EdgeInsets.symmetric(
      vertical: screenSize.height * 0.02, // 2% of screen height
      horizontal: screenSize.width * 0.04, // 4% of screen width
    );

    return Scaffold(
      backgroundColor: blackColor, // Set scaffold background to black
      appBar: AppBar(
        title: const Text('Order Confirmed',
            style: TextStyle(color: mustardColor)), // Title to mustard
        backgroundColor: blackColor, // AppBar background to black
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: mustardColor), // Icons to mustard
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Success Icon
                    Container(
                      width: screenSize.width * 0.3, // 30% of screen width
                      height:
                          screenSize.width * 0.3, // Keep square aspect ratio
                      decoration: BoxDecoration(
                        color: mustardColor
                            .withOpacity(0.1), // Background to mustard
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: screenSize.width * 0.2, // 20% of screen width
                        color: mustardColor, // Icon to mustard
                      ),
                    ),
                    SizedBox(
                        height:
                            screenSize.height * 0.03), // 3% of screen height

                    Text(
                      'Order Placed Successfully!',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.06, // 6% of screen width
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Text to mustard
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                        height:
                            screenSize.height * 0.01), // 1% of screen height

                    Text(
                      'Order ID: ${order.id.substring(0, 8).toUpperCase()}',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04, // 4% of screen width
                        color: mustardColor
                            .withOpacity(0.6), // Text to lighter mustard
                      ),
                    ),
                    SizedBox(
                        height:
                            screenSize.height * 0.04), // 4% of screen height

                    // Order Details Card
                    Card(
                      color: blackColor, // Card background to black
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            screenSize.width * 0.04), // 4% of screen width
                      ),
                      elevation: 2,
                      shadowColor:
                          mustardColor.withOpacity(0.2), // Shadow to mustard
                      child: Padding(
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Details',
                              style: TextStyle(
                                fontSize: screenSize.width *
                                    0.045, // 4.5% of screen width
                                fontWeight: FontWeight.bold,
                                color: mustardColor, // Title to mustard
                              ),
                            ),
                            SizedBox(
                                height: screenSize.height *
                                    0.02), // 2% of screen height
                            _DetailRow(
                              label: 'Order Type',
                              value: order.orderType == OrderType.delivery
                                  ? 'Delivery'
                                  : 'Pickup',
                              fontSize:
                                  screenSize.width * 0.04, // 4% of screen width
                            ),
                            _DetailRow(
                              label: 'Address',
                              value: order
                                  .address, // Display full address directly
                              fontSize:
                                  screenSize.width * 0.04, // 4% of screen width
                            ),
                            _DetailRow(
                              label: 'Order Time',
                              value:
                                  '${order.orderTime.day}/${order.orderTime.month}/${order.orderTime.year} at ${order.orderTime.hour}:${order.orderTime.minute.toString().padLeft(2, '0')}',
                              fontSize:
                                  screenSize.width * 0.04, // 4% of screen width
                            ),
                            if (order.scheduledTime != null)
                              _DetailRow(
                                label: 'Scheduled For',
                                value:
                                    '${order.scheduledTime!.day}/${order.scheduledTime!.month}/${order.scheduledTime!.year} at ${order.scheduledTime!.hour}:${order.scheduledTime!.minute.toString().padLeft(2, '0')}',
                                fontSize: screenSize.width *
                                    0.04, // 4% of screen width
                              ),
                            _DetailRow(
                              label: 'Payment Method',
                              value: 'Cash on Delivery',
                              fontSize:
                                  screenSize.width * 0.04, // 4% of screen width
                            ),
                            Divider(
                                color: mustardColor
                                    .withOpacity(0.3)), // Divider to mustard
                            _DetailRow(
                              label: 'Total Amount',
                              value:
                                  'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                              isTotal: true,
                              fontSize:
                                  screenSize.width * 0.04, // 4% of screen width
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            screenSize.height * 0.03), // 3% of screen height

                    // Items List
                    Card(
                      color: blackColor, // Card background to black
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            screenSize.width * 0.04), // 4% of screen width
                      ),
                      elevation: 2,
                      shadowColor:
                          mustardColor.withOpacity(0.2), // Shadow to mustard
                      child: Padding(
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Items Ordered',
                              style: TextStyle(
                                fontSize: screenSize.width *
                                    0.045, // 4.5% of screen width
                                fontWeight: FontWeight.bold,
                                color: mustardColor, // Title to mustard
                              ),
                            ),
                            SizedBox(
                                height: screenSize.height *
                                    0.02), // 2% of screen height
                            ...order.items.map((item) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: screenSize.height *
                                          0.01), // 1% of screen height
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${item.name} x${item.quantity}',
                                          style: TextStyle(
                                            fontSize: screenSize.width *
                                                0.04, // 4% of screen width
                                            color:
                                                mustardColor, // Text to mustard
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        'Rs. ${item.totalPrice.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: screenSize.width *
                                              0.04, // 4% of screen width
                                          fontWeight: FontWeight.w600,
                                          color:
                                              mustardColor, // Text to mustard
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            screenSize.height * 0.03), // 3% of screen height

                    // Estimated Time
                    Container(
                      width: double.infinity,
                      padding: padding,
                      decoration: BoxDecoration(
                        color: mustardColor
                            .withOpacity(0.1), // Background to mustard
                        borderRadius: BorderRadius.circular(
                            screenSize.width * 0.03), // 3% of screen width
                        border: Border.all(
                          color: mustardColor
                              .withOpacity(0.3), // Border to mustard
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: screenSize.width * 0.08, // 8% of screen width
                            color: mustardColor, // Icon to mustard
                          ),
                          SizedBox(
                              height: screenSize.height *
                                  0.01), // 1% of screen height
                          Text(
                            order.orderType == OrderType.delivery
                                ? 'Estimated Delivery Time'
                                : 'Estimated Pickup Time',
                            style: TextStyle(
                              fontSize:
                                  screenSize.width * 0.04, // 4% of screen width
                              fontWeight: FontWeight.bold,
                              color: mustardColor, // Text to mustard
                            ),
                          ),
                          SizedBox(
                              height: screenSize.height *
                                  0.005), // 0.5% of screen height
                          Text(
                            '30-45 minutes',
                            style: TextStyle(
                              fontSize: screenSize.width *
                                  0.035, // 3.5% of screen width
                              color: mustardColor
                                  .withOpacity(0.6), // Text to lighter mustard
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
            Padding(
              padding: padding,
              child: Row(
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
                        backgroundColor: mustardColor, // Button to mustard
                        foregroundColor: blackColor, // Text/icon to black
                        padding: buttonPadding,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              screenSize.width * 0.03), // 3% of screen width
                        ),
                        elevation: 2,
                        textStyle: TextStyle(
                            fontSize:
                                screenSize.width * 0.04), // 4% of screen width
                      ),
                      child: const Text('Back to Home'),
                    ),
                  ),
                  SizedBox(
                      width: screenSize.width * 0.04), // 4% of screen width
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
                        backgroundColor: mustardColor, // Button to mustard
                        foregroundColor: blackColor, // Text/icon to black
                        padding: buttonPadding,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              screenSize.width * 0.03), // 3% of screen width
                        ),
                        elevation: 2,
                        textStyle: TextStyle(
                            fontSize:
                                screenSize.width * 0.04), // 4% of screen width
                      ),
                      child: const Text('Track Order'),
                    ),
                  ),
                ],
              ),
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
  final double fontSize;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.fontSize,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: fontSize * 0.2), // Scale padding with font size
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: isTotal
                    ? mustardColor
                    : mustardColor.withOpacity(0.8), // Text to mustard
                fontWeight: isTotal ? FontWeight.bold : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
                color: isTotal
                    ? mustardColor
                    : mustardColor.withOpacity(0.8), // Text to mustard
                fontWeight: isTotal ? FontWeight.bold : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
