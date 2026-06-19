import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/mock_models.dart';
import '../../widgets/candidate_card.dart';
import '../../services/api_service.dart';
import '../../services/database_helper.dart';
import 'candidate_detail_screen.dart';

class CandidatesListScreen extends StatefulWidget {
  const CandidatesListScreen({super.key});

  @override
  State<CandidatesListScreen> createState() => _CandidatesListScreenState();
}

class _CandidatesListScreenState extends State<CandidatesListScreen> {
  List<Candidate> _candidates = [];
  bool _isLoading = true;
  String _selectedFilter = 'Top Matches';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['Top Matches', 'Newest', 'Exp: 5+ years', 'Exp: 0-2 years'];

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    final localCandidates = await DatabaseHelper.instance.getCandidates(
      sortBy: _selectedFilter == 'Newest' ? '-createdAt' : 'matchScore',
      search: _searchController.text
    );
    if (localCandidates.isNotEmpty && mounted) {
      setState(() {
        _candidates = localCandidates;
        _isLoading = false;
      });
    }
    _fetchCandidates();
  }

  Future<void> _fetchCandidates() async {
    try {
      String endpoint = "/candidates?limit=100";
      
      if (_selectedFilter == 'Top Matches') endpoint += "&sort=-matchScore";
      else if (_selectedFilter == 'Newest') endpoint += "&sort=-createdAt";

      if (_selectedFilter == 'Exp: 5+ years') endpoint += "&experience[gte]=5";
      else if (_selectedFilter == 'Exp: 0-2 years') endpoint += "&experience[lte]=2";

      if (_searchController.text.isNotEmpty) endpoint += "&search=${_searchController.text}";

      final response = await ApiService.get(endpoint);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> candidateList = data['data'];
        final List<Candidate> remoteCandidates = candidateList.map((json) => Candidate.fromJson(json)).toList();
        
        await DatabaseHelper.instance.saveCandidates(remoteCandidates);

        if (mounted) {
          setState(() {
            _candidates = remoteCandidates;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching candidates: $e. Using cache.");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offline: Showing cached talent pool')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidates'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _fetchCandidates(),
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _fetchCandidates();
                  },
                ),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ActionChip(
                  avatar: const Icon(Icons.tune, size: 16), 
                  label: const Text('Reset'), 
                  onPressed: () {
                    setState(() {
                      _selectedFilter = 'Top Matches';
                      _searchController.clear();
                    });
                    _fetchCandidates();
                  }
                ),
                const SizedBox(width: 8),
                ..._filters.map((filter) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                        _fetchCandidates();
                      }
                    },
                    selectedColor: Colors.deepPurple.shade100,
                  ),
                )).toList(),
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchCandidates,
                    child: _candidates.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _candidates.length,
                          itemBuilder: (context, index) => CandidateCard(
                            candidate: _candidates[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CandidateDetailScreen(candidate: _candidates[index]),
                                ),
                              );
                            },
                          ),
                        ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No candidates found', style: TextStyle(color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Try changing your search or filters', style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}
