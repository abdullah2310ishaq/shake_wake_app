import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Time
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Placed on ${order.orderTime.day}/${order.orderTime.month}/${order.orderTime.year} at ${order.orderTime.hour}:${order.orderTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: Rs. ${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Order Status Tracker
            const Text(
              'Order Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _OrderStatusTracker(status: order.status),
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
                  Text(
                    _getEstimatedTime(order),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF8B4513),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Order Details
            const Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(item.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rs. ${item.price.toStringAsFixed(0)} x ${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Rs. ${item.totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
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
        return order.orderType == OrderType.delivery ? 'On the way' : 'Ready for pickup';
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
    return Column(
      children: [
        Row(
          children: [
            _StatusCircle(
              isActive: true,
              isCompleted: true,
            ),
            _StatusLine(
              isActive: _getStatusValue(status) >= _getStatusValue(OrderStatus.preparing),
            ),
            _StatusCircle(
              isActive: _getStatusValue(status) >= _getStatusValue(OrderStatus.preparing),
              isCompleted: _getStatusValue(status) > _getStatusValue(OrderStatus.preparing),
            ),
            _StatusLine(
              isActive: _getStatusValue(status) >= _getStatusValue(OrderStatus.ready),
            ),
            _StatusCircle(
              isActive: _getStatusValue(status) >= _getStatusValue(OrderStatus.ready),
              isCompleted: _getStatusValue(status) > _getStatusValue(OrderStatus.ready),
            ),
            _StatusLine(
              isActive: _getStatusValue(status) >= _getStatusValue(OrderStatus.delivered),
            ),
            _StatusCircle(
              isActive: _getStatusValue(status) >= _getStatusValue(OrderStatus.delivered),
              isCompleted: true,
              isFinal: true,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatusLabel(
              label: 'Order Placed',
              isActive: true,
              isCompleted: true,
            ),
            _StatusLabel(
              label: 'Preparing',
              isActive: _getStatusValue(status) >= _getStatusValue(OrderStatus.preparing),
              isCompleted: _getStatusValue(status) > _getStatusValue(OrderStatus.preparing),
            ),
            _StatusLabel(
              label: status == OrderStatus.ready ? 'Ready' : 'On the Way',
              isActive: _getStatusValue(status) >= _getStatusValue(OrderStatus.ready),
              isCompleted: _getStatusValue(status) > _getStatusValue(OrderStatus.ready),
            ),
            _StatusLabel(
              label: 'Delivered',
              isActive: _getStatusValue(status) >= _getStatusValue(OrderStatus.delivered),
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
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isActive
            ? isCompleted
                ? const Color(0xFF8B4513)
                : Colors.white
            : Colors.grey.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? const Color(0xFF8B4513) : Colors.grey,
          width: 2,
        ),
      ),
      child: isActive && isCompleted
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }
}

class _StatusLine extends StatelessWidget {
  final bool isActive;

  const _StatusLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        color: isActive ? const Color(0xFF8B4513) : Colors.grey.withOpacity(0.3),
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
    return SizedBox(
      width: 70,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive
              ? isCompleted
                  ? const Color(0xFF8B4513)
                  : Colors.black
              : Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}