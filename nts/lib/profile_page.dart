import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _supabase = Supabase.instance.client;

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isEditing = false;
  bool isUploading = false;
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final res = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        profile = res;
        nameController.text = profile?['name'] ?? '';
        addressController.text = profile?['address'] ?? '';
        passController.clear();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
      }
    }
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase
          .from('profiles')
          .update({
            'name': nameController.text.trim(),
            'address': addressController.text.trim(),
          })
          .eq('id', user.id);

      if (passController.text.trim().isNotEmpty) {
        await _supabase.auth.updateUser(
          UserAttributes(password: passController.text.trim()),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }

      setState(() => isEditing = false);
      await loadUserProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    }
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (pickedFile == null) return;

    setState(() => isUploading = true);

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to change profile picture');
      }

      // Generate a unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String filePath = '${user.id}/avatar_$timestamp.jpg';

      // Platform-specific upload handling
      if (kIsWeb) {
        // For web: Use the XFile directly
        final bytes = await pickedFile.readAsBytes();

        // Upload bytes directly - this works on web
        await _supabase.storage
            .from('avatars')
            .uploadBinary(
              filePath,
              bytes,
              fileOptions: const FileOptions(
                upsert: true,
                contentType: 'image/jpeg',
              ),
            );
      } else {
        // For mobile: Use File object
        final file = File(pickedFile.path);
        await _supabase.storage
            .from('avatars')
            .upload(
              filePath,
              file,
              fileOptions: const FileOptions(
                upsert: true,
                contentType: 'image/jpeg',
              ),
            );
      }

      // Get the public URL with cache busting
      final String baseUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(filePath);
      final String publicUrl = '$baseUrl?t=$timestamp';

      // Update profile with the new avatar URL
      await _supabase
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', user.id);

      // Refresh the profile data
      await loadUserProfile();

      setState(() => isUploading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
          ),
        );
      }
    } catch (e) {
      setState(() => isUploading = false);
      debugPrint('Upload error: $e');

      // Show user-friendly error message
      String errorMessage = 'Failed to upload image';
      if (e is StorageException) {
        errorMessage = 'Storage error: ${e.message}';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Permission denied. Check storage policies.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final avatarUrl = profile?['avatar_url'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.pink[300],
      ),
      body: Center(
        child: SizedBox(
          width: 350,
          child: Card(
            color: Colors.pink[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: isEditing
                  ? _buildEditForm(avatarUrl)
                  : _buildViewMode(avatarUrl),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewMode(String? avatarUrl) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[200],
              backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl == null || avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
            Positioned(
              bottom: -5,
              right: -5,
              child: InkWell(
                onTap: isUploading ? null : pickAndUploadImage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: isUploading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.pink,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          color: Colors.pink[300],
                          size: 24,
                        ),
                ),
              ),
            ),
          ],
        ),
        if (isUploading) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
        ],
        const SizedBox(height: 24),
        Text(
          profile?['name'] ?? 'No name set',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _supabase.auth.currentUser?.email ?? 'No email',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        if (profile?['address'] != null &&
            (profile!['address'] as String).trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            profile!['address'],
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => setState(() => isEditing = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[300],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildEditForm(String? avatarUrl) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: isUploading ? null : pickAndUploadImage,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              child: isUploading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                    )
                  : (avatarUrl == null || avatarUrl.isEmpty)
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
          ),
          if (isUploading) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
          const SizedBox(height: 24),
          // Name field
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          // Password field
          TextFormField(
            controller: passController,
            decoration: const InputDecoration(
              labelText: 'New Password (optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (v) {
              if (v == null || v.isEmpty) return null;
              return v.length < 6 ? 'Min 6 characters' : null;
            },
          ),
          const SizedBox(height: 16),
          // Address field
          TextFormField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
            ),
            validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => isEditing = false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                onPressed: updateProfile,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
