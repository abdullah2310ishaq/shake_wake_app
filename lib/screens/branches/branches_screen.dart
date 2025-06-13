import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Branches',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBranchCard(
            context,
            'ShakeWake I-8 Markaz',
            'Shop #123, I-8 Markaz, Islamabad',
            '+92 300 1234567',
            'Mon-Sun: 10:00 AM - 12:00 AM',
            'https://maps.google.com/?q=I-8+Markaz+Islamabad',
          ),
          const SizedBox(height: 16),
          _buildBranchCard(
            context,
            'ShakeWake F-7 Markaz',
            'Shop #45, F-7 Markaz, Islamabad',
            '+92 300 2345678',
            'Mon-Sun: 10:00 AM - 12:00 AM',
            'https://maps.google.com/?q=F-7+Markaz+Islamabad',
          ),
          const SizedBox(height: 16),
          _buildBranchCard(
            context,
            'ShakeWake Blue Area',
            'Shop #67, Blue Area, Islamabad',
            '+92 300 3456789',
            'Mon-Sun: 10:00 AM - 12:00 AM',
            'https://maps.google.com/?q=Blue+Area+Islamabad',
          ),
          const SizedBox(height: 16),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  hours,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                        const SnackBar(
                          content: Text('Could not open map'),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.map, color: Colors.white),
                label: const Text(
                  'Get Directions',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
