import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<bool> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required double totalAmount,
    required OrderType orderType,
    required String address,
    DateTime? scheduledTime,
    String? notes,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final orderId = _uuid.v4();
      final order = OrderModel(
        id: orderId,
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        orderType: orderType,
        address: address,
        orderTime: DateTime.now(),
        scheduledTime: scheduledTime,
        status: OrderStatus.placed,
        notes: notes,
      );

      await _firestore
          .collection('orders')
          .doc(orderId)
          .set(order.toMap());

      _orders.insert(0, order);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error placing order: $e');
      return false;
    }
  }

  Future<void> fetchUserOrders(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('orderTime', descending: true)
          .get();

      _orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error fetching orders: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': status.toString().split('.').last});

      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        // Create a new order with updated status
        final updatedOrder = OrderModel(
          id: _orders[orderIndex].id,
          userId: _orders[orderIndex].userId,
          items: _orders[orderIndex].items,
          totalAmount: _orders[orderIndex].totalAmount,
          orderType: _orders[orderIndex].orderType,
          address: _orders[orderIndex].address,
          orderTime: _orders[orderIndex].orderTime,
          scheduledTime: _orders[orderIndex].scheduledTime,
          status: status,
          notes: _orders[orderIndex].notes,
        );
        
        _orders[orderIndex] = updatedOrder;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
}