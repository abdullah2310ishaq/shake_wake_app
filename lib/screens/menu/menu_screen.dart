import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/product_model.dart';
import 'product_detail_screen.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color

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
      backgroundColor: blackColor, // Set scaffold background to black
      appBar: AppBar(
        title: const Text('Menu',
            style: TextStyle(color: mustardColor)), // Text to mustard
        backgroundColor: blackColor, // AppBar background to black
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: mustardColor), // Icons to mustard
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    mustardColor), // Progress indicator to mustard
              ),
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
                    hintStyle: TextStyle(
                        color: mustardColor
                            .withOpacity(0.6)), // Hint text to lighter mustard
                    prefixIcon: const Icon(Icons.search,
                        color: mustardColor), // Icon to mustard
                    filled: true,
                    fillColor: blackColor, // Background to black
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
                        label: Text(category,
                            style: TextStyle(
                                color: isSelected
                                    ? mustardColor
                                    : mustardColor.withOpacity(0.8))),
                        selected: isSelected,
                        onSelected: (selected) {
                          productProvider.setSelectedCategory(category);
                        },
                        selectedColor: mustardColor
                            .withOpacity(0.2), // Selected chip to mustard
                        backgroundColor: blackColor, // Unselected chip to black
                        checkmarkColor: mustardColor, // Checkmark to mustard
                        side: BorderSide(
                            color: mustardColor
                                .withOpacity(0.5)), // Border to mustard
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
                          style: TextStyle(
                              fontSize: 16,
                              color: mustardColor), // Text to mustard
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
          color: blackColor, // Card background to black
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: mustardColor.withOpacity(0.1), // Shadow to mustard
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
                            color: mustardColor, // Name to mustard
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
                            color: mustardColor.withOpacity(
                                0.6), // Description to lighter mustard
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
                                  color: mustardColor, // Price to mustard
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
                                              '${product.name} added to cart',
                                              style: const TextStyle(
                                                  color:
                                                      blackColor)), // Text to black
                                          duration: const Duration(seconds: 1),
                                          backgroundColor:
                                              mustardColor, // SnackBar to mustard
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(padding * 0.5),
                                      decoration: BoxDecoration(
                                        color:
                                            mustardColor, // Button to mustard
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: blackColor, // Icon to black
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
                                          color:
                                              mustardColor, // Button to mustard
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: blackColor, // Icon to black
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
                                          color:
                                              mustardColor, // Quantity to mustard
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
                                          color:
                                              mustardColor, // Button to mustard
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: blackColor, // Icon to black
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
