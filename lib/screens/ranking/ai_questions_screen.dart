import 'package:flutter/material.dart';

class AiQuestionsScreen extends StatelessWidget {
  const AiQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Interview Questions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildQuestionCategory('Technical Questions', [
            'How do you manage complex state in a large-scale Flutter application?',
            'Explain the difference between Provider, Riverpod, and Bloc.',
            'What are the performance considerations when using custom painters?',
          ]),
          const SizedBox(height: 24),
          _buildQuestionCategory('Behavioral Questions', [
            'Tell me about a time you had to deal with a difficult stakeholder.',
            'How do you prioritize tasks when you have multiple competing deadlines?',
          ]),
          const SizedBox(height: 24),
          _buildQuestionCategory('Situational Questions', [
            'If a critical production bug is found right before a release, what is your process?',
          ]),
        ],
      ),
    );
  }

  Widget _buildQuestionCategory(String title, List<String> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        const SizedBox(height: 12),
        ...questions.map((q) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.help_outline, color: Colors.deepPurple),
                const SizedBox(width: 12),
                Expanded(child: Text(q, style: const TextStyle(fontSize: 16))),
                IconButton(icon: const Icon(Icons.copy, size: 20), onPressed: () {}),
              ],
            ),
          ),
        )),
      ],
    );
  }
}
