import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  List<ProductModel> get products => _products;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  List<ProductModel> get filteredProducts {
    if (_selectedCategory == 'All') {
      return _products;
    }
    return _products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot = await _firestore.collection('products').get();

      _products = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final product = ProductModel.fromMap(data);

          // Only add available products
          if (product.isAvailable) {
            _products.add(product);
          }
        } catch (e) {
          print('Error parsing product ${doc.id}: $e');
          // Skip this product and continue
          continue;
        }
      }

      // Sort by creation date
      _products.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Extract unique categories
      Set<String> categorySet = {'All'};
      for (var product in _products) {
        if (product.category.isNotEmpty) {
          categorySet.add(product.category);
        }
      }
      _categories = categorySet.toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error fetching products: $e');
    }
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return filteredProducts;

    return filteredProducts.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
