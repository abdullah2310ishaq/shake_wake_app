import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/product_model.dart';

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> uploadProductImage(File imageFile) async {
    try {
      _isLoading = true;
      notifyListeners();

      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = _storage.ref().child('product_images/$fileName');
      
      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask;
      
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      
      _isLoading = false;
      notifyListeners();
      return downloadUrl;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> addProduct({
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    required List<String> ingredients,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final productId = _uuid.v4();
      final product = ProductModel(
        id: productId,
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
        category: category,
        ingredients: ingredients,
        isAvailable: true,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('products')
          .doc(productId)
          .set(product.toMap());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error adding product: $e');
      return false;
    }
  }

  Future<bool> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    required List<String> ingredients,
    required bool isAvailable,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection('products')
          .doc(productId)
          .update({
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'ingredients': ingredients,
        'isAvailable': isAvailable,
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error updating product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection('products')
          .doc(productId)
          .delete();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error deleting product: $e');
      return false;
    }
  }
}