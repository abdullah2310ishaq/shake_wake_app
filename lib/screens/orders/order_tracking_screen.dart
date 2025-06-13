import 'package:flutter/material.dart';
import '../../models/order_model.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;
    final padding =
        EdgeInsets.all(screenSize.width * 0.04); // 4% of screen width

    return Scaffold(
      backgroundColor: blackColor, // Set scaffold background to black
      appBar: AppBar(
        title: const Text('Track Order',
            style: TextStyle(color: mustardColor)), // Title to mustard
        backgroundColor: blackColor, // AppBar background to black
        iconTheme: const IconThemeData(color: mustardColor), // Icons to mustard
      ),
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID and Time
              Container(
                width: double.infinity,
                padding: padding,
                decoration: BoxDecoration(
                  color: blackColor, // Background to black
                  borderRadius: BorderRadius.circular(
                      screenSize.width * 0.03), // 3% of screen width
                  boxShadow: [
                    BoxShadow(
                      color: mustardColor.withOpacity(0.1), // Shadow to mustard
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id.substring(0, 8).toUpperCase()}',
                      style: TextStyle(
                        fontSize:
                            screenSize.width * 0.045, // 4.5% of screen width
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Text to mustard
                      ),
                    ),
                    SizedBox(
                        height:
                            screenSize.height * 0.01), // 1% of screen height
                    Text(
                      'Placed on ${order.orderTime.day}/${order.orderTime.month}/${order.orderTime.year} at ${order.orderTime.hour}:${order.orderTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize:
                            screenSize.width * 0.035, // 3.5% of screen width
                        color: mustardColor
                            .withOpacity(0.6), // Text to lighter mustard
                      ),
                    ),
                    SizedBox(
                        height:
                            screenSize.height * 0.01), // 1% of screen height
                    Text(
                      'Total: Rs. ${order.totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04, // 4% of screen width
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Text to mustard
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.03), // 3% of screen height

              // Order Status Tracker
              Text(
                'Order Status',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045, // 4.5% of screen width
                  fontWeight: FontWeight.bold,
                  color: mustardColor, // Text to mustard
                ),
              ),
              SizedBox(height: screenSize.height * 0.02), // 2% of screen height
              _OrderStatusTracker(status: order.status),
              SizedBox(height: screenSize.height * 0.03), // 3% of screen height

              // Estimated Time
              Container(
                width: double.infinity,
                padding: padding,
                decoration: BoxDecoration(
                  color: mustardColor.withOpacity(0.1), // Background to mustard
                  borderRadius: BorderRadius.circular(
                      screenSize.width * 0.03), // 3% of screen width
                  border: Border.all(
                    color: mustardColor.withOpacity(0.3), // Border to mustard
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
                        height:
                            screenSize.height * 0.01), // 1% of screen height
                    Text(
                      order.orderType == OrderType.delivery
                          ? 'Estimated Delivery Time'
                          : 'Estimated Pickup Time',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04, // 4% of screen width
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Text to mustard
                      ),
                    ),
                    SizedBox(
                        height:
                            screenSize.height * 0.005), // 0.5% of screen height
                    Text(
                      _getEstimatedTime(order),
                      style: TextStyle(
                        fontSize:
                            screenSize.width * 0.045, // 4.5% of screen width
                        color: mustardColor, // Text to mustard
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.03), // 3% of screen height

              // Order Details
              Text(
                'Order Details',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045, // 4.5% of screen width
                  fontWeight: FontWeight.bold,
                  color: mustardColor, // Text to mustard
                ),
              ),
              SizedBox(height: screenSize.height * 0.02), // 2% of screen height
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: padding,
                  decoration: BoxDecoration(
                    color: blackColor, // Background to black
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.03), // 3% of screen width
                    boxShadow: [
                      BoxShadow(
                        color:
                            mustardColor.withOpacity(0.1), // Shadow to mustard
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView(
                    children: [
                      ...order.items.map((item) => Padding(
                            padding: EdgeInsets.only(
                                bottom: screenSize.height *
                                    0.015), // 1.5% of screen height
                            child: Row(
                              children: [
                                Container(
                                  width: screenSize.width *
                                      0.15, // 15% of screen width
                                  height:
                                      screenSize.width * 0.15, // Keep square
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width *
                                            0.02), // 2% of screen width
                                    image: DecorationImage(
                                      image: NetworkImage(item.imageUrl),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) =>
                                          const AssetImage(
                                              'assets/placeholder.png'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: screenSize.width *
                                        0.03), // 3% of screen width
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                          fontSize: screenSize.width *
                                              0.04, // 4% of screen width
                                          fontWeight: FontWeight.bold,
                                          color:
                                              mustardColor, // Text to mustard
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                          height: screenSize.height *
                                              0.005), // 0.5% of screen height
                                      Text(
                                        'Rs. ${item.price.toStringAsFixed(0)} x ${item.quantity}',
                                        style: TextStyle(
                                          fontSize: screenSize.width *
                                              0.035, // 3.5% of screen width
                                          color: mustardColor.withOpacity(
                                              0.6), // Text to lighter mustard
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Rs. ${item.totalPrice.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: screenSize.width *
                                        0.04, // 4% of screen width
                                    fontWeight: FontWeight.bold,
                                    color: mustardColor, // Text to mustard
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Divider(
                          color: mustardColor
                              .withOpacity(0.3)), // Divider to mustard
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: screenSize.width *
                                  0.045, // 4.5% of screen width
                              fontWeight: FontWeight.bold,
                              color: mustardColor, // Text to mustard
                            ),
                          ),
                          Text(
                            'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: screenSize.width *
                                  0.045, // 4.5% of screen width
                              fontWeight: FontWeight.bold,
                              color: mustardColor, // Text to mustard
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
      ),
    );
  }

  String _getEstimatedTime(OrderModel order) {
    if (order.scheduledTime != null) {
      return 'As scheduled';
    }

    switch (order.status) {
      case OrderStatus.placed:
        return 'Preparing your order';
      case OrderStatus.preparing:
        return '15-20 minutes';
      case OrderStatus.ready:
        return order.orderType == OrderType.delivery
            ? 'On the way'
            : 'Ready for pickup';
      case OrderStatus.delivered:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return '30-45 minutes';
    }
  }
}

class _OrderStatusTracker extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusTracker({required this.status});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            const _StatusCircle(
              isActive: true,
              isCompleted: true,
            ),
            _StatusLine(
              isActive: _getStatusValue(status) >=
                  _getStatusValue(OrderStatus.preparing),
            ),
            _StatusCircle(
              isActive: _getStatusValue(status) >=
                  _getStatusValue(OrderStatus.preparing),
              isCompleted: _getStatusValue(status) >
                  _getStatusValue(OrderStatus.preparing),
            ),
            _StatusLine(
              isActive:
                  _getStatusValue(status) >= _getStatusValue(OrderStatus.ready),
            ),
            _StatusCircle(
              isActive:
                  _getStatusValue(status) >= _getStatusValue(OrderStatus.ready),
              isCompleted:
                  _getStatusValue(status) > _getStatusValue(OrderStatus.ready),
            ),
            _StatusLine(
              isActive: _getStatusValue(status) >=
                  _getStatusValue(OrderStatus.delivered),
            ),
            _StatusCircle(
              isActive: _getStatusValue(status) >=
                  _getStatusValue(OrderStatus.delivered),
              isCompleted: true,
              isFinal: true,
            ),
          ],
        ),
        SizedBox(height: screenSize.height * 0.01), // 1% of screen height
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _StatusLabel(
              label: 'Order Placed',
              isActive: true,
              isCompleted: true,
            ),
            _StatusLabel(
              label: 'Preparing',
              isActive: _getStatusValue(status) >=
                  _getStatusValue(OrderStatus.preparing),
              isCompleted: _getStatusValue(status) >
                  _getStatusValue(OrderStatus.preparing),
            ),
            _StatusLabel(
              label: status == OrderStatus.ready ? 'Ready' : 'On the Way',
              isActive:
                  _getStatusValue(status) >= _getStatusValue(OrderStatus.ready),
              isCompleted:
                  _getStatusValue(status) > _getStatusValue(OrderStatus.ready),
            ),
            _StatusLabel(
              label: 'Delivered',
              isActive: _getStatusValue(status) >=
                  _getStatusValue(OrderStatus.delivered),
              isCompleted: true,
              isFinal: true,
            ),
          ],
        ),
      ],
    );
  }

  int _getStatusValue(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.ready:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return 0;
      default:
        return 0;
    }
  }
}

class _StatusCircle extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final bool isFinal;

  const _StatusCircle({
    required this.isActive,
    required this.isCompleted,
    this.isFinal = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width * 0.08, // 8% of screen width
      height: screenSize.width * 0.08, // Keep square
      decoration: BoxDecoration(
        color: isActive
            ? isCompleted
                ? mustardColor // Active/completed to mustard
                : blackColor // Inactive background to black
            : mustardColor.withOpacity(0.3), // Inactive to lighter mustard
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive
              ? mustardColor
              : mustardColor.withOpacity(0.3), // Border to mustard
          width: 2,
        ),
      ),
      child: isActive && isCompleted
          ? Icon(
              Icons.check,
              color: blackColor, // Check icon to black
              size: screenSize.width * 0.04, // 4% of screen width
            )
          : null,
    );
  }
}

class _StatusLine extends StatelessWidget {
  final bool isActive;

  const _StatusLine({required this.isActive});

  @override
  Widget build(context) {
    return Expanded(
      child: Container(
        height: 3,
        color: isActive
            ? mustardColor
            : mustardColor.withOpacity(0.3), // Line to mustard
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isCompleted;
  final bool isFinal;

  const _StatusLabel({
    required this.label,
    required this.isActive,
    required this.isCompleted,
    this.isFinal = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width * 0.18, // 18% of screen width
      child: Text(
        label,
        style: TextStyle(
          fontSize: screenSize.width * 0.03, // 3% of screen width
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive
              ? isCompleted
                  ? mustardColor // Completed to mustard
                  : mustardColor // Active to mustard
              : mustardColor.withOpacity(0.6), // Inactive to lighter mustard
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
