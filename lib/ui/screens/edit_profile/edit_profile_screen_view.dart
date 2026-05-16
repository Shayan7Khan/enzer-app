import 'dart:io';

import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/core/services/file_picker_service.dart';
import 'package:enzer_app/core/services/supabase_storage_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileViewModel extends BaseViewModel {
  final CustomLogger log = CustomLogger(
    className: 'EditProfileScreenViewModel',
  );
  final _auth = locator<AuthService>();
  final _storage = locator<SupabaseStorageService>();
  final _filePicker = locator<FilePickerService>();

  bool _shouldRemovePhoto = false;
  File? selectedImage;
  String? currentAvatarUrl;

  String get userName => _auth.userProfile?.fullName ?? '';
  String get cnic {
    final raw = _auth.userProfile?.cnic ?? '';
    final digits = raw.replaceAll('-', '');
    if (digits.length != 13) return raw;
    return '${digits.substring(0, 5)}-${digits.substring(5, 12)}-${digits.substring(12)}';
  }

  String get phone {
    final raw = _auth.userProfile?.phone ?? '';
    if (raw.startsWith('+92')) return raw.substring(3);
    return raw;
  }

  EditProfileViewModel() {
    final url = _auth.userProfile?.avatarUrl;
    currentAvatarUrl = (url != null && url.isNotEmpty)
        ? '$url?t=${DateTime.now().millisecondsSinceEpoch}'
        : null;
  }

  Future<void> pickImage() async {
    final file = await _filePicker.pickImage();
    if (file != null) {
      selectedImage = file;
      _shouldRemovePhoto = false;
      notifyListeners();
    }
  }

  Future<void> onRemovePhoto() async {
    final userId = _auth.userProfile?.id;
    if (userId == null) return;

    setState(ViewState.busy);
    try {
      await _storage.deleteProfileImage(userId: userId);
      await _storage.updateProfileAvatarUrl(userId: userId, avatarUrl: null);
      await _auth.refreshProfile();

      selectedImage = null;
      currentAvatarUrl = null;
      _shouldRemovePhoto = false;

      await _auth.refreshProfile();
      selectedImage = null;
      currentAvatarUrl = null;
      _shouldRemovePhoto = false;
      Get.dialog(
        AlertDialog(
          title: const Text('Done'),
          content: const Text('Profile photo removed successfully.'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('OK')),
          ],
        ),
      );
    } catch (e) {
      log.e('onRemovePhoto error: $e');
    }
    setState(ViewState.idle);
  }

  Future<void> updateProfile() async {
    final userId = _auth.userProfile?.id;
    if (userId == null) return;

    if (selectedImage == null && !_shouldRemovePhoto) {
      Get.back();
      return;
    }

    setState(ViewState.busy);
    try {
      if (_shouldRemovePhoto) {
        await _storage.deleteProfileImage(userId: userId);
        await _storage.updateProfileAvatarUrl(userId: userId, avatarUrl: null);
      } else if (selectedImage != null) {
        final newAvatarUrl = await _storage.uploadProfileImage(
          userId: userId,
          imageFile: selectedImage!,
        );
        if (newAvatarUrl != null) {
          await _storage.updateProfileAvatarUrl(
            userId: userId,
            avatarUrl: newAvatarUrl,
          );
        }
      }

      await _auth.refreshProfile();

      // refresh local avatar url with cache buster
      final updatedUrl = _auth.userProfile?.avatarUrl;
      currentAvatarUrl = (updatedUrl != null && updatedUrl.isNotEmpty)
          ? '$updatedUrl?t=${DateTime.now().millisecondsSinceEpoch}'
          : null;
      await _auth.refreshProfile();
      Get.back();
      Get.dialog(
        AlertDialog(
          title: const Text('Success'),
          content: const Text('Profile photo updated successfully.'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('OK')),
          ],
        ),
      );
    } catch (e) {
      log.e('updateProfile error: $e');
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to update. Please try again.'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('OK')),
          ],
        ),
      );
    }
    setState(ViewState.idle);
  }
}
