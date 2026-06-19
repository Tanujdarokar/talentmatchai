import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/stat_card.dart';
import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalJobs = 0;
  int totalCandidates = 0;
  int interviewsToday = 0;
  int totalRanked = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final response = await ApiService.get("/dashboard/stats");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          totalJobs = data['totalJobs'];
          totalCandidates = data['totalCandidates'];
          interviewsToday = data['interviewsToday'];
          totalRanked = data['totalRanked'];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching stats: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('TalentMatch AI'),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? theme.cardColor : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Icon(Icons.notifications_none, size: 20, color: isDark ? Colors.white : Colors.black87),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;
          
          return RefreshIndicator(
            onRefresh: _fetchStats,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.fullName.split(' ')[0] ?? 'Recruiter'}!',
                            style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                          ),
                          Text(
                            'Welcome to your workspace',
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.deepPurple.shade50,
                        backgroundImage: user != null 
                            ? NetworkImage('https://i.pravatar.cc/150?u=${user.id}')
                            : const NetworkImage('https://i.pravatar.cc/150?img=47'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Hiring Overview'),
                  const SizedBox(height: 16),
                  _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          StatCard(title: 'Active Jobs', value: '$totalJobs', icon: Icons.work_rounded, color: Colors.blue),
                          StatCard(title: 'Candidates', value: '$totalCandidates', icon: Icons.group_rounded, color: Colors.purple),
                          StatCard(title: 'Interviews', value: '$interviewsToday Today', icon: Icons.calendar_today_rounded, color: Colors.orange),
                          StatCard(title: 'Ranked', value: '$totalRanked', icon: Icons.auto_awesome_rounded, color: Colors.green),
                        ],
                      ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Quick Actions'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAction(context, 'Pipeline', Icons.account_tree_outlined, Colors.indigo, AppRoutes.pipeline),
                        _buildQuickAction(context, 'Analytics', Icons.bar_chart_rounded, Colors.pink, AppRoutes.analytics),
                        _buildQuickAction(context, 'AI Search', Icons.psychology_outlined, Colors.amber.shade800, AppRoutes.search),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle(context, 'Recent Activity'),
                      TextButton(onPressed: () {}, child: const Text('See All')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    context,
                    'AI Engine connected to backend',
                    'Just now',
                    Icons.sync,
                    Colors.green.withOpacity(0.1),
                    Colors.green,
                  ),
                  _buildActivityItem(
                    context,
                    'Database synchronized successfully',
                    '1 min ago',
                    Icons.check_circle_outline,
                    Colors.blue.withOpacity(0.1),
                    Colors.blue,
                  ),
                  const SizedBox(height: 100), // Added padding to prevent overlap with Nav bar
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String text, String time, IconData icon, Color bgColor, Color iconColor) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(time, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon, Color color, String route) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
