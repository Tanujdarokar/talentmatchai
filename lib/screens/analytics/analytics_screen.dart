import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hiring Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartCard(
              context,
              'Hiring Funnel',
              'Candidate conversion through stages',
              Column(
                children: [
                  _buildFunnelStage('Sourced', 450, Colors.blue, 1.0),
                  _buildFunnelStage('Shortlisted', 120, Colors.purple, 0.7),
                  _buildFunnelStage('Interviewed', 45, Colors.orange, 0.4),
                  _buildFunnelStage('Offered', 12, Colors.green, 0.2),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildChartCard(
              context,
              'Top Skills in Demand',
              'Most requested skills in active jobs',
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildSkillStat('Flutter', 85),
                  _buildSkillStat('Python', 70),
                  _buildSkillStat('Node.js', 65),
                  _buildSkillStat('React', 60),
                  _buildSkillStat('Go', 40),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildChartCard(
              context,
              'Candidate Source Distribution',
              'Where your candidates are coming from',
              SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar('LinkedIn', 0.8, Colors.blue),
                    _buildBar('Referral', 0.4, Colors.green),
                    _buildBar('Indeed', 0.6, Colors.orange),
                    _buildBar('Careers', 0.3, Colors.purple),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, String title, String subtitle, Widget content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 24),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildFunnelStage(String label, int count, Color color, double widthFactor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: widthFactor,
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillStat(String skill, int percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(skill, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          width: 80,
          height: 8,
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String label, double heightFactor, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 150 * heightFactor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
