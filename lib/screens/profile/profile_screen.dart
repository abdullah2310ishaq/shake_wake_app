import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/admin_provider.dart';
import '../admin/admin_dashboard_screen.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (_) => AdminProvider(),
      child: Scaffold(
        backgroundColor: blackColor, // Set scaffold background to black
        appBar: AppBar(
          title: const Text('My Profile',
              style: TextStyle(color: mustardColor)), // Title to mustard
          backgroundColor: blackColor, // AppBar background to black
          automaticallyImplyLeading: false,
          iconTheme:
              const IconThemeData(color: mustardColor), // Icons to mustard
        ),
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.user == null) {
              return Center(
                child: Text(
                  'Please login to view your profile',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04, // 4% of screen width
                    color: mustardColor, // Text to mustard
                  ),
                ),
              );
            }

            final user = authProvider.user!;

            return SingleChildScrollView(
              padding:
                  EdgeInsets.all(screenSize.width * 0.04), // 4% of screen width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: screenSize.width * 0.25, // 25% of screen width
                          height: screenSize.width * 0.25, // Keep square
                          decoration: BoxDecoration(
                            color: mustardColor
                                .withOpacity(0.1), // Background to mustard
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: mustardColor, // Border to mustard
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: user.profileImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width *
                                            0.125), // Half of container width
                                    child: Image.network(
                                      user.profileImage!,
                                      width: screenSize.width * 0.25,
                                      height: screenSize.width * 0.25,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Text(
                                        user.name.isNotEmpty
                                            ? user.name[0].toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          fontSize: screenSize.width *
                                              0.1, // 10% of screen width
                                          fontWeight: FontWeight.bold,
                                          color:
                                              mustardColor, // Text to mustard
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      fontSize: screenSize.width *
                                          0.1, // 10% of screen width
                                      fontWeight: FontWeight.bold,
                                      color: mustardColor, // Text to mustard
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                            height: screenSize.height *
                                0.02), // 2% of screen height
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize:
                                screenSize.width * 0.06, // 6% of screen width
                            fontWeight: FontWeight.bold,
                            color: mustardColor, // Text to mustard
                          ),
                        ),
                        SizedBox(
                            height: screenSize.height *
                                0.005), // 0.5% of screen height
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize:
                                screenSize.width * 0.04, // 4% of screen width
                            color: mustardColor
                                .withOpacity(0.6), // Text to lighter mustard
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: screenSize.height * 0.04), // 4% of screen height

                  // Admin Access
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                        screenSize.width * 0.04), // 4% of screen width
                    decoration: BoxDecoration(
                      color: mustardColor
                          .withOpacity(0.1), // Background to mustard
                      borderRadius: BorderRadius.circular(
                          screenSize.width * 0.03), // 3% of screen width
                      border: Border.all(
                          color: mustardColor
                              .withOpacity(0.3)), // Border to mustard
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          size: screenSize.width * 0.08, // 8% of screen width
                          color: mustardColor, // Icon to mustard
                        ),
                        SizedBox(
                            height: screenSize.height *
                                0.01), // 1% of screen height
                        Text(
                          'Admin Panel',
                          style: TextStyle(
                            fontSize: screenSize.width *
                                0.045, // 4.5% of screen width
                            fontWeight: FontWeight.bold,
                            color: mustardColor, // Text to mustard
                          ),
                        ),
                        SizedBox(
                            height: screenSize.height *
                                0.005), // 0.5% of screen height
                        Text(
                          'Manage products and menu items',
                          style: TextStyle(
                            fontSize: screenSize.width *
                                0.035, // 3.5% of screen width
                            color: mustardColor
                                .withOpacity(0.6), // Text to lighter mustard
                          ),
                        ),
                        SizedBox(
                            height: screenSize.height *
                                0.015), // 1.5% of screen height
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminDashboardScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                mustardColor, // Background to mustard
                            foregroundColor: blackColor, // Text/icon to black
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize.height *
                                  0.015, // 1.5% of screen height
                              horizontal:
                                  screenSize.width * 0.04, // 4% of screen width
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  screenSize.width *
                                      0.02), // 2% of screen width
                            ),
                            elevation: 2,
                            textStyle: TextStyle(
                                fontSize: screenSize.width *
                                    0.04), // 4% of screen width
                          ),
                          child: const Text('Open Admin Panel'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: screenSize.height * 0.03), // 3% of screen height

                  // Profile Sections
                  Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize:
                          screenSize.width * 0.045, // 4.5% of screen width
                      fontWeight: FontWeight.bold,
                      color: mustardColor, // Text to mustard
                    ),
                  ),
                  SizedBox(
                      height: screenSize.height * 0.02), // 2% of screen height
                  _ProfileInfoCard(
                    icon: Icons.phone,
                    title: 'Phone Number',
                    value: user.phone,
                  ),
                  SizedBox(
                      height: screenSize.height * 0.02), // 2% of screen height

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.height *
                                0.02), // 2% of screen height
                        side: BorderSide(
                            color: mustardColor), // Border to mustard
                        foregroundColor: mustardColor, // Text/icon to mustard
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              screenSize.width * 0.02), // 2% of screen width
                        ),
                        textStyle: TextStyle(
                            fontSize:
                                screenSize.width * 0.04), // 4% of screen width
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                  SizedBox(
                      height: screenSize.height * 0.03), // 3% of screen height
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.04), // 4% of screen width
      decoration: BoxDecoration(
        color: blackColor, // Background to black
        borderRadius: BorderRadius.circular(
            screenSize.width * 0.03), // 3% of screen width
        boxShadow: [
          BoxShadow(
            color: mustardColor.withOpacity(0.1), // Shadow to mustard
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: mustardColor, // Icon to mustard
            size: screenSize.width * 0.06, // 6% of screen width
          ),
          SizedBox(width: screenSize.width * 0.04), // 4% of screen width
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: screenSize.width * 0.035, // 3.5% of screen width
                  color:
                      mustardColor.withOpacity(0.6), // Text to lighter mustard
                ),
              ),
              SizedBox(
                  height: screenSize.height * 0.005), // 0.5% of screen height
              Text(
                value,
                style: TextStyle(
                  fontSize: screenSize.width * 0.04, // 4% of screen width
                  fontWeight: FontWeight.bold,
                  color: mustardColor, // Text to mustard
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenSize.width * 0.04), // 4% of screen width
        decoration: BoxDecoration(
          color: blackColor, // Background to black
          borderRadius: BorderRadius.circular(
              screenSize.width * 0.03), // 3% of screen width
          boxShadow: [
            BoxShadow(
              color: mustardColor.withOpacity(0.1), // Shadow to mustard
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: mustardColor, // Icon to mustard
              size: screenSize.width * 0.06, // 6% of screen width
            ),
            SizedBox(width: screenSize.width * 0.04), // 4% of screen width
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenSize.width * 0.04, // 4% of screen width
                  fontWeight: FontWeight.w500,
                  color: mustardColor, // Text to mustard
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: screenSize.width * 0.04, // 4% of screen width
              color: mustardColor.withOpacity(0.6), // Icon to lighter mustard
            ),
          ],
        ),
      ),
    );
  }
}
