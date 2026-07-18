
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/services/api_service.dart';
import './sub_pages/personal_info_page.dart';
import './sub_pages/notifications_page.dart';
import './sub_pages/security_page.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? _profileData;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // استدعاء جلب البيانات فور تحميل الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfile();
    });
  }

  Future<void> _fetchProfile() async {
    final authState = context.read<AuthBloc>().state;
    String? userId;

    if (authState is AuthAuthenticated) {
      userId = authState.userId ?? ApiService.currentUserId;
    } else {
      userId = ApiService.currentUserId;
    }

    if (userId != null && userId.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print("FETCHING PROFILE FOR USER ID = $userId");

      final result = await ApiService.getProfile(userId);
      print("PROFILE RESPONSE = ${result['data']}");

      if (mounted) {
        setState(() {
          if (result['success']) {
            _profileData = result['data'];
            // تحديث البيانات في ApiService أيضاً للاتساق
            ApiService.currentUserName = _profileData?['fullName'];
          } else {
            _error = result['message'];
          }
          _isLoading = false;
        });
      }
    } else {
      print("ERROR: User ID is null, cannot fetch profile");
      setState(() {
        _error = "User not identified. Please try logging in again.";
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final photoStatus = await Permission.photos.request();
      final storageStatus = await Permission.storage.request();

      if (!photoStatus.isGranted && !storageStatus.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission to access photos is required')),
          );
        }
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxWidth: 600,
      );

      if (image == null) return;

      final userId = ApiService.currentUserId;
      if (userId != null) {
        setState(() => _isUploading = true);

        final result = await ApiService.uploadProfileImage(userId, image.path);
        
        if (mounted) {
          setState(() => _isUploading = false);
          if (result['success']) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile picture updated successfully')),
            );
            await Future.delayed(const Duration(milliseconds: 500));
            _fetchProfile();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload image: ${result['message']}')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated && ApiService.authToken == null) {
            return const Center(child: Text('Please log in to view your profile'));
          }

          final userEmail = (state is AuthAuthenticated) ? state.email : "";
          final fullName = _profileData?['fullName'] ?? userEmail.split('@')[0];
          final email = _profileData?['email'] ?? userEmail;
          final role = _profileData?['role'] ?? 'Farmer';
          
          final profileImageUrl = (_profileData?['profileImageUrl'] ?? _profileData?['imageUrl'])?.toString();

          return RefreshIndicator(
            onRefresh: _fetchProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  if (_isLoading || _isUploading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: LinearProgressIndicator(color: AppColors.primaryGreen),
                    ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  _buildProfileHeader(context, fullName, email, role, profileImageUrl),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Account Settings'),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    icon: Icons.person_outline,
                    title: 'Edit Personal Information',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalInfoPage(initialData: _profileData),
                        ),
                      );
                      if (result == true) _fetchProfile();
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.lock_outline,
                    title: 'Security & Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecurityPage(),
                        ),
                      );
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
  text: 'Logout',
  variant: ButtonVariant.secondary,
  onPressed: () {
    context.read<AuthBloc>().add(LogoutRequested());
    context.go('/login');
  },
),

const SizedBox(height: 16),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: _deleteAccount,
    icon: const Icon(
      Icons.delete_forever,
      color: Colors.red,
    ),
    label: const Text(
      'Delete Account',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.red),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
),

const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String fullName,
    String email,
    String role,
    String? profileImageUrl,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: _isUploading ? null : _pickAndUploadImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primaryGreen,
                backgroundImage: (profileImageUrl != null && profileImageUrl.isNotEmpty)
                    ? NetworkImage(profileImageUrl)
                    : null,
                child: (profileImageUrl == null || profileImageUrl.isEmpty)
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _isUploading ? null : _pickAndUploadImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isUploading ? Colors.grey : AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          fullName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            role,
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          email,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CustomCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
Future<void> _deleteAccount() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text("Delete Account"),
      content: const Text(
        "Are you sure you want to permanently delete your account?\n\nThis action cannot be undone.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  final userId = int.parse(ApiService.currentUserId!);

  final result = await ApiService.deleteAccount(userId);

  if (!mounted) return;

  if (result['success']) {
  final prefs = await SharedPreferences.getInstance();

  // امسح كل بيانات الجلسة
  await prefs.clear();

  ApiService.clearAuthToken();

  if (!mounted) return;

  context.go('/login');
} else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}
