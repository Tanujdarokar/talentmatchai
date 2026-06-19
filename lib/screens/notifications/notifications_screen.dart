import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotification(
            'Ranking Completed',
            'AI Ranking for "Senior Backend Engineer" is ready to view.',
            '10 mins ago',
            Icons.auto_awesome,
            Colors.purple,
          ),
          _buildNotification(
            'New Candidate',
            'Alex Rivera just applied for "Product Manager".',
            '1 hour ago',
            Icons.person_add,
            Colors.blue,
          ),
          _buildNotification(
            'Interview Reminder',
            'Interview with James Wilson starts in 30 minutes.',
            '30 mins ago',
            Icons.calendar_today,
            Colors.green,
          ),
          _buildNotification(
            'Report Ready',
            'Monthly hiring analytics for August is available.',
            'Yesterday',
            Icons.bar_chart,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildNotification(String title, String body, String time, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(body),
        trailing: Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        onTap: () {},
      ),
    );
  }
}
