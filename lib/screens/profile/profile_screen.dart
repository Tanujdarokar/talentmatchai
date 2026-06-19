import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;
          
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, user),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(context, 'ACCOUNT'),
                      _buildMenuCard(context, [
                        _buildMenuTile(
                          context,
                          icon: Icons.person_rounded,
                          color: Colors.blue,
                          title: 'Account Settings',
                          subtitle: 'Full Name, Company, Profile photo',
                          onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.notifications_active_rounded,
                          color: Colors.orange,
                          title: 'Notifications',
                          subtitle: 'Email, Push, Candidate alerts',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen(title: 'Notifications'))),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, 'PREFERENCES'),
                      _buildMenuCard(context, [
                        _buildMenuTile(
                          context,
                          icon: Icons.palette_rounded,
                          color: Colors.purple,
                          title: 'Appearance',
                          subtitle: 'Theme Mode (Light/Dark/System)',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen(title: 'Appearance'))),
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.security_rounded,
                          color: Colors.green,
                          title: 'Privacy & Security',
                          subtitle: 'Password, Two-factor auth',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen(title: 'Privacy & Security'))),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, 'SUPPORT'),
                      _buildMenuCard(context, [
                        _buildMenuTile(
                          context,
                          icon: Icons.help_center_rounded,
                          color: Colors.indigo,
                          title: 'Help & Support',
                          subtitle: 'FAQ, Live Chat, Contact Us',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
                        ),
                        _buildMenuTile(
                          context,
                          icon: Icons.info_rounded,
                          color: Colors.teal,
                          title: 'About TalentMatch AI',
                          subtitle: 'Version 1.0.0, Terms, Policies',
                          onTap: () => _showAboutDialog(context),
                        ),
                      ]),
                      const SizedBox(height: 40),
                      _buildLogoutButton(context, authProvider),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TalentMatch AI',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.psychology, size: 40, color: Colors.deepPurple),
      children: [
        const Text('Smarter Hiring with AI.'),
        const SizedBox(height: 12),
        const Text('© 2023 TalentMatch AI Corp.'),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, user) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.deepPurple.shade800,
                Colors.deepPurple.shade500,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300?u=${user.id}'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${user.role} @ ${user.company}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.dividerColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chevron_right_rounded, size: 20, color: theme.textTheme.bodySmall?.color?.withOpacity(0.4)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? Colors.red.withOpacity(0.1) : const Color(0xFFFFEEF0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            authProvider.logout();
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          },
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                SizedBox(width: 12),
                Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
