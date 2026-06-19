import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/mock_models.dart';
import '../../services/api_service.dart';
import '../../widgets/candidate_card.dart';
import '../candidates/candidate_detail_screen.dart';

class AiSearchScreen extends StatefulWidget {
  const AiSearchScreen({super.key});

  @override
  State<AiSearchScreen> createState() => _AiSearchScreenState();
}

class _AiSearchScreenState extends State<AiSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Candidate> _results = [];
  bool _isLoading = false;

  Future<void> _performAiSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _results = [];
    });

    try {
      final response = await ApiService.post("/candidates/ai-search", {"query": query});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          _results = data.map((c) => Candidate.fromJson(c)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to search");
      }
    } catch (e) {
      debugPrint("AI Search error: $e");
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AI Search failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Talent Search')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Describe the ideal candidate in your own words.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'e.g., "Show senior flutter developers with node.js experience"',
                    prefixIcon: const Icon(Icons.psychology, color: Colors.deepPurple),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: theme.cardColor,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _performAiSearch(_searchController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Search with AI Engine'),
                  ),
                ),
              ],
            ),
          ),
          
          if (_results.isEmpty && !_isLoading) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Suggested Queries', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSuggestion('Flutter developers in Hyderabad'),
                      _buildSuggestion('Full stack engineers with 5+ yrs exp'),
                      _buildSuggestion('Backend leads proficient in Node.js'),
                    ],
                  ),
                ],
              ),
            ),
          ],

          if (_isLoading) ...[
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ] else if (_results.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'AI Found ${_results.length} relevant matches',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _results.length,
                itemBuilder: (context, index) => CandidateCard(candidate: _results[index]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        _searchController.text = text;
        _performAiSearch(text);
      },
      avatar: const Icon(Icons.search, size: 14),
    );
  }
}
