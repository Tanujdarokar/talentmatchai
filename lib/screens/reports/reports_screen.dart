import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Exports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReportSection('Available Reports', [
            _buildReportItem('Ranked Candidate Report', 'CSV, PDF'),
            _buildReportItem('Hiring Pipeline Analytics', 'Excel, PDF'),
            _buildReportItem('Recruiter Activity Summary', 'PDF'),
          ]),
          const SizedBox(height: 24),
          _buildReportSection('Recent Exports', [
            _buildExportItem('candidates_backend_eng.pdf', 'Aug 24, 2023'),
            _buildExportItem('hiring_trends_q2.csv', 'Aug 20, 2023'),
          ]),
        ],
      ),
    );
  }

  Widget _buildReportSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildReportItem(String title, String formats) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('Formats: $formats'),
        trailing: const Icon(Icons.download),
        onTap: () {},
      ),
    );
  }

  Widget _buildExportItem(String fileName, String date) {
    return ListTile(
      leading: const Icon(Icons.insert_drive_file, color: Colors.grey),
      title: Text(fileName),
      subtitle: Text('Exported on $date'),
      trailing: TextButton(onPressed: () {}, child: const Text('Open')),
    );
  }
}
