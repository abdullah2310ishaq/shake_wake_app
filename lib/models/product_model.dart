class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> ingredients;
  final bool isAvailable;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.ingredients,
    required this.isAvailable,
    required this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      ingredients: _parseIngredients(map['ingredients']), // Safe parsing
      isAvailable: map['isAvailable'] ?? true,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  // Safe ingredients parsing
  static List<String> _parseIngredients(dynamic ingredients) {
    if (ingredients == null) return [];
    
    if (ingredients is List) {
      return ingredients.map((e) => e.toString()).toList();
    } else if (ingredients is String) {
      // If it's a string, split by comma
      return ingredients.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    
    return [];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'ingredients': ingredients, // This will be saved as array
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}