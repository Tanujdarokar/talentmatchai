import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _companyController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.fullName);
    _companyController = TextEditingController(text: user?.company);
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.put("/auth/profile", {
        "fullName": _nameController.text,
        "company": _companyController.text,
      });

      if (response.statusCode == 200) {
        await context.read<AuthProvider>().fetchProfile();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint("Update error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Account Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Picture Section
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2), width: 4),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: theme.cardColor,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300?u=${user?.id}'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Text('Change Profile Photo', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),
            
            // Form Fields
            _buildInputSection(
              context,
              label: 'PERSONAL INFORMATION',
              children: [
                _buildTextField(
                  controller: TextEditingController(text: user?.email),
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  readOnly: true,
                  helper: 'Primary email cannot be changed',
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildInputSection(
              context,
              label: 'ORGANIZATION',
              children: [
                _buildTextField(
                  controller: _companyController,
                  label: 'Company Name',
                  icon: Icons.business_outlined,
                ),
              ],
            ),
            const SizedBox(height: 50),
            
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(BuildContext context, {required String label, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    String? helper,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(fontWeight: FontWeight.w600, color: readOnly ? theme.textTheme.bodySmall?.color?.withOpacity(0.6) : null),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.7)),
          helperText: helper,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
