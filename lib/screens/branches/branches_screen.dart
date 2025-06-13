import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: blackColor, // Set scaffold background to black
      appBar: AppBar(
        title: const Text(
          'Our Branches',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: mustardColor, // Text to mustard
          ),
        ),
        centerTitle: true,
        backgroundColor: blackColor, // AppBar background to black
        iconTheme: const IconThemeData(color: mustardColor), // Icons to mustard
      ),
      body: ListView(
        padding: EdgeInsets.all(screenSize.width * 0.04), // 4% of screen width
        children: [
          _buildBranchCard(
            context,
            'ShakeWake I-8 Markaz',
            'Shop #123, I-8 Markaz, Islamabad',
            '+92 300 1234567',
            'Mon-Sun: 10:00 AM - 12:00 AM',
            'https://maps.google.com/?q=I-8+Markaz+Islamabad',
          ),
          SizedBox(height: screenSize.height * 0.02), // 2% of screen height
          _buildBranchCard(
            context,
            'ShakeWake F-7 Markaz',
            'Shop #45, F-7 Markaz, Islamabad',
            '+92 300 2345678',
            'Mon-Sun: 10:00 AM - 12:00 AM',
            'https://maps.google.com/?q=F-7+Markaz+Islamabad',
          ),
          SizedBox(height: screenSize.height * 0.02), // 2% of screen height
          _buildBranchCard(
            context,
            'ShakeWake Blue Area',
            'Shop #67, Blue Area, Islamabad',
            '+92 300 3456789',
            'Mon-Sun: 10:00 AM - 12:00 AM',
            'https://maps.google.com/?q=Blue+Area+Islamabad',
          ),
          SizedBox(height: screenSize.height * 0.02), // 2% of screen height
          _buildBranchCard(
            context,
            'ShakeWake Bahria Town',
            'Shop #89, Bahria Town, Islamabad',
            '+92 300 4567890',
            'Mon-Sun: 10:00 AM - 12:00 AM',
            'https://maps.google.com/?q=Bahria+Town+Islamabad',
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCard(
    BuildContext context,
    String name,
    String address,
    String phone,
    String hours,
    String mapUrl,
  ) {
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            screenSize.width * 0.04), // 4% of screen width
      ),
      child: Container(
        padding: EdgeInsets.all(screenSize.width * 0.04), // 4% of screen width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              screenSize.width * 0.04), // 4% of screen width
          gradient: LinearGradient(
            colors: [
              mustardColor,
              mustardColor.withOpacity(0.7)
            ], // Mustard gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: screenSize.width * 0.05, // 5% of screen width
                fontWeight: FontWeight.bold,
                color: blackColor, // Text to black
              ),
            ),
            SizedBox(
                height: screenSize.height * 0.015), // 1.5% of screen height
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: blackColor, // Icon to black
                  size: screenSize.width * 0.05, // 5% of screen width
                ),
                SizedBox(width: screenSize.width * 0.02), // 2% of screen width
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.04, // 4% of screen width
                      color: blackColor, // Text to black
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.01), // 1% of screen height
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: blackColor, // Icon to black
                  size: screenSize.width * 0.05, // 5% of screen width
                ),
                SizedBox(width: screenSize.width * 0.02), // 2% of screen width
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04, // 4% of screen width
                    color: blackColor, // Text to black
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.01), // 1% of screen height
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: blackColor, // Icon to black
                  size: screenSize.width * 0.05, // 5% of screen width
                ),
                SizedBox(width: screenSize.width * 0.02), // 2% of screen width
                Text(
                  hours,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04, // 4% of screen width
                    color: blackColor, // Text to black
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.02), // 2% of screen height
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final Uri url = Uri.parse(mapUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Could not open map',
                            style:
                                TextStyle(color: blackColor), // Text to black
                          ),
                          backgroundColor:
                              mustardColor, // Background to mustard
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  }
                },
                icon: Icon(
                  Icons.map,
                  color: blackColor, // Icon to black
                ),
                label: Text(
                  'Get Directions',
                  style: TextStyle(
                    color: blackColor, // Text to black
                    fontSize: screenSize.width * 0.04, // 4% of screen width
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mustardColor
                      .withOpacity(0.3), // Background to lighter mustard
                  padding: EdgeInsets.symmetric(
                    vertical:
                        screenSize.height * 0.015, // 1.5% of screen height
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.02), // 2% of screen width
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
