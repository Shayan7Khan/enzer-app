import 'dart:io';
import 'package:enzer_app/core/others/logger_customizations/custom_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final log = CustomLogger(className: 'SupabaseStorageService');
  final _supabase = Supabase.instance.client;
  static const _bucket = 'profile-images';

  static const _supportedFormats = {
    'png': 'image/png',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'webp': 'image/webp',
    'avif': 'image/avif',
    'gif': 'image/gif',
    'ico': 'image/x-icon',
    'svg': 'image/svg+xml',
    'heic': 'image/heic',
    'bmp': 'image/bmp',
    'tiff': 'image/tiff',
    'tif': 'image/tiff',
  };

  String _getContentType(String extension) {
    return _supportedFormats[extension.toLowerCase()] ?? 'image/jpeg';
  }

  bool _isSupportedFormat(String extension) {
    return _supportedFormats.containsKey(extension.toLowerCase());
  }

  //uploading to supabase
  Future<String?> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final extension = imageFile.path.split('.').last.toLowerCase();

      if (!_isSupportedFormat(extension)) {
        log.e('Unsupported image format: $extension');
        return null;
      }

      // check file size — max 25MB
      final fileSize = await imageFile.length();
      if (fileSize > 25 * 1024 * 1024) {
        log.e('Image too large: ${fileSize ~/ (1024 * 1024)}MB — max 25MB');
        return null;
      }

      final contentType = _getContentType(extension);
      final fileName = '$userId/avatar.$extension';
      final bytes = await imageFile.readAsBytes();

      await _supabase.storage
          .from(_bucket)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: contentType, upsert: true),
          );

      final url = _supabase.storage.from(_bucket).getPublicUrl(fileName);
      log.d('Uploaded profile image: $url');
      return url;
    } catch (e) {
      log.e('uploadProfileImage error: $e');
      return null;
    }
  }

  //deleting profile image
  Future<bool> deleteProfileImage({required String userId}) async {
    try {
      final files = await _supabase.storage.from(_bucket).list(path: userId);
      if (files.isEmpty) return true;

      final paths = files.map((f) => '$userId/${f.name}').toList();
      await _supabase.storage.from(_bucket).remove(paths);
      log.d('Deleted profile image for user: $userId');
      return true;
    } catch (e) {
      log.e('deleteProfileImage error: $e');
      return false;
    }
  }

  String getProfileImageUrl({
    required String userId,
    String extension = 'jpg',
  }) {
    return _supabase.storage
        .from(_bucket)
        .getPublicUrl('$userId/avatar.$extension');
  }

  //updating profile image
  Future<bool> updateProfileAvatarUrl({
    required String userId,
    required String? avatarUrl,
  }) async {
    try {
      await _supabase
          .from('profiles')
          .update({'avatar_url': avatarUrl})
          .eq('id', userId);
      log.d('Updated avatar_url for user: $userId');
      return true;
    } catch (e) {
      log.e('updateProfileAvatarUrl error: $e');
      return false;
    }
  }
}
