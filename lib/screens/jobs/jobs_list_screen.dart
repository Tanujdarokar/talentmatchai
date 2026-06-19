import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/mock_models.dart';
import '../../widgets/job_card.dart';
import '../../services/api_service.dart';
import '../../services/database_helper.dart';
import 'job_detail_screen.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  List<Job> _jobs = [];
  bool _isLoading = true;
  String _selectedDepartment = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _departments = ['All', 'Engineering', 'Product', 'Design', 'Sales', 'Marketing'];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    // 1. Try to load from Local DB first for instant UI
    final localJobs = await DatabaseHelper.instance.getJobs(
      department: _selectedDepartment == 'All' ? null : _selectedDepartment
    );
    if (localJobs.isNotEmpty && mounted) {
      setState(() {
        _jobs = localJobs;
        _isLoading = false;
      });
    }

    // 2. Fetch from API in background
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      String endpoint = "/jobs?limit=100";
      if (_selectedDepartment != 'All') {
        endpoint += "&department=$_selectedDepartment";
      }

      final response = await ApiService.get(endpoint);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> jobsList = data['data'];
        final List<Job> remoteJobs = jobsList.map((json) => Job.fromJson(json)).toList();
        
        // 3. Save to Local DB
        await DatabaseHelper.instance.saveJobs(remoteJobs);

        if (mounted) {
          setState(() {
            _jobs = remoteJobs;
            if (_searchController.text.isNotEmpty) {
              _jobs = _jobs.where((job) => 
                job.title.toLowerCase().contains(_searchController.text.toLowerCase())
              ).toList();
            }
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching jobs: $e. Using local data.");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offline: Loading from cache'), duration: Duration(seconds: 2)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Management'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {}); // Local filter
              },
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _departments.map((dept) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(dept),
                  selected: _selectedDepartment == dept,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDepartment = dept;
                    });
                    _fetchJobs();
                  },
                  selectedColor: Colors.deepPurple.shade100,
                  checkmarkColor: Colors.deepPurple,
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchJobs,
                    child: _buildJobsList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    final filteredJobs = _searchController.text.isEmpty 
      ? _jobs 
      : _jobs.where((job) => job.title.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

    if (filteredJobs.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) => JobCard(
        job: filteredJobs[index],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailScreen(job: filteredJobs[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No jobs found', style: TextStyle(color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Try changing your filters', style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}
