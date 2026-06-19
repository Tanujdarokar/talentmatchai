import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                style: TextStyle(color: theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black)),
                decoration: InputDecoration(
                  hintText: 'Search for help...',
                  hintStyle: TextStyle(color: (theme.textTheme.bodySmall?.color ?? Colors.grey).withOpacity(0.5)),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  icon: const Icon(Icons.search, color: Colors.deepPurple),
                  filled: false,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            Text(
              'Popular Categories',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            
            // Categories Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildCategoryCard(context, 'Getting Started', Icons.rocket_launch_outlined, Colors.blue),
                _buildCategoryCard(context, 'Account & Privacy', Icons.person_outline, Colors.purple),
                _buildCategoryCard(context, 'Hiring AI', Icons.psychology_outlined, Colors.orange),
                _buildCategoryCard(context, 'Billing', Icons.credit_card_outlined, Colors.green),
              ],
            ),
            const SizedBox(height: 32),
            
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFaqItem(context, 'How does AI ranking work?', 'Our AI analyzes candidate resumes against job requirements using semantic matching...'),
            _buildFaqItem(context, 'Can I export candidate data?', 'Yes, you can export reports in CSV and PDF formats from the Reports screen.'),
            _buildFaqItem(context, 'How to schedule an interview?', 'Navigate to the Candidate Detail screen and click on "Schedule Interview".'),
            
            const SizedBox(height: 32),
            
            // Contact Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    'Still need help?',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our support team is available 24/7 to assist you with any questions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _contactButton(Icons.mail_outline, 'Email Us'),
                      const SizedBox(width: 16),
                      _contactButton(Icons.chat_bubble_outline, 'Live Chat'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 14,
                color: theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        iconColor: theme.colorScheme.primary,
        collapsedIconColor: (theme.textTheme.bodySmall?.color ?? Colors.grey).withOpacity(0.5),
        title: Text(
          question, 
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            fontSize: 15,
            color: theme.textTheme.titleMedium?.color ?? (isDark ? Colors.white : Colors.black),
          )
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer, 
              style: TextStyle(color: (theme.textTheme.bodyMedium?.color ?? Colors.grey).withOpacity(0.7), height: 1.5)
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
