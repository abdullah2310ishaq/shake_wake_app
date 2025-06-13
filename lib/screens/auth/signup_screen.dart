import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool success = await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Sign up failed. Please try again.',
              style: TextStyle(color: blackColor), // Text to black
            ),
            backgroundColor: mustardColor, // Background to mustard
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: blackColor, // Set scaffold background to black
      appBar: AppBar(
        backgroundColor: blackColor, // AppBar background to black
        elevation: 0,
        iconTheme: const IconThemeData(color: mustardColor), // Icons to mustard
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.all(screenSize.width * 0.06), // 6% of screen width
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.1), // 10% of screen width
                    child: Image.asset(
                      'assets/logo.jpg',
                      width: screenSize.width * 0.3, // 20% of screen width
                      height: screenSize.width * 0.3, // Keep square
                      fit: BoxFit.fitHeight,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: screenSize.width * 0.2,
                        height: screenSize.width * 0.2,
                        decoration: BoxDecoration(
                          color: mustardColor.withOpacity(
                              0.2), // Fallback background to mustard
                          borderRadius:
                              BorderRadius.circular(screenSize.width * 0.1),
                        ),
                        child: Icon(
                          Icons.local_cafe,
                          size: screenSize.width * 0.1, // 10% of screen width
                          color: mustardColor, // Icon to mustard
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: screenSize.height * 0.03), // 3% of screen height

                // Title
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.07, // 7% of screen width
                    fontWeight: FontWeight.bold,
                    color: mustardColor, // Text to mustard
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                    height: screenSize.height * 0.01), // 1% of screen height

                // Subtitle
                Text(
                  'Join ShakeWake I-8 family',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04, // 4% of screen width
                    color: mustardColor
                        .withOpacity(0.6), // Text to lighter mustard
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                    height: screenSize.height * 0.04), // 4% of screen height

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(
                        color: mustardColor
                            .withOpacity(0.6)), // Label to lighter mustard
                    prefixIcon: Icon(Icons.person,
                        color: mustardColor), // Icon to mustard
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.3)), // Border to mustard
                      borderRadius: BorderRadius.circular(
                          screenSize.width * 0.02), // 2% of screen width
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: mustardColor), // Border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.5)), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                  ),
                  style: TextStyle(color: mustardColor), // Text to mustard
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(
                    height: screenSize.height * 0.02), // 2% of screen height

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: mustardColor
                            .withOpacity(0.6)), // Label to lighter mustard
                    prefixIcon: Icon(Icons.email,
                        color: mustardColor), // Icon to mustard
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.3)), // Border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: mustardColor), // Border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.5)), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                  ),
                  style: TextStyle(color: mustardColor), // Text to mustard
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                    height: screenSize.height * 0.02), // 2% of screen height

                // Phone Field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                        color: mustardColor
                            .withOpacity(0.6)), // Label to lighter mustard
                    prefixIcon: Icon(Icons.phone,
                        color: mustardColor), // Icon to mustard
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.3)), // Border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: mustardColor), // Border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.5)), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                  ),
                  style: TextStyle(color: mustardColor), // Text to mustard
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                    height: screenSize.height * 0.02), // 2% of screen height

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        color: mustardColor
                            .withOpacity(0.6)), // Label to lighter mustard
                    prefixIcon: Icon(Icons.lock,
                        color: mustardColor), // Icon to mustard
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: mustardColor, // Icon to mustard
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.3)), // Border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: mustardColor), // Border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.5)), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                  ),
                  style: TextStyle(color: mustardColor), // Text to mustard
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(
                    height: screenSize.height * 0.02), // 2% of screen height

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                        color: mustardColor
                            .withOpacity(0.6)), // Label to lighter mustard
                    prefixIcon: Icon(Icons.lock_outline,
                        color: mustardColor), // Icon to mustard
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: mustardColor, // Icon to mustard
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.3)), // Border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: mustardColor), // Border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor
                              .withOpacity(0.5)), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: mustardColor), // Error border to mustard
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                    ),
                  ),
                  style: TextStyle(color: mustardColor), // Text to mustard
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(
                    height: screenSize.height * 0.03), // 3% of screen height

                // Sign Up Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mustardColor, // Background to mustard
                        foregroundColor: blackColor, // Text/icon to black
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.height *
                                0.02), // 2% of screen height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              screenSize.width * 0.02), // 2% of screen width
                        ),
                        elevation: 2,
                        textStyle: TextStyle(
                            fontSize:
                                screenSize.width * 0.04), // 4% of screen width
                      ),
                      child: authProvider.isLoading
                          ? CircularProgressIndicator(
                              color: blackColor, // Indicator to black
                              strokeWidth: 2,
                            )
                          : const Text('Sign Up'),
                    );
                  },
                ),
                SizedBox(
                    height: screenSize.height * 0.02), // 2% of screen height

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: mustardColor
                            .withOpacity(0.6), // Text to lighter mustard
                        fontSize:
                            screenSize.width * 0.035, // 3.5% of screen width
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: mustardColor, // Text to mustard
                          fontWeight: FontWeight.bold,
                          fontSize:
                              screenSize.width * 0.035, // 3.5% of screen width
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
