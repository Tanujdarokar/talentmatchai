import 'package:flutter/material.dart';

class PipelineScreen extends StatelessWidget {
  const PipelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hiring Pipeline')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumn('Applied', 5, [
                _buildCandidateCard('Alex Rivera', 85),
                _buildCandidateCard('Sarah Smith', 78),
              ]),
              _buildColumn('Shortlisted', 3, [
                _buildCandidateCard('James Wilson', 94),
                _buildCandidateCard('Elena Gilbert', 88),
              ]),
              _buildColumn('Interview', 2, [
                _buildCandidateCard('Marcus Chen', 72),
              ]),
              _buildColumn('Offered', 1, [
                _buildCandidateCard('Sophia Loren', 91),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(String title, int count, List<Widget> cards) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12)),
                  child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: cards,
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Candidate'),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(String name, int score) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Match: $score%', style: TextStyle(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                const Icon(Icons.more_horiz, size: 16, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
