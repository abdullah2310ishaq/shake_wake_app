import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/order_model.dart';
import 'order_tracking_screen.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      await orderProvider.fetchUserOrders(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: blackColor, // Set scaffold background to black
      appBar: AppBar(
        title: const Text('Order History',
            style: TextStyle(color: mustardColor)), // Title to mustard
        backgroundColor: blackColor, // AppBar background to black
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: mustardColor), // Icons to mustard
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.user == null) {
            return Center(
              child: Text(
                'Please login to view your orders',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04, // 4% of screen width
                  color: mustardColor, // Text to mustard
                ),
              ),
            );
          }

          return Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              if (orderProvider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: mustardColor, // Indicator to mustard
                  ),
                );
              }

              if (orderProvider.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: screenSize.width * 0.2, // 20% of screen width
                        color: mustardColor
                            .withOpacity(0.6), // Icon to lighter mustard
                      ),
                      SizedBox(
                          height:
                              screenSize.height * 0.02), // 2% of screen height
                      Text(
                        'No orders yet',
                        style: TextStyle(
                          fontSize:
                              screenSize.width * 0.05, // 5% of screen width
                          fontWeight: FontWeight.bold,
                          color: mustardColor
                              .withOpacity(0.6), // Text to lighter mustard
                        ),
                      ),
                      SizedBox(
                          height:
                              screenSize.height * 0.01), // 1% of screen height
                      Text(
                        'Your order history will appear here',
                        style: TextStyle(
                          fontSize:
                              screenSize.width * 0.04, // 4% of screen width
                          color: mustardColor
                              .withOpacity(0.6), // Text to lighter mustard
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: mustardColor, // Indicator to mustard
                backgroundColor: blackColor, // Background to black
                onRefresh: _loadOrders,
                child: ListView.builder(
                  padding: EdgeInsets.all(
                      screenSize.width * 0.04), // 4% of screen width
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderProvider.orders[index];
                    return _OrderCard(order: order);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;
    final padding =
        EdgeInsets.all(screenSize.width * 0.04); // 4% of screen width

    return Container(
      margin: EdgeInsets.only(
          bottom: screenSize.height * 0.02), // 2% of screen height
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
        children: [
          // Order Header
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: mustardColor.withOpacity(0.1), // Background to mustard
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                      screenSize.width * 0.03)), // 3% of screen width
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id.substring(0, 8).toUpperCase()}',
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
                      '${order.orderTime.day}/${order.orderTime.month}/${order.orderTime.year}',
                      style: TextStyle(
                        fontSize:
                            screenSize.width * 0.035, // 3.5% of screen width
                        color: mustardColor
                            .withOpacity(0.6), // Text to lighter mustard
                      ),
                    ),
                  ],
                ),
                _StatusBadge(status: order.status),
              ],
            ),
          ),

          // Order Items
          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Items Summary
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                      style: TextStyle(
                        fontSize:
                            screenSize.width * 0.035, // 3.5% of screen width
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Text to mustard
                      ),
                    ),
                    SizedBox(
                        height:
                            screenSize.height * 0.01), // 1% of screen height
                    Text(
                      order.items
                          .map((item) => '${item.name} x${item.quantity}')
                          .join(', '),
                      style: TextStyle(
                        fontSize:
                            screenSize.width * 0.035, // 3.5% of screen width
                        color: mustardColor
                            .withOpacity(0.6), // Text to lighter mustard
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                    height: screenSize.height * 0.02), // 2% of screen height

                // Order Type and Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          order.orderType == OrderType.delivery
                              ? Icons.delivery_dining
                              : Icons.store,
                          size:
                              screenSize.width * 0.045, // 4.5% of screen width
                          color: mustardColor, // Icon to mustard
                        ),
                        SizedBox(
                            width:
                                screenSize.width * 0.01), // 1% of screen width
                        Text(
                          order.orderType == OrderType.delivery
                              ? 'Delivery'
                              : 'Pickup',
                          style: TextStyle(
                            fontSize: screenSize.width *
                                0.035, // 3.5% of screen width
                            color: mustardColor, // Text to mustard
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04, // 4% of screen width
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Text to mustard
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: screenSize.height * 0.02), // 2% of screen height

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderTrackingScreen(order: order),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: mustardColor), // Border to mustard
                          foregroundColor: mustardColor, // Text/icon to mustard
                          padding: EdgeInsets.symmetric(
                              vertical: screenSize.height *
                                  0.015), // 1.5% of screen height
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                screenSize.width * 0.02), // 2% of screen width
                          ),
                          textStyle: TextStyle(
                              fontSize: screenSize.width *
                                  0.035), // 3.5% of screen width
                        ),
                        child: const Text('Track Order'),
                      ),
                    ),
                    SizedBox(
                        width: screenSize.width * 0.03), // 3% of screen width
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _reorderItems(context, order);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              mustardColor, // Background to mustard
                          foregroundColor: blackColor, // Text/icon to black
                          padding: EdgeInsets.symmetric(
                              vertical: screenSize.height *
                                  0.015), // 1.5% of screen height
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                screenSize.width * 0.02), // 2% of screen width
                          ),
                          elevation: 2,
                          textStyle: TextStyle(
                              fontSize: screenSize.width *
                                  0.035), // 3.5% of screen width
                        ),
                        child: const Text('Reorder'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _reorderItems(BuildContext context, OrderModel order) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Clear current cart
    cartProvider.clearCart();

    // Add all items from the order
    for (var item in order.items) {
      cartProvider.addItem(
        // Create a temporary product model from cart item
        ProductModel(
          id: item.productId,
          name: item.name,
          description: '',
          price: item.price,
          imageUrl: item.imageUrl,
          category: '',
          ingredients: [],
          isAvailable: true,
          createdAt: DateTime.now(),
        ),
      );

      // Update quantity if more than 1
      if (item.quantity > 1) {
        cartProvider.updateQuantity(item.productId, item.quantity);
      }
    }

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Items added to cart',
            style: TextStyle(color: blackColor)), // Text to black
        duration: const Duration(seconds: 2),
        backgroundColor: mustardColor, // Background to mustard
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Switch to cart tab
    DefaultTabController.of(context).animateTo(2);
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    // Define mustard-based colors for different statuses
    Color color;
    String text;

    switch (status) {
      case OrderStatus.placed:
        color = mustardColor; // Full mustard for placed
        text = 'Placed';
        break;
      case OrderStatus.preparing:
        color = mustardColor
            .withOpacity(0.8); // Slightly muted mustard for preparing
        text = 'Preparing';
        break;
      case OrderStatus.ready:
        color = mustardColor.withOpacity(0.6); // More muted mustard for ready
        text = 'Ready';
        break;
      case OrderStatus.delivered:
        color = mustardColor.withOpacity(0.4); // Light mustard for delivered
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        color =
            mustardColor.withOpacity(0.2); // Very light mustard for cancelled
        text = 'Cancelled';
        break;
      default:
        color = mustardColor.withOpacity(0.3); // Fallback mustard shade
        text = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.03, // 3% of screen width
        vertical: screenSize.height * 0.005, // 0.5% of screen height
      ),
      decoration: BoxDecoration(
        color: color
            .withOpacity(0.1), // Background to status-specific mustard shade
        borderRadius: BorderRadius.circular(
            screenSize.width * 0.04), // 4% of screen width
        border:
            Border.all(color: color), // Border to status-specific mustard shade
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenSize.width * 0.03, // 3% of screen width
          fontWeight: FontWeight.bold,
          color: color, // Text to status-specific mustard shade
        ),
      ),
    );
  }
}
