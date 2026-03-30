import 'package:aviaraassignment/data/models/user_model.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailHeader(context),
            const Divider(height: 40),
            _buildSectionTitle('Contact Information'),
            _buildDetailTile(Icons.email, 'Email', user.email),
            _buildDetailTile(Icons.phone, 'Phone', user.phone),
            _buildDetailTile(Icons.public, 'Website', user.website),
            const Divider(height: 40),
            _buildSectionTitle('Address'),
            _buildDetailTile(Icons.location_on, 'Street', user.address.street),
            _buildDetailTile(Icons.apartment, 'Suite', user.address.suite),
            _buildDetailTile(Icons.location_city, 'City', user.address.city),
            _buildDetailTile(Icons.map, 'Zipcode', user.address.zipcode),
            const Divider(height: 40),
            _buildSectionTitle('Company'),
            _buildDetailTile(Icons.business, 'Name', user.company.name),
            _buildDetailTile(Icons.stars, 'Catchphrase', user.company.catchPhrase),
            _buildDetailTile(Icons.work, 'BS', user.company.bs),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Text(
            user.name[0].toUpperCase(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '@${user.username}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
