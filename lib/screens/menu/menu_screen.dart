import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/product_model.dart';
import 'product_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // Category Filter
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: productProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = productProvider.categories[index];
                    final isSelected =
                        category == productProvider.selectedCategory;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          productProvider.setSelectedCategory(category);
                        },
                        selectedColor: const Color(0xFF8B4513).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF8B4513),
                      ),
                    );
                  },
                ),
              ),

              // Products Grid
              Expanded(
                child: Builder(
                  builder: (context) {
                    List<ProductModel> products = _searchQuery.isEmpty
                        ? productProvider.filteredProducts
                        : productProvider.searchProducts(_searchQuery);

                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _ProductCard(product: product);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen =
        screenSize.width < 360; // Define small screen threshold

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate responsive font sizes and padding
            final fontSizeTitle =
                constraints.maxWidth * 0.1; // ~10% of card width
            final fontSizeDescription = constraints.maxWidth * 0.07;
            final fontSizePrice = constraints.maxWidth * 0.09;
            final iconSize = constraints.maxWidth * 0.1;
            final padding = constraints.maxWidth * 0.05;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit
                            .cover, // Use BoxFit.cover to maintain aspect ratio
                        onError: (exception, stackTrace) => const AssetImage(
                            'assets/placeholder.png'), // Fallback image
                      ),
                    ),
                  ),
                ),

                // Product Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: fontSizeTitle.clamp(
                                12.0, 16.0), // Clamp font size for readability
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                        SizedBox(height: padding * 0.5),

                        // Product Description
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: fontSizeDescription.clamp(10.0, 12.0),
                            color: Colors.grey,
                          ),
                          maxLines: isSmallScreen
                              ? 1
                              : 2, // Reduce max lines on small screens
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),

                        // Price and Cart Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Flexible(
                              child: Text(
                                'Rs. ${product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: fontSizePrice.clamp(12.0, 16.0),
                                  color: const Color(0xFF8B4513),
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Cart Controls
                            Consumer<CartProvider>(
                              builder: (context, cart, child) {
                                final quantity = cart.getQuantity(product.id);

                                if (quantity == 0) {
                                  return GestureDetector(
                                    onTap: () {
                                      cart.addItem(product);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${product.name} added to cart'),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(padding * 0.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8B4513),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: iconSize.clamp(12.0, 16.0),
                                      ),
                                    ),
                                  );
                                }

                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Decrease Quantity
                                    GestureDetector(
                                      onTap: () {
                                        cart.updateQuantity(
                                            product.id, quantity - 1);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(padding * 0.4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8B4513),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: iconSize.clamp(10.0, 12.0),
                                        ),
                                      ),
                                    ),

                                    // Quantity Display
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: padding * 0.5),
                                      child: Text(
                                        quantity.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSizeDescription.clamp(
                                              10.0, 14.0),
                                        ),
                                      ),
                                    ),

                                    // Increase Quantity
                                    GestureDetector(
                                      onTap: () {
                                        cart.updateQuantity(
                                            product.id, quantity + 1);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(padding * 0.4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8B4513),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: iconSize.clamp(10.0, 12.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
