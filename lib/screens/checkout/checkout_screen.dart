import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../orders/order_confirmation_screen.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  OrderType _selectedOrderType = OrderType.delivery;
  DateTime? _selectedTime;
  bool _isASAP = true;
  String _selectedCity = 'Islamabad'; // Default city for dropdown

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (date != null && mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      final cart = Provider.of<CartProvider>(context, listen: false);
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      if (auth.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to place an order'),
            backgroundColor: mustardColor, // SnackBar to mustard
          ),
        );
        return;
      }

      // Combine city and address for delivery
      final address = _selectedOrderType == OrderType.delivery
          ? '$_selectedCity, ${_addressController.text.trim()}'
          : 'ShakeWake I-8, Islamabad';

      final success = await orderProvider.placeOrder(
        userId: auth.user!.id,
        items: cart.items,
        totalAmount: cart.totalAmount,
        orderType: _selectedOrderType,
        address: address,
        scheduledTime: _isASAP ? null : _selectedTime,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (success && mounted) {
        cart.clearCart();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(
              order: orderProvider.orders.first,
            ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to place order. Please try again.'),
            backgroundColor: mustardColor, // SnackBar to mustard
            // Text to black
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor, // Set scaffold background to black
      appBar: AppBar(
        title: const Text('Checkout',
            style: TextStyle(color: mustardColor)), // Title to mustard
        backgroundColor: blackColor, // AppBar background to black
        iconTheme: const IconThemeData(color: mustardColor), // Icons to mustard
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Type Selection
                    const Text(
                      'Order Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Title to mustard
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<OrderType>(
                            title: const Text('Delivery',
                                style: TextStyle(
                                    color: mustardColor)), // Text to mustard
                            subtitle: const Text('Get it delivered',
                                style: TextStyle(
                                    color: mustardColor)), // Text to mustard
                            value: OrderType.delivery,
                            groupValue: _selectedOrderType,
                            onChanged: (value) {
                              setState(() {
                                _selectedOrderType = value!;
                              });
                            },
                            activeColor:
                                mustardColor, // Radio button to mustard
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<OrderType>(
                            title: const Text('Pickup',
                                style: TextStyle(
                                    color: mustardColor)), // Text to mustard
                            subtitle: const Text('Collect from store',
                                style: TextStyle(
                                    color: mustardColor)), // Text to mustard
                            value: OrderType.pickup,
                            groupValue: _selectedOrderType,
                            onChanged: (value) {
                              setState(() {
                                _selectedOrderType = value!;
                              });
                            },
                            activeColor:
                                mustardColor, // Radio button to mustard
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Address (for delivery only)
                    if (_selectedOrderType == OrderType.delivery) ...[
                      const Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mustardColor, // Title to mustard
                        ),
                      ),
                      const SizedBox(height: 12),
                      // City Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCity,
                        decoration: InputDecoration(
                          labelText: 'Select City',
                          labelStyle: TextStyle(
                              color: mustardColor
                                  .withOpacity(0.6)), // Label to mustard
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: mustardColor), // Border to mustard
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: mustardColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: mustardColor, width: 2),
                          ),
                        ),
                        dropdownColor:
                            blackColor, // Dropdown background to black
                        style: const TextStyle(
                            color: mustardColor), // Text to mustard
                        items: const [
                          DropdownMenuItem(
                              value: 'Islamabad', child: Text('Islamabad')),
                          DropdownMenuItem(
                              value: 'Rawalpindi', child: Text('Rawalpindi')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a city';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter your complete address...',
                          hintStyle: TextStyle(
                              color: mustardColor
                                  .withOpacity(0.6)), // Hint to mustard
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: mustardColor), // Border to mustard
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: mustardColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: mustardColor, width: 2),
                          ),
                        ),
                        style: const TextStyle(
                            color: mustardColor), // Input text to mustard
                        validator: (value) {
                          if (_selectedOrderType == OrderType.delivery &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Please enter delivery address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Store Address (for pickup)
                    if (_selectedOrderType == OrderType.pickup) ...[
                      const Text(
                        'Pickup Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mustardColor, // Title to mustard
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: mustardColor
                              .withOpacity(0.1), // Background to mustard
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: mustardColor
                                .withOpacity(0.3), // Border to mustard
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ShakeWake I-8',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: mustardColor, // Text to mustard
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sector I-8, Islamabad',
                              style: TextStyle(
                                  color: mustardColor.withOpacity(
                                      0.6)), // Text to lighter mustard
                            ),
                            Text(
                              'Open: 9:00 AM - 11:00 PM',
                              style: TextStyle(
                                  color: mustardColor.withOpacity(
                                      0.6)), // Text to lighter mustard
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Time Selection
                    const Text(
                      'When do you want it?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Title to mustard
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('ASAP',
                                style: TextStyle(
                                    color: mustardColor)), // Text to mustard
                            subtitle: const Text('30-45 mins',
                                style: TextStyle(
                                    color: mustardColor)), // Text to mustard
                            value: true,
                            groupValue: _isASAP,
                            onChanged: (value) {
                              setState(() {
                                _isASAP = value!;
                                _selectedTime = null;
                              });
                            },
                            activeColor:
                                mustardColor, // Radio button to mustard
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Schedule',
                                style: TextStyle(
                                    color: mustardColor)), // Text to mustard
                            subtitle: const Text('Pick a time',
                                style: TextStyle(
                                    color: mustardColor)), // Text to mustard
                            value: false,
                            groupValue: _isASAP,
                            onChanged: (value) {
                              setState(() {
                                _isASAP = value!;
                              });
                            },
                            activeColor:
                                mustardColor, // Radio button to mustard
                          ),
                        ),
                      ],
                    ),

                    if (!_isASAP) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _selectTime,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: mustardColor), // Border to mustard
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedTime == null
                                ? 'Select Date & Time'
                                : 'Selected: ${_selectedTime!.day}/${_selectedTime!.month}/${_selectedTime!.year} at ${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: _selectedTime == null
                                  ? mustardColor.withOpacity(0.6)
                                  : mustardColor, // Text to mustard
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Special Instructions
                    const Text(
                      'Special Instructions (Optional)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Title to mustard
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Any special requests or notes...',
                        hintStyle: TextStyle(
                            color: mustardColor
                                .withOpacity(0.6)), // Hint to mustard
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: mustardColor), // Border to mustard
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: mustardColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: mustardColor, width: 2),
                        ),
                      ),
                      style: const TextStyle(
                          color: mustardColor), // Input text to mustard
                    ),
                    const SizedBox(height: 24),

                    // Payment Method
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mustardColor, // Title to mustard
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: mustardColor
                            .withOpacity(0.1), // Background to mustard
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: mustardColor), // Border to mustard
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.money,
                              color: mustardColor), // Icon to mustard
                          SizedBox(width: 12),
                          Text(
                            'Cash on Delivery (COD)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: mustardColor, // Text to mustard
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Order Summary & Place Order
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: blackColor, // Background to black
                boxShadow: [
                  BoxShadow(
                    color: mustardColor.withOpacity(0.2), // Shadow to mustard
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: mustardColor, // Text to mustard
                            ),
                          ),
                          Text(
                            'Rs. ${cart.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: mustardColor, // Text to mustard
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Consumer<OrderProvider>(
                        builder: (context, orderProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  orderProvider.isLoading ? null : _placeOrder,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    mustardColor, // Button to mustard
                                foregroundColor:
                                    blackColor, // Text/icon to black
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: orderProvider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: blackColor) // Indicator to black
                                  : const Text(
                                      'Place Order',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
