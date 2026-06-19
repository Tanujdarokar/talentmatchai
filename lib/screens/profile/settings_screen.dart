import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String title;
  const SettingsScreen({super.key, required this.title});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailNotif = true;
  bool _pushNotif = true;
  bool _matchAlerts = true;
  bool _twoFactor = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title == 'Notifications') _buildNotificationsUI(theme),
            if (widget.title == 'Appearance') _buildAppearanceUI(theme),
            if (widget.title == 'Privacy & Security') _buildPrivacyUI(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsUI(ThemeData theme) {
    return Column(
      children: [
        _buildSettingsGroup(
          theme,
          title: 'SYSTEM ALERTS',
          children: [
            _buildSwitchTile('Email Notifications', 'Updates sent to your inbox', _emailNotif, (v) => setState(() => _emailNotif = v)),
            _buildSwitchTile('Push Notifications', 'Real-time mobile alerts', _pushNotif, (v) => setState(() => _pushNotif = v)),
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsGroup(
          theme,
          title: 'CANDIDATE UPDATES',
          children: [
            _buildSwitchTile('AI Match Alerts', 'When perfect matches are found', _matchAlerts, (v) => setState(() => _matchAlerts = v)),
          ],
        ),
      ],
    );
  }

  Widget _buildAppearanceUI(ThemeData theme) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return _buildSettingsGroup(
          theme,
          title: 'THEME PREFERENCE',
          children: [
            _buildRadioTile<ThemeMode>(
              title: 'Light Mode', 
              icon: Icons.light_mode_outlined, 
              value: ThemeMode.light, 
              groupValue: provider.themeMode, 
              onChanged: (v) => provider.setThemeMode(v!)
            ),
            _buildRadioTile<ThemeMode>(
              title: 'Dark Mode', 
              icon: Icons.dark_mode_outlined, 
              value: ThemeMode.dark, 
              groupValue: provider.themeMode,
              onChanged: (v) => provider.setThemeMode(v!)
            ),
            _buildRadioTile<ThemeMode>(
              title: 'System Default', 
              icon: Icons.settings_brightness_outlined, 
              value: ThemeMode.system, 
              groupValue: provider.themeMode, 
              onChanged: (v) => provider.setThemeMode(v!)
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrivacyUI(ThemeData theme) {
    return Column(
      children: [
        _buildSettingsGroup(
          theme,
          title: 'ACCOUNT SECURITY',
          children: [
            _buildActionTile(
              context,
              title: 'Change Password',
              icon: Icons.lock_outline_rounded,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
            ),
            _buildSwitchTile('Two-Factor Authentication', 'Extra layer of security', _twoFactor, (v) => setState(() => _twoFactor = v)),
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsGroup(
          theme,
          title: 'DATA PRIVACY',
          children: [
            _buildActionTile(context, title: 'Manage Data Permissions', icon: Icons.privacy_tip_outlined, onTap: () {}),
            _buildActionTile(context, title: 'Download My Data', icon: Icons.download_outlined, onTap: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsGroup(ThemeData theme, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.textTheme.bodySmall?.color?.withOpacity(0.5), letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String sub, bool val, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      value: val,
      activeColor: Theme.of(context).colorScheme.primary,
      onChanged: onChanged,
    );
  }

  Widget _buildRadioTile<T>({required String title, required IconData icon, required T value, required T groupValue, required Function(T?) onChanged}) {
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
