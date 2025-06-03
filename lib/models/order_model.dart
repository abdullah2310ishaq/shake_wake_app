import 'cart_item_model.dart';

enum OrderStatus { placed, preparing, ready, delivered, cancelled }
enum OrderType { delivery, pickup }

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final OrderType orderType;
  final String address;
  final DateTime orderTime;
  final DateTime? scheduledTime;
  final OrderStatus status;
  final String? notes;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.orderType,
    required this.address,
    required this.orderTime,
    this.scheduledTime,
    required this.status,
    this.notes,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List)
          .map((item) => CartItemModel.fromMap(item))
          .toList(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      orderType: OrderType.values.firstWhere(
        (e) => e.toString() == 'OrderType.${map['orderType']}',
        orElse: () => OrderType.delivery,
      ),
      address: map['address'] ?? '',
      orderTime: DateTime.parse(map['orderTime']),
      scheduledTime: map['scheduledTime'] != null 
          ? DateTime.parse(map['scheduledTime']) 
          : null,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${map['status']}',
        orElse: () => OrderStatus.placed,
      ),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'orderType': orderType.toString().split('.').last,
      'address': address,
      'orderTime': orderTime.toIso8601String(),
      'scheduledTime': scheduledTime?.toIso8601String(),
      'status': status.toString().split('.').last,
      'notes': notes,
    };
  }
}