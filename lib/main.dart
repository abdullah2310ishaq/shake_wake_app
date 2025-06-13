import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shake_wake_app/providers/admin_provider.dart';
import 'services/firebase_service.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/cart/cart_screen.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color
const Color darkGreyColor = Color(0xFF1A1A1A); // Dark grey for cards
const Color lightGreyColor = Color(0xFF2A2A2A); // Light grey for containers

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'ShakeWake I-8',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: mustardColor,
          scaffoldBackgroundColor: blackColor,
          colorScheme: const ColorScheme.dark(
            primary: mustardColor,
            secondary: mustardColor,
            surface: darkGreyColor,
            background: blackColor,
            onPrimary: blackColor,
            onSecondary: blackColor,
            onSurface: mustardColor,
            onBackground: mustardColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: blackColor,
            foregroundColor: mustardColor,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: darkGreyColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: mustardColor,
              foregroundColor: blackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: mustardColor,
            ),
          ),
          iconTheme: const IconThemeData(
            color: mustardColor,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: mustardColor),
            bodyMedium: TextStyle(color: mustardColor),
            titleLarge: TextStyle(color: mustardColor),
            titleMedium: TextStyle(color: mustardColor),
            labelLarge: TextStyle(color: blackColor),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: darkGreyColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: mustardColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: mustardColor.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: mustardColor),
            ),
            labelStyle: const TextStyle(color: mustardColor),
            hintStyle: TextStyle(color: mustardColor.withOpacity(0.5)),
          ),
          dividerTheme: const DividerThemeData(
            color: mustardColor,
            thickness: 0.5,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: darkGreyColor,
            contentTextStyle: const TextStyle(color: mustardColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/cart': (context) => const CartScreen(),
        },
      ),
    );
  }
}
